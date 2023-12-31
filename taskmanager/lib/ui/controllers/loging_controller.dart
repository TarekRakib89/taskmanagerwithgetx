import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/data/models/user_model.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/network_caller/network_response.dart';
import 'package:taskmanager/data/utility/urls.dart';
import 'package:taskmanager/ui/controllers/auth_controllers.dart';

class LoginController extends GetxController {
  bool _loginInProgress = false;
  String _failedMessage = '';
  bool get loginProgress => _loginInProgress;
  String get failedMessage => _failedMessage;

  Future<bool> login(String email, String password) async {
    debugPrint("print Controller");
    _loginInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
        body: {
          'email': email,
          'password': password,
        },
        isLogin: true);
    _loginInProgress = false;
    update();

    if (response.isSuccess) {
      await AuthController().saveUserInformation(response.jsonResponse['token'],
          UserModel.fromJson(response.jsonResponse['data']));
      return true;
    } else {
      if (response.statusCode == 401) {
        _failedMessage = 'Please check email/password';
      } else {
        _failedMessage = 'login failed';
      }
    }

    return false;
  }
}
