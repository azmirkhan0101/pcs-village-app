import 'package:get/get.dart';

import '../../../core/services/socket_service.dart';
import '../controllers/message_controller.dart';

class ChatBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SocketService>(() => SocketService());
    Get.lazyPut<MessageController>(() => MessageController(), fenix: true);
  }
}