import 'package:get/get.dart';
import 'package:scool_home_working/models/task_model.dart';

class AppController extends GetxController {
  RxInt currentScreen = 0.obs;
  RxInt taskIdFromNotification = 0.obs;
  RxBool isHomeworksPro = false.obs;
  RxList<Task> selectedTasks = <Task>[].obs;
  RxList<Task> tasks = <Task>[].obs;
  DateTime subscriptionExpirationDate = DateTime(2023, 3, 3, 12);
}
