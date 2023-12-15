import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/utility/urls.dart';
import 'package:taskmanager/ui/controllers/task_controller.dart';
import 'package:taskmanager/ui/screens/add_new_task_screen.dart';
import 'package:taskmanager/ui/widgets/profile_summary_card.dart';
import 'package:taskmanager/ui/widgets/summary_card.dart';
import 'package:taskmanager/ui/widgets/task_item_card.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({super.key});

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {
  final TaskController _cancelledTaskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _cancelledTaskController.getTaskList(Urls.getCancelledTask);
    _cancelledTaskController.getTaskCountSummaryList();
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
            GetBuilder<TaskController>(
              builder: (cancelledTaskController) {
                return Visibility(
                  visible:
                      cancelledTaskController.getTaskCountSummaryProgress ==
                          false,
                  replacement: const LinearProgressIndicator(),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cancelledTaskController
                              .taskCountSummaryListModel
                              .taskcountList
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return SummeryCard(
                            title: cancelledTaskController
                                    .taskCountSummaryListModel
                                    .taskcountList![index]
                                    .sId ??
                                '',
                            count: cancelledTaskController
                                .taskCountSummaryListModel
                                .taskcountList![index]
                                .sum
                                .toString());
                      },
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: GetBuilder<TaskController>(
                builder: (cancelledTaskController) {
                  return Visibility(
                    visible:
                        cancelledTaskController.getNewTaskInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () => _cancelledTaskController
                          .getTaskList(Urls.getProgressTasks),
                      child: ListView.builder(
                        itemCount: _cancelledTaskController
                                .taskModelList.taskList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: _cancelledTaskController
                                .taskModelList.taskList![index],
                            onStatusChanges: () {
                              _cancelledTaskController
                                  .getTaskList(Urls.getCancelledTask);
                              _cancelledTaskController
                                  .getTaskCountSummaryList();
                            },
                            showProgress: (inPogress) {},
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
