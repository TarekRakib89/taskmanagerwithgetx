import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/network_caller/network_response.dart';
import 'package:taskmanager/data/utility/urls.dart';
import 'package:taskmanager/ui/controllers/task_controller.dart';
import 'package:taskmanager/ui/widgets/body_background.dart';
import 'package:taskmanager/ui/widgets/profile_summary_card.dart';
import 'package:taskmanager/ui/widgets/snack_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _createTaskInProgress = false;
  TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            'Add New Task',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _subjectTEController,
                            decoration: const InputDecoration(
                              hintText: 'Subject',
                            ),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Enter your subject';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _descriptionTEController,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              hintText: 'Description',
                            ),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Enter your description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          GetBuilder<TaskController>(builder: (taskController) {
                            return SizedBox(
                              width: double.infinity,
                              child: Visibility(
                                visible: taskController.createTaskInProgress ==
                                    false,
                                replacement: const Center(
                                    child: CircularProgressIndicator()),
                                child: ElevatedButton(
                                  onPressed: () {
                                    createTask();
                                    taskController
                                        .getTaskList(Urls.getNewTasks);
                                  },
                                  child: const Icon(
                                      Icons.arrow_circle_right_outlined),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createTask() async {
    if (_formKey.currentState!.validate()) {
      _createTaskInProgress = false;
      bool createTask = await taskController.createTask(
          _subjectTEController.text, _descriptionTEController.text);

      if (createTask) {
        _subjectTEController.clear();
        _descriptionTEController.clear();
        if (mounted) {
          showSnackMessage(context, 'New task added');
        }
      } else {
        if (mounted) {
          showSnackMessage(context, 'Create new task failed! try again', true);
        }
      }
    }
  }
}
