import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/auth_provider.dart';
import 'package:hoardlinks/viewmodels/profile_provder.dart';
import 'package:hoardlinks/viewmodels/rest_password_provider.dart';
import 'package:hoardlinks/views/auth/loginOriginal_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:hoardlinks/viewmodels/profile_update_provider.dart';



// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final Color primaryColor = const Color(0xFFB11226);
  
//   // Controllers
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _oldPasswordController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
  
//   // Edit States
//   bool _isEditingMobile = false;
//   bool _isEditingPassword = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ProfileProvider>(context, listen: false).fetchProfile().then((_) {
//         final profile = Provider.of<ProfileProvider>(context, listen: false).profile;
//         if (profile != null) {
//           _mobileController.text = profile.mobileNumber;
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _mobileController.dispose();
//     _oldPasswordController.dispose();
//     _newPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: Consumer3<ProfileProvider, ProfileUpdateProvider, PasswordUpdateProvider>(
//         builder: (context, profileProvider, updateProvider, passwordProvider, child) {
//           if (profileProvider.isLoading) return _buildShimmerEffect();
//           if (profileProvider.error.isNotEmpty) return Center(child: Text(profileProvider.error));
//           if (profileProvider.profile == null) return const Center(child: Text('No profile data available.'));

//           final profile = profileProvider.profile!;

//           return CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildAppBar(profile),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSectionTitle("Agency Information"),
//                       _buildInfoTile(
//                         icon: Icons.business_center,
//                         label: "Legal Name",
//                         value: profile.agencyMember.legalName,
//                       ),
                      
//                       _buildEditableMobileTile(updateProvider, profileProvider),

//                       const SizedBox(height: 20),
//                       _buildSectionTitle("Security & Account"),
                      
//                       // Updated Password Section
//                       _buildEditablePasswordTile(passwordProvider),
                      
//                       const SizedBox(height: 20),
//                       _buildSectionTitle("Location Details"),
//                       _buildInfoTile(
//                         icon: Icons.map,
//                         label: "State",
//                         value: profile.stateCommittee.stateName,
//                       ),
//                       _buildInfoTile(
//                         icon: Icons.location_city,
//                         label: "District",
//                         value: profile.districtCommittee.districtName,
//                       ),
//                       const SizedBox(height: 30),
//                       _buildLogoutButton(context),
//                       const SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   /// 🔥 NEW: PASSWORD EDIT TILE
//   Widget _buildEditablePasswordTile(PasswordUpdateProvider passwordProvider) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _isEditingPassword ? primaryColor : Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.lock_outline, color: primaryColor, size: 20),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Password Management", 
//                       style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.bold)),
//                     if (!_isEditingPassword)
//                       const Text("••••••••", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//               if (!_isEditingPassword)
//                 IconButton(
//                   onPressed: () => setState(() => _isEditingPassword = true),
//                   icon: Icon(Icons.edit, color: primaryColor, size: 18),
//                 )
//             ],
//           ),
//           if (_isEditingPassword) ...[
//             const Divider(height: 20),
//             TextField(
//               controller: _oldPasswordController,
//               obscureText: true,
//               decoration: _inputDecoration("Old Password"),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _newPasswordController,
//               obscureText: true,
//               decoration: _inputDecoration("New Password"),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: passwordProvider.isLoading ? null : () {
//                     setState(() {
//                       _isEditingPassword = false;
//                       _oldPasswordController.clear();
//                       _newPasswordController.clear();
//                     });
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
//                   onPressed: passwordProvider.isLoading ? null : () async {
//                     await passwordProvider.updatePassword(
//                       _oldPasswordController.text, 
//                       _newPasswordController.text
//                     );

//                     if (passwordProvider.successMessage != null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(passwordProvider.successMessage!), backgroundColor: Colors.green),
//                       );
//                       setState(() {
//                         _isEditingPassword = false;
//                         _oldPasswordController.clear();
//                         _newPasswordController.clear();
//                       });
//                     }
//                   },
//                   child: passwordProvider.isLoading
//                     ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                     : const Text("Update Password", style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//             if (passwordProvider.errorMessage != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(passwordProvider.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
//               ),
//           ],
//         ],
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       isDense: true,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//     );
//   }

//   // --- REST OF YOUR ORIGINAL CODE (AppBar, MobileTile, etc.) ---
  
