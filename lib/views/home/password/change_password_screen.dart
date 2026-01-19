import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/rest_password_provider.dart';
import 'package:provider/provider.dart';

class PasswordUpdateSheet extends StatefulWidget {
  const PasswordUpdateSheet({Key? key}) : super(key: key);

  @override
  State<PasswordUpdateSheet> createState() => _PasswordUpdateSheetState();
}

class _PasswordUpdateSheetState extends State<PasswordUpdateSheet> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final Color primaryColor = const Color(0xFFB11226);

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Handles keyboard
        left: 20, right: 20, top: 25,
      ),
      child: Consumer<PasswordUpdateProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Change Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Ensure your new password is secure.",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 20),
              
              // Old Password Field
              TextField(
                controller: _oldPassController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  prefixIcon: const Icon(Icons.lock_open),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              
              // New Password Field
              TextField(
                controller: _newPassController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              // Status Messages
              if (provider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),
              
              if (provider.successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(provider.successMessage!, style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
                ),

              const SizedBox(height: 25),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: provider.isLoading 
                    ? null 
                    : () async {
                        await provider.updatePassword(
                          _oldPassController.text, 
                          _newPassController.text
                        );
                        if (provider.successMessage != null) {
                          // Close sheet after showing success for 1.5 seconds
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            if (mounted) Navigator.pop(context);
                          });
                        }
                      },
                  child: provider.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Update Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}