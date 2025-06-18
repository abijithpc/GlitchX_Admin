import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/User_Page/Presentation/Bloc/user_bloc.dart';
import 'package:glitchx_admin/features/User_Page/Presentation/Bloc/user_event.dart';
import 'package:glitchx_admin/features/User_Page/Presentation/Bloc/user_state.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            tooltip: 'Refresh Users',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<UserBloc>().add(FetchUsers());
            },
          ),
        ],
      ),
      body: ScreenBackGround(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        widget: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              if (state.users.isEmpty) {
                return const Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.users.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                            (user.profilePictureUrl != null &&
                                    user.profilePictureUrl.isNotEmpty)
                                ? NetworkImage(user.profilePictureUrl)
                                : null,
                        child:
                            (user.profilePictureUrl == null ||
                                    user.profilePictureUrl.isEmpty)
                                ? Icon(
                                  Icons.person,
                                  size: 28,
                                  color: Colors.grey.shade700,
                                )
                                : null,
                      ),

                      title: Text(
                        user.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (user.isBlocked)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text(
                                'Unblock',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                context.read<UserBloc>().add(
                                  UnblockUser(user.uid),
                                );
                              },
                            )
                          else
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.block),
                              label: const Text(
                                'Block',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                context.read<UserBloc>().add(
                                  BlockUser(user.uid),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is UserError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
