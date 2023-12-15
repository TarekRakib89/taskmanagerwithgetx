import 'package:flutter/material.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/network_caller/network_response.dart';
import 'package:taskmanager/data/utility/urls.dart';
import 'package:taskmanager/ui/screens/pin_verificationscreen.dart';
import 'package:taskmanager/ui/widgets/body_background.dart';
import 'package:taskmanager/ui/widgets/snack_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _emailVeriFicationProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'A 6 digit OTP will be sent to your email address',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          recoveriEmailVerification(
                              emailTextEditingController.text.trim());
                          emailTextEditingController.clear();
                        },
                        child: _emailVeriFicationProgress
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Icons.arrow_circle_right_outlined,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Have an account?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void recoveriEmailVerification(String email) async {
    if (_formKey.currentState!.validate()) {
      _emailVeriFicationProgress = true;

      if (mounted) {
        setState(() {});
      }
      final NetworkResponse response =
          await NetworkCaller().getEmailVerification(
        Urls.recoverVerifyEmail(
          emailTextEditingController.text.trim(),
        ),
      );
      _emailVeriFicationProgress = false;
      if (mounted) {
        setState(() {});
      }

      if (response.jsonResponse['status'] == "success") {
        if (mounted) {
          debugPrint("print email:${emailTextEditingController.text.trim()}");
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return PinVerificationScreen(
              email: email,
            );
          }), (route) => false);
        }

        if (mounted) {
          showSnackMessage(context, 'email verifed');
        }
      } else {
        if (mounted) {
          showSnackMessage(context, 'failed! try again', true);
        }
      }
    }
  }
}
