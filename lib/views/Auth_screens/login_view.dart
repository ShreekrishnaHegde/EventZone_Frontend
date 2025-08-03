import 'package:eventzone_frontend/service/auth_service/auth_service.dart';
import 'package:eventzone_frontend/views/Auth_screens/signup_view.dart';
import 'package:flutter/material.dart';

import '../attendee/attendee_home_view.dart';
import '../host/host_home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;
  bool _obscureText = true;
  final AuthService _authService=AuthService();

  InputDecoration buildInputDecoration(String labelText,IconData icon) {
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
      prefixIcon: Icon(icon, color: Colors.grey),
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

  void _login() async {
    try {
      final user = await _authService.login(_emailController.text, _passwordController.text);
      if (user?.role == "ATTENDEE") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AttendeeHomeView()));
      } else if (user?.role == "HOST") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HostHomeView()));
      }
    } catch (e) {
      setState(() => error = "Login failed");
    }
  }
  @override
  Widget build(BuildContext context) {
    final screen_height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: screen_height/12,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 22,
                        height: 1.5,
                        color: Colors.black87,
                        fontFamily: 'Poppins'
                    ),
                    children: [
                      const TextSpan(
                        text: "Hi, ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(
                        text: "Welcome Back 👋\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: "Login to your account",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screen_height/15,),
                TextFormField(
                  controller: _emailController,
                  decoration:  buildInputDecoration("Enter your email", Icons.email),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  obscureText: _obscureText,
                  controller: _passwordController,
                  decoration: buildInputDecoration("Enter the password", Icons.password).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: _login,
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupView()));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF140447),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/google.png', // Make sure you have this image in your assets folder
                    height: 24,
                    width: 24,
                  ),
                  label: const Text('Continue with Google'),
                  // onPressed: _signInWithGoogle,
                  onPressed: (){},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 16),
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
