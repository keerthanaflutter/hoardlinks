



import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/profile_provider.dart';


import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            return Center(
              child: Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          AssetImage('assets/images/profile.png'),
                    ),

                    const SizedBox(height: 12),

                    /// 🔥 NAME
                    Text(
                      provider.profileResponse?.data.loginId ??
                          "Tap button to load",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// 🔥 DETAILS
                    Text(
                      provider.profileResponse == null
                          ? "No data loaded"
                          : "Mobile: ${provider.profileResponse!.data.mobileNumber}\nRole: ${provider.profileResponse!.data.roleType}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 LOADING / BUTTON
                    provider.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ProfileProvider>()
                                  .fetchProfile(); // 🔥 API CALL
                            },
                            child: const Text("Load Profile"),
                          ),

                    /// 🔴 ERROR
                    if (provider.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
