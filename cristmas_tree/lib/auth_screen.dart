import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'auth_service.dart';
import 'home_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool loading = false;

  void _toggle() {
    setState(() => isLogin = !isLogin);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      if (isLogin) {
        await _authService.signInWithEmail(
            emailController.text.trim(), passwordController.text.trim());
      } else {
        await _authService.signUpWithEmail(
            emailController.text.trim(), passwordController.text.trim());
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.green, Colors.greenAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🎄 Welcome to Christmas Tree Customization App!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(isLogin ? 'Login' : 'Sign Up',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        if (!isLogin)
                          TextFormField(
                            controller: nameController,
                            decoration:
                            const InputDecoration(labelText: 'Full Name'),
                            validator: (v) =>
                            v!.isEmpty ? 'Enter your name' : null,
                          ),
                        TextFormField(
                          controller: emailController,
                          decoration:
                          const InputDecoration(labelText: 'Email'),
                          validator: (v) =>
                          v!.contains('@') ? null : 'Enter valid email',
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration:
                          const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (v) => v!.length >= 6
                              ? null
                              : 'Password must be 6+ chars',
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              final email = emailController.text.trim();
                              if (email.isEmpty || !email.contains('@')) {
                                Fluttertoast.showToast(msg: 'Enter a valid email first');
                                return;
                              }
                              try {
                                await _authService.sendPasswordResetEmail(email);
                                Fluttertoast.showToast(msg: 'Reset link sent to $email');
                              } catch (e) {
                                Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
                              }
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        loading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12))),
                          child: Text(isLogin ? 'Login' : 'Sign Up'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: _toggle,
                            child: Text(isLogin
                                ? 'Create new account'
                                : 'Already have an account? Login')),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            setState(() => loading = true);
                            try {
                              final user = await _authService.signInWithGoogle();
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                                );
                              }
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                            } finally {
                              setState(() => loading = false);
                            }
                          },
                          icon: Image.asset(
                            'assets/google_logo.png',
                            height: 24,
                          ),
                          label: const Text('Sign in with Google'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: const Size.fromHeight(50)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
