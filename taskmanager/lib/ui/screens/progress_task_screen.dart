import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/utility/urls.dart';
import 'package:taskmanager/ui/controllers/task_controller.dart';
import 'package:taskmanager/ui/screens/add_new_task_screen.dart';
import 'package:taskmanager/ui/widgets/profile_summary_card.dart';
import 'package:taskmanager/ui/widgets/summary_card.dart';
import 'package:taskmanager/ui/widgets/task_item_card.dart';

class ProgressTasksScreen extends StatefulWidget {
  const ProgressTasksScreen({super.key});

  @override
  State<ProgressTasksScreen> createState() => _ProgressTasksScreenState();
}

class _ProgressTasksScreenState extends State<ProgressTasksScreen> {
  final TaskController _progressTaskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _progressTaskController.getTaskList(Urls.getProgressTasks);
    _progressTaskController.getTaskCountSummaryList();
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
            GetBuilder<TaskController>(builder: (progressTaskController) {
              return Visibility(
                  visible: progressTaskController.getTaskCountSummaryProgress ==
                      false,
                  replacement: const LinearProgressIndicator(),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: progressTaskController
                                .taskCountSummaryListModel
                                .taskcountList
                                ?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return SummeryCard(
                              title: progressTaskController
                                      .taskCountSummaryListModel
                                      .taskcountList![index]
                                      .sId ??
                                  '',
                              count: progressTaskController
                                  .taskCountSummaryListModel
                                  .taskcountList![index]
                                  .sum
                                  .toString());
                        }),
                  ));
            }),
            Expanded(child:
                GetBuilder<TaskController>(builder: (progressTaskController) {
              return Visibility(
                visible: _progressTaskController.getNewTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () => _progressTaskController
                      .getTaskList(Urls.getProgressTasks),
                  child: ListView.builder(
                      itemCount: _progressTaskController
                              .taskModelList.taskList?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: _progressTaskController
                              .taskModelList.taskList![index],
                          onStatusChanges: () {
                            _progressTaskController
                                .getTaskList(Urls.getProgressTasks);
                            _progressTaskController.getTaskCountSummaryList();
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
