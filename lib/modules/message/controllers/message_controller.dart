import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/message/participant_model.dart';

import '../../../core/services/socket_service.dart';
import '../../../data/models/message/message_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MessageController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();

  final SocketService _socketService = Get.find<SocketService>();
  late String currentUserId;
  late String _conversationId;
  late ParticipantModel participantModel;
  final storage = GetStorage();
  final scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  PaginationHelper<MessageModel> messageHelper = PaginationHelper<MessageModel>();
  bool shouldScrollToBottom = true;

  // ─── Image picking state ───────────────────────────────────────────────────
  final ImagePicker _picker = ImagePicker();
  RxList<File> selectedImages = <File>[].obs;
  RxBool isUploadingImages = false.obs;

  @override
  void onInit() {

    currentUserId = storage.read( userIdKey );
    participantModel = Get.arguments as ParticipantModel;
    _conversationId = participantModel.conversationId;

    initMessageHelper();
    initSocket();

    ever(messages, (_) => _scrollToBottom());

    _loadInitialMessages();
    super.onInit();
  }

  void initMessageHelper(){
    messageHelper.init(
        endPoint: (page) => ApiEndpoints.allMessages(page: page, conversationId: _conversationId),
        fromJson: (json) => MessageModel.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: scrollController,
      isChat: true
    );

    ever(messageHelper.fetchedItems, (fetched) {
      if (fetched.isEmpty) return;
      shouldScrollToBottom = false;
      // Prepend older messages (they go to the end of the list = visually top)
      messages.addAll(fetched);
      shouldScrollToBottom = true;
    });
  }

  Future<void> _loadInitialMessages() async {
    await messageHelper.fetch(
        isRefresh: true,
      shouldPrint: true
    );
    messages.assignAll(messageHelper.items.toList());
  }

  void handleSend() {
    print("Handling send");
    final text = textController.text.trim();

    if( selectedImages.isNotEmpty ){
      print("Images found");
      _handleImageSend(captionText: text.isEmpty ? "image" : text);
      return;
    }


    if (text.isEmpty) return;
    sendMessage(text);
    textController.clear();
  }

  void _scrollToBottom() {
    if( !shouldScrollToBottom ){
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          //scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxBool isTyping = false.obs;
  final isConnected = false.obs;

  final _subscriptions = <StreamSubscription>[];
  Timer? _typingTimer;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  void initSocket() {
    final String accessToken = storage.read( accessTokenKey );
    _socketService.connect(accessToken);
    _registerStreamListeners();

    // Wait for connection then join room and mark as read
    _subscriptions.add(
      _socketService.onConnectionChange.listen((connected) {
        isConnected.value = connected;
        if (connected) {
          _socketService.joinRoom(_conversationId);
          _socketService.markAsRead(_conversationId);
        }
      }),
    );
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    textController.dispose();
    scrollController.dispose();
    _socketService.disconnect();
    super.onClose();
  }

  void sendMessage(String text) {

    final trimmed = text.trim();
    if (trimmed.isEmpty || _conversationId == null) return;

    final tempId = _generateTempId();
    final optimistic = MessageModel.optimistic(
      tempId: tempId,
      conversationId: _conversationId,
      senderId: currentUserId,
      message: trimmed,
    );

    messages.insert(0, optimistic);

    _socketService.sendMessage(
      conversationId: _conversationId,
      message: trimmed,
    );
  }

  // ─── Image picking ─────────────────────────────────────────────────────────

  /// Opens gallery for multi-image selection, compresses each, adds to [selectedImages].
  Future<void> pickImages() async {
    final List<XFile> picked = await _picker.pickMultiImage();
    if (picked.isEmpty) return;

    final List<File> compressed = [];
    for (final xFile in picked) {
      final file = File(xFile.path);
      final compressedFile = await compressImage(file);
      compressed.add(compressedFile ?? file);
    }
    selectedImages.addAll(compressed);
  }

  /// Removes a staged image by index.
  void removeSelectedImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  /// Clears all staged images.
  void clearSelectedImages() => selectedImages.clear();

  // ─── Image compress ───────────────────────────────────────────────────────

  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
      format: CompressFormat.jpeg
    );

    return result != null ? File(result.path) : null;
  }

  // ─── Image upload + send ──────────────────────────────────────────────────

  /// Uploads all [selectedImages] to your server, then sends the image message via socket.
  /// Replace [_uploadImagesToServer] with your actual API call.
  Future<void> _handleImageSend({String captionText = 'image'}) async {
    if (selectedImages.isEmpty) return;

    print("Handling image send");

    final imagesToSend = List<File>.from(selectedImages);
    clearSelectedImages();

    // Optimistic bubble with local file paths so the user sees it instantly
    final tempId = _generateTempId();
    final optimistic = MessageModel.optimistic(
      tempId: tempId,
      conversationId: _conversationId,
      senderId: currentUserId,
      message: captionText,
      attachments: imagesToSend.map((f) => f.path).toList(),
    );
    messages.insert(0, optimistic);

    isUploadingImages.value = true;
    try {
      // ── Replace this with your real upload API call ──────────────────────
      final List<String> uploadedUrls = await _uploadImagesToServer(imagesToSend, tempId);
      // ─────────────────────────────────────────────────────────────────────

      if( uploadedUrls.isEmpty ){
        return;
      }

      _socketService.sendImageMessage(
        conversationId: _conversationId,
        imageUrls: uploadedUrls,
        message: captionText,
      );
    } catch (e) {
      print("Image upload errorrrrrrrrrrrrrrrrrrrrr $e");
      Get.snackbar('Upload failed', 'Could not send images. Please try again.');
      // Remove the optimistic message on failure
      messages.removeWhere((m) => m.id == tempId);
    } finally {
      print("Image upload process finish");
      isUploadingImages.value = false;
    }
  }

  /// Stub — replace with your real multipart upload logic.
  /// Should return the list of remote image URLs after a successful upload.
  Future<List<String>> _uploadImagesToServer(List<File> files, String tempId) async {

    ApiResponse response = await apiService.multipartRequest(
        method: "POST",
        endPoint: "/conversations/upload",
        isAuthRequired: true,
        fields: {},
      images: files,
      imageKey: "attachments"
    );

    print("Image upload response code: ${response.statusCode}");
    print("Image upload response data: ${response.data}");

    if( response.statusCode != 200 ){
      messages.removeWhere((m){
        return m.id == tempId;
      });

      if( response.statusCode == 402 ){
        showApiSnackBar(
            statusCode: response.statusCode,
            data: response.data,
          msg: "Subscription required to send media"
        );
        return [];
      }

      showApiSnackBar(statusCode: response.statusCode, data: response.data);
      return [];
    }

    final fetchedImageUrls = response.data?['data'] as List<dynamic>? ?? [];
    return fetchedImageUrls.map((url) => url.toString()).toList();
  }


  void notifyTyping() {
    _socketService.sendTyping(_conversationId);
  }

  void _registerStreamListeners() {
    _subscriptions.addAll([
      _socketService.onMessageReceived.listen(_handleIncomingMessage),
      _socketService.onTyping.listen(_handleTyping),
      _socketService.onMarkedAsRead.listen(_handleRead),
      _socketService.onError.listen(_handleError),
    ]);
  }

  void _handleIncomingMessage(MessageModel incoming) {
    if (incoming.senderId == currentUserId) {
      _replaceOptimisticMessage(incoming);
    } else {
      if (_isDuplicate(incoming.id)) return;
      messages.add(incoming);
      _socketService.markAsRead(_conversationId);
    }
  }

  /// Replaces the first optimistic (sending) message from current user
  /// with the server-confirmed one. Falls back to dedup check.
  void _replaceOptimisticMessage(MessageModel confirmed) {
    if (_isDuplicate(confirmed.id)) return;

    final index = messages.indexWhere(
          (m) => m.status == MessageStatus.sending && m.senderId == currentUserId,
    );

    if (index != -1) {
      messages[index] = confirmed;
    } else {
      messages.add(confirmed);
    }
  }

  void _handleTyping(String conversationId) {
    isTyping.value = true;
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      isTyping.value = false;
    });
  }

  void _handleRead(String conversationId) {
    if (conversationId != _conversationId) return;

    final updated = messages.map((m) {
      return m.senderId == currentUserId ? m.copyWith(isSeen: true) : m;
    }).toList();

    messages.assignAll(updated);
  }

  void _handleError(String errorMessage) {
    if (errorMessage == "Conversation doesn't exists!") {
      // Surface to UI without crashing
      Get.snackbar('Chat Error', errorMessage);
      return;
    }
    print(errorMessage);
    Get.snackbar('Error', errorMessage);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  bool _isDuplicate(String messageId) {
    return messages.any((m) => m.id == messageId);
  }

  String _generateTempId() => 'temp_${DateTime.now().microsecondsSinceEpoch}';

}