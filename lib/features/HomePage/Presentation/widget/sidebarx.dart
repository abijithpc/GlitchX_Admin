import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/Core/Widgets/sign_out.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/login_page.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/widget/screens.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarxScreen extends StatefulWidget {
  const SidebarxScreen({super.key});

  @override
  State<SidebarxScreen> createState() => _SidebarxScreenState();
}

class _SidebarxScreenState extends State<SidebarxScreen> {
  final SidebarXController _controller = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 148, 146, 146),
        actions: [
          GestureDetector(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('Delete Product?'),
                    content: const Text('Are you sure you want to Sign Out?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text('Sign Out'),
                        onPressed: () {
                          signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 7),
                  Text("Log Out", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ScreenBackGround(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        widget: Row(
          children: [
            SidebarX(
              controller: _controller,
              extendedTheme: SidebarXTheme(width: 120),
              theme: SidebarXTheme(
                decoration: const BoxDecoration(color: Colors.black87),
                selectedTextStyle: const TextStyle(color: Colors.white),
                textStyle: const TextStyle(color: Colors.grey),
                selectedItemDecoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                iconTheme: const IconThemeData(color: Colors.grey),
                selectedIconTheme: const IconThemeData(color: Colors.white),
              ),
              items: [
                SidebarXItem(icon: Icons.dashboard, label: "Dashboard"),
                SidebarXItem(icon: Icons.shopping_cart, label: "Order"),
                SidebarXItem(icon: Icons.category, label: "Category"),
                SidebarXItem(icon: Icons.shopping_bag, label: "Product"),
              ],
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return screens[_controller.selectedIndex];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
