import 'dart:async';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../data/models/message/message_model.dart';

typedef MessageCallback = void Function(MessageModel message);
typedef TypingCallback = void Function(String conversationId);
typedef ReadCallback = void Function(String conversationId);
typedef ErrorCallback = void Function(String message);

class SocketService {

  io.Socket? _socket;

  // Event stream controllers
  final _messageController = StreamController<MessageModel>.broadcast();
  final _typingController = StreamController<String>.broadcast();
  final _readController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<MessageModel> get onMessageReceived => _messageController.stream;
  Stream<String> get onTyping => _typingController.stream;
  Stream<String> get onMarkedAsRead => _readController.stream;
  Stream<String> get onError => _errorController.stream;
  Stream<bool> get onConnectionChange => _connectionController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String accessToken) {
    if (_socket != null && isConnected) return;

    _socket = io.io(
      '${ApiEndpoints.socketBaseUrl}?token=$accessToken',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          //.setAuth({'token': accessToken})
      //     .setExtraHeaders({
      //   'Authorization': 'Bearer $accessToken',
      // })
          .build(),
    );

    _registerConnectionEvents();
    _registerListeners();

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void joinRoom(String conversationId) {
    _emit('join_room', {'conversationId': conversationId});
  }

  void sendMessage({
    required String conversationId,
    required String message,
  }) {
    _emit('send_message', {
      'conversationId': conversationId,
      'message': message,
    });
  }

  void sendTyping(String conversationId) {
    _emit('typing', {'conversationId': conversationId});
  }

  void markAsRead(String conversationId) {
    _emit('mark_read', {'conversationId': conversationId});
  }

  void _registerConnectionEvents() {
    _socket!
      ..onConnect((_) => _connectionController.add(true))
      ..onDisconnect((_) => _connectionController.add(false))
      ..onConnectError((err) => _errorController.add(err.toString()));
  }

  void _registerListeners() {
    _socket!
      ..on('message_received', (data) {
        final message = MessageModel.fromJson(Map<String, dynamic>.from(data));
        _messageController.add(message);
      })
      ..on('display_typing', (data) {
        final userId = data['userId'] as String;
        _typingController.add(userId);
      })
      ..on('marked_as_read', (data) {
        final conversationId = data['conversationId'] as String;
        _readController.add(conversationId);
      })
      ..on('socket_error', (data) {
        final message = data['message'] as String? ?? 'Unknown socket error';
        _errorController.add(message);
      });
  }

  void _emit(String event, Map<String, dynamic> payload) {
    if (!isConnected) return;
    _socket!.emit(event, payload);
  }

  void dispose() {
    _socket?.dispose();
    _messageController.close();
    _typingController.close();
    _readController.close();
    _errorController.close();
    _connectionController.close();
  }
}