//   Widget _buildAppBar(profile) {
//     return SliverAppBar(
//       expandedHeight: 220.0,
//       pinned: true,
//       backgroundColor: primaryColor,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [primaryColor, primaryColor.withOpacity(0.8)],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 40),
//               const CircleAvatar(
//                 radius: 45,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 50, color: Color(0xFFB11226)),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 profile.agencyMember.tradeName,
//                 style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 profile.roleType,
//                 style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableMobileTile(ProfileUpdateProvider updateProvider, ProfileProvider profileProvider) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _isEditingMobile ? primaryColor : Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.phone_android, color: primaryColor, size: 20),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: _isEditingMobile
//                     ? TextField(
//                         controller: _mobileController,
//                         keyboardType: TextInputType.phone,
//                         decoration: const InputDecoration(hintText: "Enter Mobile Number", border: InputBorder.none),
//                       )
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Mobile Number", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
//                           Text(_mobileController.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//                         ],
//                       ),
//               ),
//               if (!_isEditingMobile)
//                 IconButton(
//                   onPressed: () => setState(() => _isEditingMobile = true),
//                   icon: Icon(Icons.edit, color: primaryColor, size: 18),
//                 )
//             ],
//           ),
//           if (_isEditingMobile) ...[
//             const Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(onPressed: () => setState(() => _isEditingMobile = false), child: const Text("Cancel")),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
//                   onPressed: () async {
//                     await updateProvider.updateProfile(_mobileController.text);
//                     if (updateProvider.isSuccess) {
//                       await profileProvider.fetchProfile();
//                       setState(() => _isEditingMobile = false);
//                     }
//                   },
//                   child: const Text("Submit", style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           ]
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) => Padding(
//     padding: const EdgeInsets.only(bottom: 12, left: 4),
//     child: Text(title.toUpperCase(), style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
//   );

//   Widget _buildInfoTile({required IconData icon, required String label, required String value}) => Container(
//     margin: const EdgeInsets.only(bottom: 12),
//     padding: const EdgeInsets.all(14),
//     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
//     child: Row(
//       children: [
//         Icon(icon, color: primaryColor, size: 20),
//         const SizedBox(width: 15),
//         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
//           Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//         ]),
//       ],
//     ),
//   );

//   Widget _buildLogoutButton(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         return SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: OutlinedButton(
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: primaryColor, width: 1.5),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             onPressed: authProvider.isLoading ? null : () => _showLogoutConfirmation(context, authProvider),
//             child: authProvider.isLoading
//                 ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB11226)))
//                 : Text("Logout", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
//           ),
//         );
//       },
//     );
//   }

