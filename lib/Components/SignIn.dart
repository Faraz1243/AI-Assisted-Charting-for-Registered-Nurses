import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign In',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),


              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
              ),
              SizedBox(height: 16),


              TextField(
                controller: passwordController,
                obscureText: passwordVisible? false: true,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: passwordVisible? const Icon(Icons.visibility_off): const Icon(Icons.visibility),
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    labelText: 'Password'
                ),
              ),


              SizedBox(height: 26),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String Email = emailController.text;
                    String Password = passwordController.text;
                    // Sign in

                  },
                  child: const Text('Sign In'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to sign in
                  },
                  child: const Text('Don\'t have an account? Sign Up'),
                ),
              )
            ],
          ),
        )
    );
  }
}
