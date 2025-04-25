import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_bloc.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_event.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_state.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/widget/custom_input_field.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/widget/sidebarx.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _buttonController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });

    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SidebarxScreen()),
            );
          }
        },
        builder: (context, state) {
          return ScreenBackGround(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            widget: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.08),
                          Text(
                            "👋 Welcome Back!",
                            style: TextStyle(
                              fontSize: screenHeight * 0.038,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "We missed you! Let's get you signed in.",
                            style: TextStyle(
                              fontSize: screenHeight * 0.018,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.06),
                          CustomInputField(
                            controller: _emailController,
                            icon: CupertinoIcons.mail,
                            label: "Email Address",
                            hint: "Enter your email",
                            keyboardType: TextInputType.emailAddress,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Please enter Email"
                                        : null,
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          CustomInputField(
                            controller: _passwordController,
                            icon: CupertinoIcons.lock,
                            label: "Password",
                            hint: "Enter your password",
                            obscureText: true,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Please enter password"
                                        : null,
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text;
                                final password = _passwordController.text;
                                context.read<AuthBloc>().add(
                                  AdminLoginRequested(
                                    email: email,
                                    password: password,
                                  ),
                                );
                              } else {
                                throw Exception('Form is Not Valid');
                              }
                            },
                            child: ScaleTransition(
                              scale: Tween(
                                begin: 1.0,
                                end: 0.95,
                              ).animate(_buttonController),
                              child: Container(
                                width: double.infinity,
                                height: screenHeight * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4A00E0),
                                      Color(0xFF8E2DE2),
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
