import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import 'register_screen.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  String? _errorMessage;
  bool _emailError = false;
  bool _passwordError = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _triggerError(String message, {bool email = false, bool password = false}) {
    setState(() {
      _errorMessage = message;
      _emailError = email;
      _passwordError = password;
    });
    _shakeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 30),

                const AuthHeader(
                  title: "Welcome Back",
                  subtitle: "Sign in to continue your fitness journey.",
                ),

                const SizedBox(height: 36),

                /// ANIMATED ERROR BANNER
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, child: child),
                  ),
                  child: _errorMessage == null
                      ? const SizedBox.shrink()
                      : Container(
                          key: ValueKey(_errorMessage),
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.redAccent,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    _errorMessage = null;
                                    _emailError = false;
                                    _passwordError = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                ),

                /// SHAKING FORM FIELDS
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    final offset = sin(_shakeAnimation.value * pi * 4) * 10;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      AuthTextField(
                        controller: emailController,
                        hintText: "Email Address",
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        hasError: _emailError,
                        onChanged: (_) {
                          if (_emailError || _errorMessage != null) {
                            setState(() {
                              _emailError = false;
                              _errorMessage = null;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      AuthTextField(
                        controller: passwordController,
                        hintText: "Password",
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: obscurePassword,
                        hasError: _passwordError,
                        onChanged: (_) {
                          if (_passwordError || _errorMessage != null) {
                            setState(() {
                              _passwordError = false;
                              _errorMessage = null;
                            });
                          }
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      final email = emailController.text.trim();

                      if (email.isEmpty) {
                        _triggerError(
                          "Please enter your email first to reset password.",
                          email: true,
                        );
                        return;
                      }

                      try {
                        await AuthService.instance.resetPassword(email: email);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Password reset email has been sent successfully.",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        String message;
                        switch (e.code) {
                          case 'user-not-found':
                            message = "This email has not been registered yet. Please check or sign up.";
                            break;
                          case 'invalid-email':
                            message = "Invalid email address format.";
                            break;
                          default:
                            message = e.message ?? "Failed to send reset email.";
                        }
                        _triggerError(message, email: true);
                      }
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                PrimaryButton(
                  text: isLoading ? "Logging in..." : "Login",
                  icon: isLoading
                      ? Icons.hourglass_top_rounded
                      : Icons.login_rounded,
                  onPressed: isLoading
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          if (email.isEmpty && password.isEmpty) {
                            _triggerError(
                              "Please enter both email and password to login.",
                              email: true,
                              password: true,
                            );
                            return;
                          }

                          if (email.isEmpty) {
                            _triggerError(
                              "Please enter your email address.",
                              email: true,
                            );
                            return;
                          }

                          final emailRegex = RegExp(
                            r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(email)) {
                            _triggerError(
                              "Please enter a valid email address.",
                              email: true,
                            );
                            return;
                          }

                          if (password.isEmpty) {
                            _triggerError(
                              "Please enter your password.",
                              password: true,
                            );
                            return;
                          }

                          try {
                            setState(() {
                              isLoading = true;
                              _errorMessage = null;
                            });

                            await AuthService.instance.signIn(
                              email: email,
                              password: password,
                            );
                            if (!mounted) return;

                            setState(() {
                              isLoading = false;
                            });
                          } on FirebaseAuthException catch (e) {
                            if (!mounted) return;
                            setState(() {
                              isLoading = false;
                            });

                            String message;
                            bool mailErr = false;
                            bool passErr = false;

                            switch (e.code) {
                              case 'wrong-password':
                                message = "Incorrect password entered. Please verify and try again.";
                                passErr = true;
                                break;
                              case 'user-not-found':
                                message = "This email has not been registered yet. Please check your email or Sign Up first.";
                                mailErr = true;
                                break;
                              case 'invalid-credential':
                                final emailExists = await AuthService.instance.checkEmailExists(email);
                                if (emailExists) {
                                  message = "Incorrect password entered. Please verify and try again.";
                                  passErr = true;
                                } else {
                                  message = "Invalid email or password. If you haven't registered this email yet, please Sign Up first.";
                                  mailErr = true;
                                  passErr = true;
                                }
                                break;
                              case 'invalid-email':
                                message = "Invalid email address format.";
                                mailErr = true;
                                break;
                              case 'too-many-requests':
                                message = "Too many login attempts. Please try again later.";
                                mailErr = true;
                                passErr = true;
                                break;
                              default:
                                message = e.message ?? "Login failed. Please verify your credentials.";
                                mailErr = true;
                                passErr = true;
                            }
                            _triggerError(
                              message,
                              email: mailErr,
                              password: passErr,
                            );
                          } catch (e) {
                            if (!mounted) return;
                            setState(() {
                              isLoading = false;
                            });
                            _triggerError(
                              "An unexpected error occurred: ${e.toString()}",
                              email: true,
                              password: true,
                            );
                          }
                        },
                ),

                const SizedBox(height: 36),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}