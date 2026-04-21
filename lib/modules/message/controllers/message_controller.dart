import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/data/models/message/conversation_model.dart';
import '../../../core/services/socket_service.dart';
import '../../../data/models/message/message_model.dart';

class MessageController extends GetxController {

  final SocketService _socketService = Get.find<SocketService>();
  late String currentUserId;
  late String _conversationId;
  late Conversation conversation;
  final storage = GetStorage();
  final scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final messageHelper = PaginationHelper<MessageModel>();

  @override
  void onInit() {

    currentUserId = storage.read( userIdKey );
    conversation = Get.arguments as Conversation;
    _conversationId = conversation.id;

    initSocket();

    ever(messages, (_) => _scrollToBottom());

    super.onInit();
  }

  void initMessageHelper(){
    messageHelper.init(
        endPoint: ApiEndpoints,
        fromJson: fromJson,
        listExtractor: listExtractor
    );
  }

  Future<void> _loadInitialMessages() async {



    isLoadingMessages.value = true;
    try {
      // Replace with your actual endpoint
      final response = await _apiService.get(
        '/conversations/$_conversationId/messages',
      );

      if (response.statusCode == 200) {
        final List data = response.data as List;
        final history = data
            .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        messages.assignAll(history);
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('[Chat] Failed to load history: $e');
    } finally {
      isLoadingMessages.value = false;
    }
  }

  void handleSend() {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    sendMessage(text);
    textController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final messages = <MessageModel>[].obs;
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

    messages.add(optimistic);

    _socketService.sendMessage(
      conversationId: _conversationId,
      message: trimmed,
    );
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