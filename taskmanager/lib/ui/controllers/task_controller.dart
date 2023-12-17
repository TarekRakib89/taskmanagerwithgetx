import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/models/task_count_summary_list_model.dart';
import 'package:taskmanager/data/models/task_list_model.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/network_caller/network_response.dart';
import 'package:taskmanager/data/utility/urls.dart';

class TaskController extends GetxController {
  TaskListModel _taskListModel = TaskListModel();
  TaskCountSummaryListModel _taskCountSummaryListModel =
      TaskCountSummaryListModel();
  bool _getNewTaskInProgress = false;
  bool _getTaskCountSummaryInProgress = false;
  bool _createTaskInProgress = false;

  bool get getNewTaskInProgress => _getNewTaskInProgress;
  bool get getTaskCountSummaryProgress => _getTaskCountSummaryInProgress;
  bool get createTaskInProgress => _createTaskInProgress;
  TaskListModel get taskModelList => _taskListModel;

  TaskCountSummaryListModel get taskCountSummaryListModel =>
      _taskCountSummaryListModel;

  Future<void> getTaskList(String urls) async {
    _getNewTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(urls);
    if (response.isSuccess) {
      debugPrint("truee");
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    _getNewTaskInProgress = false;

    update();
  }

  Future<void> getTaskCountSummaryList() async {
    _getTaskCountSummaryInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      _taskCountSummaryListModel =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
      _getTaskCountSummaryInProgress = false;
      update();
    }
  }

  Future<bool> createTask(String title, String description) async {
    _createTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().postRequest(
      Urls.createNewTask,
      body: {
        "title": title,
        "description": description,
        "status": "New",
      },
    );
    _createTaskInProgress = false;
    update();

    if (response.isSuccess) {
      return true;
    }
    return false;
  }
}
