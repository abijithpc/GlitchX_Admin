import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_bloc.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_event.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_state.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/login_page.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/widget/sidebarx.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _Splashscreen1State();
}

class _Splashscreen1State extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5), () {
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SidebarxScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SidebarxScreen()),
            );
          } else if (state is AuthEmailNotVerified) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('Assets/Logo/Untitled_design-removebg-preview.png'),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 30, letterSpacing: 5),
                  child: AnimatedTextKit(
                    animatedTexts: [WavyAnimatedText("GlitchX Admin")],
                    isRepeatingAnimation: true,
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
