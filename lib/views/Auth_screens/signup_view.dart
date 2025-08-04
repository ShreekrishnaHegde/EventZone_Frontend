import 'dart:async';

import 'package:eventzone_frontend/service/auth_service/auth_service.dart';
import 'package:eventzone_frontend/views/Auth_screens/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../attendee/attendee_home_view.dart';
import '../host/host_home_view.dart';
enum UserRole { attendee, host }
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  StreamSubscription? _sub;
  static const platform = MethodChannel('com.example.eventzone_frontend.app/deeplink');
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  final _confirmPasswordController=TextEditingController();
  final _fullnameController=TextEditingController();
  final _roleController=TextEditingController();
  String? selectedRole;
  final List<String> roles = ['Attendee', 'Host'];
  final AuthService _authService=AuthService();
  final _baseUrl = dotenv.env['BASE_URL']!;
  // UserRole? selectedRole;
  String? error;

  InputDecoration buildInputDecoration(String labelText,) {
    return InputDecoration(
      border: UnderlineInputBorder(),
      labelText: labelText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF140447), width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      // prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Color(0xFF140447),
    minimumSize: Size(double.infinity,50),
    // padding: EdgeInsets.symmetric(horizontal: 100),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
  Widget buildTextField({
    required String label,
    TextEditingController? controller,
    bool obscure=false,
  }){
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: buildInputDecoration(label),
    );
  }
  Widget buildRoleDropdown(){
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
          decoration: buildInputDecoration("Select Role"),
          value: selectedRole,
          isExpanded: true,
          items: roles.map(
                  (role){
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }
          ).toList(),
          onChanged: (value){
            setState(() {
              selectedRole=value;
              _roleController.text=value!;
            });
          }
      ),
    );
  }

  void _signup() async {
    try {
      if (selectedRole == null) {
        setState(() => error = "Please select a role");
        debugPrint("Signup failed: No role selected");
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();


      debugPrint("Attempting signup for role: $selectedRole");

      if (selectedRole == UserRole.attendee) {
        final user = await _authService.signupAttendee(email, password);
        debugPrint("Attendee signup success: ${user?.email}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AttendeeHomeView()));
      } else {
        final user = await _authService.signupHost(email, password);
        debugPrint("Host signup success: ${user?.email}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HostHomeView()));
      }

    } catch (e) {
      debugPrint("Signup error: $e");
      setState(() => error = "Signup failed");
    }
  }
  Future<void> _signInWithGoogle() async {

    try {
      if (selectedRole == null) {
        setState(() => error = "Please select a role before continuing with Google");
        return;
      }
      final roleParam = selectedRole!.toLowerCase();
      final backendUrl = "$_baseUrl/auth/google/url?role=$roleParam";
      final url = Uri.parse(backendUrl);

      if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
        // Fallback to in-app web view if platform default fails
        if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      print("Error launching OAuth URL: $e");
    }
  }
  void _listenForDeepLinks() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final link = call.arguments as String;
        final uri = Uri.parse(link);

        final token = uri.queryParameters['token'];
        final email = uri.queryParameters['email'];
        final role = uri.queryParameters['role'];

        print("✅ Google Auth Success");
        print("Token: $token");
        print("Email: $email");
        print("Role: $role");

        // TODO: Save token securely (if needed)

        // Navigate based on role
        if (role == 'attendee') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AttendeeHomeView()));
        } else if (role == 'host') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HostHomeView()));
        } else {
          print("❌ Unknown role");
        }
      }
    });
  }
  @override
  void initState() {
    super.initState();
    _listenForDeepLinks();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height=MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.5,
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      const TextSpan(
                        text: "Register\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: "Create your new account",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screen_height/25,),
                buildTextField(label: "Full Name",controller: _fullnameController),
                SizedBox(height: screen_height/50,),
                buildTextField(label: "Email", controller: _emailController),
                SizedBox(height: screen_height/50,),
                buildTextField(label: "Password", controller: _passwordController, obscure: true),
                SizedBox(height: screen_height/50,),
                buildTextField(label: "Confirm Password", controller: _confirmPasswordController, obscure: true),
                SizedBox(height: screen_height/50,),
                buildRoleDropdown(),
                SizedBox(height: screen_height/50,),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: _signup,
                  child: const Text(
                    "Signup",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF140447),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      'assets/google.png', // Make sure you have this image in your assets folder
                      height: 24,
                      width: 24,
                    ),
                    label: const Text('Continue with Google'),
                    onPressed: _signInWithGoogle,
                    // onPressed: (){},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
