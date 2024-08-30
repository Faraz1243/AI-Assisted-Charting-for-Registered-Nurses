import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool passwordVisible = false;

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
                'Sign Up',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            ),
            SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Full Name'
              ),
            ),
            SizedBox(height: 6),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Email'
              ),
            ),
            SizedBox(height: 16),
            TextField(
              // remove the line below
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
                  // Sign up
                },
                child: const Text('Sign Up'),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to sign in
                },
                child: const Text('Already have an account? Sign In'),
              ),
            )
          ],
        ),
      )
    );
  }
}
