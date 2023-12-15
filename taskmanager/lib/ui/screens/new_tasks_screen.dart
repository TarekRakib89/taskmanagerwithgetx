import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:taskmanager/data/utility/urls.dart';
import 'package:taskmanager/ui/controllers/task_controller.dart';
import 'package:taskmanager/ui/screens/add_new_task_screen.dart';
import 'package:taskmanager/ui/widgets/profile_summary_card.dart';
import 'package:taskmanager/ui/widgets/summary_card.dart';
import 'package:taskmanager/ui/widgets/task_item_card.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  final TaskController _newtaskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _newtaskController.getTaskList(Urls.getNewTasks);
    _newtaskController.getTaskCountSummaryList();
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
            GetBuilder<TaskController>(builder: (newTaskController) {
              return Visibility(
                  visible:
                      _newtaskController.getTaskCountSummaryProgress == false,
                  replacement: const LinearProgressIndicator(),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _newtaskController.taskCountSummaryListModel
                                .taskcountList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return SummeryCard(
                              title: _newtaskController
                                      .taskCountSummaryListModel
                                      .taskcountList![index]
                                      .sId ??
                                  '',
                              count: _newtaskController
                                  .taskCountSummaryListModel
                                  .taskcountList![index]
                                  .sum
                                  .toString());
                        }),
                  ));
            }),
            Expanded(
              child: GetBuilder<TaskController>(
                builder: (newTaskController) {
                  return Visibility(
                    visible: newTaskController.getNewTaskInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () =>
                          newTaskController.getTaskList(Urls.getNewTasks),
                      child: ListView.builder(
                          itemCount: newTaskController
                                  .taskModelList.taskList?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return TaskItemCard(
                              task: newTaskController
                                  .taskModelList.taskList![index],
                              onStatusChanges: () {
                                newTaskController.getTaskList(Urls.getNewTasks);
                                _newtaskController.getTaskCountSummaryList();
                              },
                              showProgress: (inPogress) {},
                            );
                          }),
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
