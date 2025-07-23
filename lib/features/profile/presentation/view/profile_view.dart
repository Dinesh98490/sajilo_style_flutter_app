import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_bloc.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_event.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_state.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';
import 'package:sajilo_style/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sajilo_style/features/profile/presentation/view/help_support_view.dart';
import 'package:sajilo_style/features/profile/presentation/view/settings_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => serviceLocator<ProfileBloc>()..add(FetchProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileError) {
            return Scaffold(
              body: Center(child: Text('Error: ${state.message}')),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: Column(
                children: [
                  const SizedBox(height: 24),
                  // Avatar with fallback to initials
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange.shade200,
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                          : '',
                      style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  // Info cards
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ProfileTile(
                          icon: Icons.shopping_bag,
                          title: 'My Orders',
                          onTap: () {},
                        ),
                        ProfileTile(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsView(),
                              ),
                            );
                          },
                        ),
                        ProfileTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpSupportView(),
                              ),
                            );
                          },
                        ),
                        ProfileTile(
                          icon: Icons.logout,
                          title: 'Logout',
                          iconColor: Colors.red,
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );
                            await serviceLocator<TokenSharedPrefs>().removeToken();
                            if (context.mounted) {
                              Navigator.of(context).pop(); // Remove loading dialog
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: serviceLocator<LoginViewModel>(),
                                    child: LoginView(),
                                  ),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          // Initial state
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
