import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/common/gradient_background.dart';
import '../../core/widgets/common/primary_button.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import '../../services/auth_service.dart';
import '../../models/app_user.dart';
import '../../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  String? _errorMessage;
  bool _nameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;

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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _triggerError(
    String message, {
    bool name = false,
    bool email = false,
    bool password = false,
    bool confirmPassword = false,
  }) {
    setState(() {
      _errorMessage = message;
      _nameError = name;
      _emailError = email;
      _passwordError = password;
      _confirmPasswordError = confirmPassword;
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
                  title: "Create Account",
                  subtitle: "Start your fitness journey today.",
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
                                    _nameError = false;
                                    _emailError = false;
                                    _passwordError = false;
                                    _confirmPasswordError = false;
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
                        controller: nameController,
                        hintText: "Full Name",
                        prefixIcon: Icons.person_outline,
                        hasError: _nameError,
                        onChanged: (_) {
                          if (_nameError || _errorMessage != null) {
                            setState(() {
                              _nameError = false;
                              _errorMessage = null;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

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

                      const SizedBox(height: AppSpacing.lg),

                      AuthTextField(
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        prefixIcon: Icons.lock_reset_rounded,
                        obscureText: obscureConfirmPassword,
                        hasError: _confirmPasswordError,
                        onChanged: (_) {
                          if (_confirmPasswordError || _errorMessage != null) {
                            setState(() {
                              _confirmPasswordError = false;
                              _errorMessage = null;
                            });
                          }
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                PrimaryButton(
                  text: isLoading ? "Creating Account..." : "Create Account",
                  icon: isLoading
                      ? Icons.hourglass_top_rounded
                      : Icons.person_add_alt_1_rounded,
                  onPressed: isLoading
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text;
                          final confirmPassword = confirmPasswordController.text;

                          if (name.isEmpty &&
                              email.isEmpty &&
                              password.isEmpty &&
                              confirmPassword.isEmpty) {
                            _triggerError(
                              "Please fill in all fields to register.",
                              name: true,
                              email: true,
                              password: true,
                              confirmPassword: true,
                            );
                            return;
                          }

                          if (name.isEmpty) {
                            _triggerError(
                              "Please enter your full name.",
                              name: true,
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

                          if (password.isEmpty || password.length < 6) {
                            _triggerError(
                              "Password must be at least 6 characters long.",
                              password: true,
                            );
                            return;
                          }

                          if (password != confirmPassword) {
                            _triggerError(
                              "Passwords do not match. Please verify.",
                              password: true,
                              confirmPassword: true,
                            );
                            return;
                          }

                          try {
                            setState(() {
                              isLoading = true;
                              _errorMessage = null;
                            });

                            final credential =
                                await AuthService.instance.register(
                              email: email,
                              password: password,
                            );

                            final user = AppUser(
                              uid: credential.user!.uid,
                              fullName: name,
                              email: email,
                              gender: "",
                              dateOfBirth: null,
                              height: 0,
                              weight: 0,
                              profileImageUrl: "",
                              workoutStreak: 0,
                              createdAt: DateTime.now(),
                            );

                            await UserService.instance.createUser(user);

                            if (!mounted) return;

                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            if (!mounted) return;
                            setState(() {
                              isLoading = false;
                            });

                            String message;
                            bool mailErr = false;
                            bool passErr = false;

                            switch (e.code) {
                              case 'email-already-in-use':
                                message = "An account with this email already exists.";
                                mailErr = true;
                                break;
                              case 'weak-password':
                                message = "Password is too weak. Choose a stronger password.";
                                passErr = true;
                                break;
                              case 'invalid-email':
                                message = "Invalid email address format.";
                                mailErr = true;
                                break;
                              default:
                                message = e.message ?? "Registration failed. Please try again.";
                                mailErr = true;
                                passErr = true;
                            }
                            _triggerError(
                              message,
                              email: mailErr,
                              password: passErr,
                              confirmPassword: passErr,
                            );
                          } catch (e) {
                            if (!mounted) return;
                            setState(() {
                              isLoading = false;
                            });
                            _triggerError(
                              "An unexpected error occurred: ${e.toString()}",
                              name: true,
                              email: true,
                              password: true,
                              confirmPassword: true,
                            );
                          }
                        },
                ),

                const SizedBox(height: 36),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
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