import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/auth_provider.dart';
import 'package:hoardlinks/viewmodels/profile_provder.dart';
import 'package:hoardlinks/viewmodels/profileimage_provider.dart';
import 'package:hoardlinks/viewmodels/rest_password_provider.dart';
import 'package:hoardlinks/views/auth/loginOriginal_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hoardlinks/viewmodels/profile_update_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryColor = const Color(0xFFB11226);
  final ImagePicker _picker = ImagePicker();
  File? _localImageFile;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isEditingMobile = false;
  bool _isEditingPassword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfileData();
    });
  }

  Future<void> _refreshProfileData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.fetchProfile();
    
    if (profileProvider.profile != null && mounted) {
      setState(() {
        _mobileController.text = profileProvider.profile!.mobileNumber;
        _localImageFile = null; 
      });
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // --- LOGOUT LOGIC ---
  void _showLogoutConfirmation(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (mounted) {
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

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        setState(() => _localImageFile = imageFile);

        final uploadProvider = Provider.of<ProfileImageUploadProvider>(context, listen: false);
        await uploadProvider.uploadProfileImage(imageFile);
        await _refreshProfileData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile picture updated!"), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer4<ProfileProvider, ProfileUpdateProvider, PasswordUpdateProvider, ProfileImageUploadProvider>(
        builder: (context, profileProvider, updateProvider, passwordProvider, imageUploadProvider, child) {
          
          bool isInitialLoading = profileProvider.isLoading && profileProvider.profile == null;
          if (isInitialLoading || imageUploadProvider.isLoading) return _buildShimmerEffect();

          if (profileProvider.error.isNotEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${profileProvider.error}"),
                ElevatedButton(onPressed: _refreshProfileData, child: const Text("Retry"))
              ],
            ));
          }

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
                      _buildInfoTile(icon: Icons.business_center, label: "Legal Name", value: profile.agencyMember.legalName),
                      _buildInfoTile(icon: Icons.storefront, label: "Trade Name", value: profile.agencyMember.tradeName),
                      _buildEditableMobileTile(updateProvider),
                      
                      const SizedBox(height: 20),
                      _buildSectionTitle("Security & Account"),
                      _buildInfoTile(icon: Icons.badge_outlined, label: "Login ID", value: profile.loginId),
                      _buildEditablePasswordTile(passwordProvider),
                      
                      const SizedBox(height: 20),
                      _buildSectionTitle("Location Details"),
                      _buildInfoTile(icon: Icons.map, label: "State", value: profile.stateCommittee.stateName),
                      _buildInfoTile(icon: Icons.location_city, label: "District", value: profile.districtCommittee.districtName),
                      
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

  Widget _buildAppBar(profile) {
    return SliverAppBar(
      expandedHeight: 240.0,
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
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 47,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(child: _buildProfileImage(profile)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _showImageSourceActionSheet(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Icons.camera_alt, color: primaryColor, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(profile.agencyMember.tradeName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(profile.roleType.toUpperCase(), style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10, letterSpacing: 1.2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(profile) {
    if (_localImageFile != null) return Image.file(_localImageFile!, fit: BoxFit.cover, width: 100, height: 100);
    if (profile.imgUrl == null || profile.imgUrl!.isEmpty) return Icon(Icons.person, size: 60, color: primaryColor);
    return Image.network(
      profile.imgUrl!,
      fit: BoxFit.cover,
      width: 100,
      height: 100,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 60, color: primaryColor),
    );
  }

  Widget _buildEditableMobileTile(ProfileUpdateProvider updateProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isEditingMobile ? primaryColor : Colors.grey.shade200),
      ),
      child: Column(
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
                        decoration: const InputDecoration(hintText: "Enter Mobile", border: InputBorder.none, isDense: true),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mobile Number", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                          Text(_mobileController.text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
              ),
              IconButton(
                onPressed: () => setState(() => _isEditingMobile = !_isEditingMobile),
                icon: Icon(_isEditingMobile ? Icons.close : Icons.edit, color: primaryColor, size: 18),
              )
            ],
          ),
          if (_isEditingMobile)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: updateProvider.isLoading ? null : () async {
                  await updateProvider.updateProfile(_mobileController.text);
                  if (updateProvider.isSuccess) {
                    _refreshProfileData();
                    setState(() => _isEditingMobile = false);
                  }
                },
                child: updateProvider.isLoading 
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("SAVE CHANGES", style: TextStyle(color: Colors.white)),
              ),
            )
        ],
      ),
    );
  }

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
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, color: primaryColor, size: 20),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Security", style: TextStyle(color: Colors.grey, fontSize: 11)),
                    Text("Change Account Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _isEditingPassword = !_isEditingPassword),
                icon: Icon(_isEditingPassword ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: primaryColor),
              )
            ],
          ),
          if (_isEditingPassword) ...[
            const Divider(height: 20),
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Old Password",
                prefixIcon: Icon(Icons.vpn_key_outlined, size: 18),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                prefixIcon: Icon(Icons.lock_reset, size: 18),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: passwordProvider.isLoading ? null : () async {
                  bool success = await passwordProvider.updatePassword(
                    _oldPasswordController.text, 
                    _newPasswordController.text
                  );
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(passwordProvider.successMessage ?? "Success"), backgroundColor: Colors.green),
                    );
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                    setState(() => _isEditingPassword = false);
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(passwordProvider.errorMessage ?? "Error"), backgroundColor: Colors.red),
                    );
                  }
                },
                child: passwordProvider.isLoading 
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("SUBMIT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String label, required String value}) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
    child: Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ])),
      ],
    ),
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12, left: 4),
    child: Text(title.toUpperCase(), style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.bold)),
  );

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(side: BorderSide(color: primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () => _showLogoutConfirmation(context),
        icon: Icon(Icons.logout, color: primaryColor, size: 18),
        label: Text("LOGOUT ACCOUNT", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () { Navigator.pop(context); _pickAndUploadImage(ImageSource.gallery); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () { Navigator.pop(context); _pickAndUploadImage(ImageSource.camera); },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 240, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: List.generate(6, (i) => Container(height: 65, margin: const EdgeInsets.only(bottom: 15), color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