//   void _showLogoutConfirmation(BuildContext context, AuthProvider authProvider) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Logout"),
//         content: const Text("Are you sure you want to logout?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await authProvider.logout();
//               Navigator.pushAndRemoveUntil(
//                 context, 
//                 MaterialPageRoute(builder: (context) => const LoginScreen()), 
//                 (route) => false
//               );
//             },
//             child: Text("Logout", style: TextStyle(color: primaryColor)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildShimmerEffect() => Shimmer.fromColors(
//     baseColor: Colors.grey[300]!,
//     highlightColor: Colors.grey[100]!,
//     child: Column(children: [Container(height: 220, color: Colors.white), const SizedBox(height: 20)]),
//   );
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryColor = const Color(0xFFB11226);

  // Controllers
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  // Edit States
  bool _isEditingMobile = false;
  bool _isEditingPassword = false;

  // Password Visibility States
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile().then((_) {
        final profile = Provider.of<ProfileProvider>(context, listen: false).profile;
        if (profile != null) {
          _mobileController.text = profile.mobileNumber;
        }
      });
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer3<ProfileProvider, ProfileUpdateProvider, PasswordUpdateProvider>(
        builder: (context, profileProvider, updateProvider, passwordProvider, child) {
          if (profileProvider.isLoading) return _buildShimmerEffect();
          if (profileProvider.error.isNotEmpty) return Center(child: Text(profileProvider.error));
          if (profileProvider.profile == null) return const Center(child: Text('No profile data available.'));

          final profile = profileProvider.profile!;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(profile),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Agency Information"),
                      _buildInfoTile(
                        icon: Icons.business_center,
                        label: "Legal Name",
                        value: profile.agencyMember.legalName,
                      ),
                      _buildEditableMobileTile(updateProvider, profileProvider),

                      const SizedBox(height: 20),
                      _buildSectionTitle("Security & Account"),
                      
                      // ✅ Updated Password Section
                      _buildEditablePasswordTile(passwordProvider),

                      const SizedBox(height: 20),
                      _buildSectionTitle("Location Details"),
                      _buildInfoTile(
                        icon: Icons.map,
                        label: "State",
                        value: profile.stateCommittee.stateName,
                      ),
                      _buildInfoTile(
                        icon: Icons.location_city,
                        label: "District",
                        value: profile.districtCommittee.districtName,
                      ),
                      const SizedBox(height: 30),
                      _buildLogoutButton(context),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ✅ PASSWORD EDIT TILE WITH VISIBILITY TOGGLE
  Widget _buildEditablePasswordTile(PasswordUpdateProvider passwordProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isEditingPassword ? primaryColor : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_reset_rounded, color: primaryColor, size: 22),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reset Password", // ✅ Changed Title
                        style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.bold)),
                    if (!_isEditingPassword)
                      const Text("••••••••", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (!_isEditingPassword)
                IconButton(
                  onPressed: () => setState(() => _isEditingPassword = true),
                  icon: Icon(Icons.edit, color: primaryColor, size: 18),
                )
            ],
          ),
          if (_isEditingPassword) ...[
            const Divider(height: 20),
            
            // Old Password Field
            TextField(
              controller: _oldPasswordController,
              obscureText: !_isOldPasswordVisible, // ✅ Visibility logic
              decoration: _inputDecoration("Old Password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_isOldPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 20),
                  onPressed: () => setState(() => _isOldPasswordVisible = !_isOldPasswordVisible),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // New Password Field
            TextField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible, // ✅ Visibility logic
              decoration: _inputDecoration("New Password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 20),
                  onPressed: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: passwordProvider.isLoading ? null : () {
                    setState(() {
                      _isEditingPassword = false;
                      _oldPasswordController.clear();
                      _newPasswordController.clear();
                    });
                  },
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: passwordProvider.isLoading ? null : () async {
                    final success = await passwordProvider.updatePassword(
                      _oldPasswordController.text.trim(),
                      _newPasswordController.text.trim()
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(passwordProvider.successMessage ?? "Success"), backgroundColor: Colors.green),
                      );
                      setState(() {
                        _isEditingPassword = false;
                        _oldPasswordController.clear();
                        _newPasswordController.clear();
                      });
                    }
                  },
                  child: passwordProvider.isLoading
                    ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Update Password", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            if (passwordProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(passwordProvider.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      labelStyle: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildAppBar(profile) {
    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFFB11226)),
              ),
              const SizedBox(height: 12),
              Text(
                profile.agencyMember.tradeName,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                profile.roleType,
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildEditableMobileTile(ProfileUpdateProvider updateProvider, ProfileProvider profileProvider) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: _isEditingMobile ? primaryColor : Colors.grey.shade200,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.phone_android, color: primaryColor, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: _isEditingMobile
                  ? TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      enabled: !updateProvider.isLoading, // Disable during loading
                      decoration: const InputDecoration(
                        hintText: "Enter Mobile Number",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mobile Number", 
                          style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                        Text(_mobileController.text, 
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
            if (!_isEditingMobile)
              IconButton(
                onPressed: () {
                  updateProvider.clearStatus(); // Reset provider messages
                  setState(() => _isEditingMobile = true);
                },
                icon: Icon(Icons.edit, color: primaryColor, size: 18),
              )
          ],
        ),
        if (_isEditingMobile) ...[
          const Divider(),
          // Show error message if it exists
          if (updateProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 35),
              child: Text(
                updateProvider.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: updateProvider.isLoading 
                    ? null 
                    : () {
                        updateProvider.clearStatus();
                        setState(() => _isEditingMobile = false);
                      }, 
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: updateProvider.isLoading
                    ? null
                    : () async {
                        await updateProvider.updateProfile(_mobileController.text.trim());
                        
                        if (updateProvider.isSuccess) {
                          // Refresh the main profile data
                          await profileProvider.fetchProfile();
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Mobile number updated successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() => _isEditingMobile = false);
                          }
                        }
                      },
                child: updateProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ]
      ],
    ),
  );
}

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12, left: 4),
    child: Text(title.toUpperCase(), style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
  );

  Widget _buildInfoTile({required IconData icon, required String label, required String value}) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
    child: Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ]),
      ],
    ),
  );

  Widget _buildLogoutButton(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primaryColor, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: authProvider.isLoading ? null : () => _showLogoutConfirmation(context, authProvider),
            child: authProvider.isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB11226)))
                : Text("Logout", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to end your session?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Not know", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB11226),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(children: [Container(height: 220, color: Colors.white), const SizedBox(height: 20)]),
  );
}