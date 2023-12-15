import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/utility/urls.dart';
import 'package:taskmanager/ui/controllers/task_controller.dart';
import 'package:taskmanager/ui/screens/add_new_task_screen.dart';
import 'package:taskmanager/ui/widgets/profile_summary_card.dart';
import 'package:taskmanager/ui/widgets/summary_card.dart';
import 'package:taskmanager/ui/widgets/task_item_card.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final TaskController _completedTaskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _completedTaskController.getTaskList(Urls.getTaskStatusCompleted);
    _completedTaskController.getTaskCountSummaryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            GetBuilder<TaskController>(builder: (completedTaskController) {
              return Visibility(
                  visible:
                      completedTaskController.getTaskCountSummaryProgress ==
                          false,
                  replacement: const LinearProgressIndicator(),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: completedTaskController
                                .taskCountSummaryListModel
                                .taskcountList
                                ?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return SummeryCard(
                              title: completedTaskController
                                      .taskCountSummaryListModel
                                      .taskcountList![index]
                                      .sId ??
                                  '',
                              count: completedTaskController
                                  .taskCountSummaryListModel
                                  .taskcountList![index]
                                  .sum
                                  .toString());
                        }),
                  ));
            }),
            Expanded(
                child: GetBuilder<TaskController>(builder: (taskController) {
              return Visibility(
                visible: taskController.getNewTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () => _completedTaskController
                      .getTaskList(Urls.getTaskStatusCompleted),
                  child: ListView.builder(
                      itemCount:
                          taskController.taskModelList.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: taskController.taskModelList.taskList![index],
                          onStatusChanges: () {
                            _completedTaskController
                                .getTaskList(Urls.getTaskStatusCompleted);
                            _completedTaskController.getTaskCountSummaryList();
                          },
                          showProgress: (inPogress) {},
                        );
                      }),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }
}
