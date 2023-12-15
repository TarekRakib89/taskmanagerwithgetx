import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskmanager/ui/controllers/auth_controllers.dart';
import 'package:taskmanager/ui/screens/LoginScreen.dart';
import 'package:taskmanager/ui/screens/main_bottom_nav_screen.dart';
import 'package:taskmanager/ui/widgets/body_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToLogin();
  }

  Future<void> goToLogin() async {
    final bool isLoggedIn = await AuthController().checkAuthState();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => isLoggedIn
                  ? const MainBottomNavScreen()
                  : const LoginScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: Center(
          child: SvgPicture.asset(
            'assets/images/app-logo.svg',
            width: 120,
          ),
        ),
      ),
    );
  }
}
