import 'package:flutter/material.dart';
import '../profile_view_model/profile_event.dart';
import '../profile_view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../profile_view_model/profile_bloc.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  double _passwordStrength = 0;

  void _checkPasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.3;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength += 0.3;
    setState(() => _passwordStrength = strength.clamp(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ChangePasswordLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ChangePasswordSuccess) {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully!')));
            Navigator.of(context).pop();
          });
          return const Scaffold(body: SizedBox.shrink());
        } else if (state is ChangePasswordError) {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          });
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Change Password'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFE0B2), Color(0xFFFFFFFF)],
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: CircleAvatar(
                                radius: 38,
                                backgroundColor: Colors.orange.shade100,
                                child: const Icon(Icons.lock, size: 44, color: Colors.orange),
                              ),
                            ),
                            const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                            const SizedBox(height: 6),
                            Text('Keep your account secure', style: TextStyle(color: Colors.grey, fontSize: 14)),
                            const SizedBox(height: 28),
                            TextFormField(
                              controller: _oldPasswordController,
                              obscureText: _obscureOld,
                              decoration: InputDecoration(
                                labelText: 'Old Password',
                                prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                helperText: 'Enter your current password',
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureOld ? Icons.visibility_off : Icons.visibility, color: Colors.orange),
                                  onPressed: () => setState(() => _obscureOld = !_obscureOld),
                                ),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Enter your old password' : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: _obscureNew,
                              onChanged: _checkPasswordStrength,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.orange),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                helperText: 'At least 8 characters, 1 number, 1 uppercase, 1 symbol',
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility, color: Colors.orange),
                                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                                ),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Enter your new password' : null,
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _passwordStrength,
                              backgroundColor: Colors.orange.shade50,
                              color: _passwordStrength > 0.7
                                  ? Colors.green
                                  : _passwordStrength > 0.4
                                      ? Colors.orange
                                      : Colors.red,
                              minHeight: 6,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.orange),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                helperText: 'Re-enter your new password',
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: Colors.orange),
                                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Confirm your new password';
                                if (value != _newPasswordController.text) return 'Passwords do not match';
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      side: const BorderSide(color: Colors.orange, width: 1.5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<ProfileBloc>().add(ChangePasswordEvent(
                                          oldPassword: _oldPasswordController.text,
                                          newPassword: _newPasswordController.text,
                                        ));
                                      }
                                    },
                                    child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 