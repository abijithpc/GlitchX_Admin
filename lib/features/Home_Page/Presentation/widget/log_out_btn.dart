import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitchx_admin/Core/Widgets/sign_out.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/login_page.dart';

class LogOutBtn extends StatelessWidget {
  const LogOutBtn({
    super.key,
    required this.user,
    required this.screenWidth,
  });

  final User? user;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder:
              (context) => CupertinoAlertDialog(
                title: Text("Sign Out"),
                content: Text("Are you Sure you want to Log Out"),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      signOut();
                      if (user != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );
      },
      child: Row(
        children: [
          Icon(Icons.logout, color: Colors.red),
          SizedBox(width: screenWidth * 0.01),
          Text("Sign Out", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
