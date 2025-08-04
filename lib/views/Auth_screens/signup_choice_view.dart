import 'package:flutter/material.dart';
import 'attendee_signup_view.dart';
import 'host_signup_view.dart';

class SignUpChoiceView extends StatelessWidget {
  const SignUpChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Role")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Sign up as Attendee"),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendeeSignupView())),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Sign up as Host"),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HostSignupView())),
            ),
          ],
        ),
      ),
    );
  }
}
