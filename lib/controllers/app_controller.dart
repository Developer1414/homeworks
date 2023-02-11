import 'package:get/get.dart';
import 'package:scool_home_working/models/task_model.dart';

class AppController extends GetxController {
  RxInt currentScreen = 0.obs;
  RxList<Task> selectedTasks = <Task>[].obs;
  RxList<Task> tasks = <Task>[].obs;
}
