import 'package:eventzone_frontend/views/Auth_screens/login_view.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {

  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  final _confirmPasswordController=TextEditingController();
  final _fullnameController=TextEditingController();
  final _roleController=TextEditingController();
  String? selectedRole;
  final List<String> roles = ['Attendee', 'Host'];

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
                  onPressed: (){},
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
                    // onPressed: _signInWithGoogle,
                    onPressed: (){},
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
