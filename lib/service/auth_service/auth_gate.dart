import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/auth_response.dart';
import '../../views/Auth_screens/login_view.dart';
import '../../views/attendee/attendee_home_view.dart';
import '../../views/host/host_home_view.dart';
import 'auth_service.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthResponse?>(
      future: _authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = snapshot.data;
        if (user == null) return const LoginView();
        if (user.role == "ATTENDEE") return AttendeeHomeView();
        if (user.role == "HOST") return const HostHomeView();

        return const LoginView(); // fallback
      },
    );
  }
}
