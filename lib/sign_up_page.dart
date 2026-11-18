import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:splash_screen_new/login_screen.dart';
import 'package:splash_screen_new/nurse_registertion.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showspiner = false;
  bool _hidePassword = true; // UI only
  bool _hideConfirm = true; // UI only
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String Email = "";
  String password = "";
  String confirmpassword = "";

  // Theme colors (same as splash + login)
  static const Color _teal = Color(0xFF00897B);
  static const Color _tealDark = Color(0xFF006064);
  static const Color _tealLight = Color(0xFF00BFA5);

  static const double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final cardMinHeight = media.size.height - media.padding.top - _headerHeight;

    return ModalProgressHUD(
      inAsyncCall: showspiner,
      child: Scaffold(
        backgroundColor: _tealDark,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_tealLight, _teal, _tealDark],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFormCard(cardMinHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader() {
    return SizedBox(
      height: _headerHeight,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: -40, right: -40, child: _decorCircle(160, 0.10)),
          Positioned(top: 90, left: -50, child: _decorCircle(120, 0.08)),

          // Back button
          Positioned(
            top: 6,
            left: 6,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 42,
                  color: _teal,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Register to continue',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  // ---------- Form card ----------
  Widget _buildFormCard(double minHeight) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.fromLTRB(26, 34, 26, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B2B34),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create your account in a few seconds',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 26),

            // Email
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                hint: 'Email address',
                icon: Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter email";
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Password
            TextFormField(
              controller: passwordController,
              obscureText: _hidePassword,
              decoration: _inputDecoration(
                hint: 'Password',
                icon: Icons.lock_outline_rounded,
                suffix: _eyeButton(
                  hidden: _hidePassword,
                  onTap: () => setState(() => _hidePassword = !_hidePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter password";
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Confirm password
            TextFormField(
              controller: confirmpasswordcontroller,
              obscureText: _hideConfirm,
              decoration: _inputDecoration(
                hint: 'Confirm password',
                icon: Icons.lock_reset_rounded,
                suffix: _eyeButton(
                  hidden: _hideConfirm,
                  onTap: () => setState(() => _hideConfirm = !_hideConfirm),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Confirm password";
                }

                if (value != passwordController.text) {
                  return "Passwords do not match";
                }

                return null;
              },
            ),
            const SizedBox(height: 30),

            // Create account button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: _teal.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      showspiner = true;
                    });

                    try {
                      await _auth.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      );

                      toastmessage("User successfully created");

                      setState(() {
                        showspiner = false;
                      });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    } catch (e) {
                      toastmessage(e.toString());

                      setState(() {
                        showspiner = false;
                      });
                    }
                  }
                },
                child: const Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _teal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _eyeButton({required bool hidden, required VoidCallback onTap}) {
    return IconButton(
      icon: Icon(
        hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: Colors.grey.shade600,
      ),
      onPressed: onTap,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      prefixIcon: Icon(icon, color: _teal),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF1F6F6),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: border(Colors.transparent, 1),
      focusedBorder: border(_teal, 1.6),
      errorBorder: border(Colors.redAccent, 1.2),
      focusedErrorBorder: border(Colors.redAccent, 1.6),
    );
  }
}