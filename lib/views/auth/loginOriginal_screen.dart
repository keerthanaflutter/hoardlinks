
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/banner_const.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/viewmodels/auth_provider.dart';
import 'package:hoardlinks/viewmodels/emialotp_get_provider.dart';
import 'package:hoardlinks/viewmodels/forgotpassword_prvoder.dart';
import 'package:hoardlinks/views/dashboard/dashboardoriginal_screen.dart.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final _emailForgotCtrl = TextEditingController();
  final _otpCodeCtrl = TextEditingController();
  final _newPasswordForgotCtrl = TextEditingController();

  bool _isOtpSent = false;
  String? _resetToken;
  bool _isNewPasswordHidden = true;
  bool _isPasswordHidden = true;
  String? _deviceId;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    _getFcmToken();
  }

  Future<void> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("❌ DEVICE ID ERROR: $e");
    }
  }

  Future<void> _getFcmToken() async {
    // Assuming AuthStorage is a helper class you've defined elsewhere
    final token = await AuthStorage.getFcmToken();
    setState(() {
      _fcmToken = token;
    });
  }

  /// ✅ Shows a centered Alert Dialog with an OK button
  void _showResponseDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showForgotPasswordSheet() {
    setState(() {
      _isOtpSent = false;
      _resetToken = null;
      _isNewPasswordHidden = true;
      _emailForgotCtrl.clear();
      _otpCodeCtrl.clear();
      _newPasswordForgotCtrl.clear();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final otpProvider = context.watch<EmailOtpGetProvider>();
          final resetProvider = context.watch<ForgotPasswordProvider>();

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: EdgeInsets.only(
              left: 25, right: 25, top: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4, 
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))
                  ),
                  const SizedBox(height: 25),
                  Text(
                    _isOtpSent ? "Reset Password" : "Forgot Password?", 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 30),
                  
                  TextField(
                    controller: _emailForgotCtrl,
                    enabled: !_isOtpSent,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),

                  if (_isOtpSent) ...[
                    const SizedBox(height: 15),
                    TextField(
                      controller: _otpCodeCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: "OTP Code",
                        prefixIcon: const Icon(Icons.pin_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _newPasswordForgotCtrl,
                      obscureText: _isNewPasswordHidden,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        suffixIcon: IconButton(
                          icon: Icon(_isNewPasswordHidden ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setSheetState(() => _isNewPasswordHidden = !_isNewPasswordHidden),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity, height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
                      onPressed: (otpProvider.isLoading || resetProvider.isLoading) ? null : () async {
                        if (!_isOtpSent) {
                          final token = await otpProvider.getOtp(_emailForgotCtrl.text.trim());
                          if (token != null) {
                            setSheetState(() { _isOtpSent = true; _resetToken = token; });
                          } else {
                            _showSnackBar(otpProvider.errorMessage ?? "Email not found", Colors.red);
                          }
                        } else {
                          // ✅ PHASE 2: RESET PASSWORD
                          final isSuccess = await resetProvider.resetPassword(
                            resetToken: _resetToken ?? "",
                            newPassword: _newPasswordForgotCtrl.text.trim(),
                            code: _otpCodeCtrl.text.trim(),
                          );

                          if (isSuccess) {
                            // 1. Close the Bottom Sheet first
                            Navigator.pop(context);
                            
                            // 2. Show the Success Alert Dialog on the main screen
                            _showResponseDialog(
                              "Success", 
                              resetProvider.successMessage ?? "Your password has been updated successfully.", 
                              true
                            );
                            resetProvider.clearMessages();
                          } else {
                            // 1. Close Bottom Sheet even on failure (optional, based on your preference)
                            Navigator.pop(context);

                            // 2. Show Error Alert Dialog
                            _showResponseDialog(
                              "Update Failed", 
                              resetProvider.errorMessage ?? "Invalid OTP code or request error.", 
                              false
                            );
                          }
                        }
                      },
                      child: (otpProvider.isLoading || resetProvider.isLoading)
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(_isOtpSent ? "UPDATE PASSWORD" : "SEND OTP CODE", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _emailForgotCtrl.dispose();
    _otpCodeCtrl.dispose();
    _newPasswordForgotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: SizedBox(
              height: 200,
              child: CustomPaint(painter: BottomBannerPainter()),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20, right: 20, 
                bottom: MediaQuery.of(context).viewInsets.bottom + 20
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Image.asset("assets/images/kaia_logo.png", height: 140),
                      const SizedBox(height: 40),
                      _inputRow("Username", _usernameCtrl),
                      const SizedBox(height: 20),
                      _inputRow("Password", _passwordCtrl, isPassword: true),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: auth.isLoading ? null : () async {
                          if (_fcmToken == null || _fcmToken!.isEmpty) {
                            _showSnackBar("FCM Token not available", Colors.black);
                            return;
                          }
                          final success = await auth.login(
                            loginId: _usernameCtrl.text.trim(),
                            password: _passwordCtrl.text.trim(),
                            deviceId: _deviceId ?? "",
                            fcmToken: _fcmToken!,
                          );
                          if (success) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                          } else {
                            _showSnackBar(auth.errorMessage ?? "Login failed", Colors.black);
                          }
                        },
                        child: _actionButton(auth.isLoading ? "Loading..." : "Login", auth.isLoading),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _showForgotPasswordSheet,
                        child: const Text("Forgot Password?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54)),
                      ),
                      const Spacer(),
                      const SizedBox(height: 40), 
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, bool loading) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black, 
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: loading 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _inputRow(String label, TextEditingController controller, {bool isPassword = false}) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
        Expanded(
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? _isPasswordHidden : false,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}


// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _usernameCtrl = TextEditingController();
//   final _passwordCtrl = TextEditingController();
//   bool _isPasswordHidden = true;

//   String? _deviceId;
//   String? _fcmToken;

//   @override
//   void initState() {
//     super.initState();
//     _getDeviceId();
//     _getFcmToken();
//   }

//   /// 🔥 GET DEVICE ID
//   Future<void> _getDeviceId() async {
//     final deviceInfo = DeviceInfoPlugin();

//     try {
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         _deviceId = androidInfo.id;
//       } else if (Platform.isIOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         _deviceId = iosInfo.identifierForVendor;
//       }

//       debugPrint("📱 DEVICE ID: $_deviceId");
//     } catch (e) {
//       debugPrint("❌ DEVICE ID ERROR: $e");
//     }
//   }

//   /// 🔥 GET FCM TOKEN
//   Future<void> _getFcmToken() async {
//     final token = await AuthStorage.getFcmToken();
//     setState(() {
//       _fcmToken = token;
//     });

//     debugPrint("🔥 FCM TOKEN: $_fcmToken");
//   }

//   @override
//   void dispose() {
//     _usernameCtrl.dispose();
//     _passwordCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               height: 260,
//               child: CustomPaint(
//                 painter: BottomBannerPainter(),
//               ),
//             ),
//           ),

//           SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 60),
//                 Image.asset("assets/images/kaia_logo.png", height: 160),
//                 const SizedBox(height: 20),

//                 // /// 🔥 SHOW FCM TOKEN IN UI
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                 //   child: Text(
//                 //     _fcmToken == null
//                 //         ? "FCM Token: Not Available"
//                 //         : "FCM Token:\n$_fcmToken",
//                 //     textAlign: TextAlign.center,
//                 //     style: TextStyle(
//                 //       fontSize: 12,
//                 //       color: _fcmToken == null ? Colors.red : Colors.black,
//                 //     ),
//                 //   ),
//                 // ),

//                 const SizedBox(height: 25),

//                 _inputRow("Username", _usernameCtrl),
//                 const SizedBox(height: 16),
//                 _inputRow("Password", _passwordCtrl, isPassword: true),
//                 const SizedBox(height: 25),

//                 /// 🔥 LOGIN BUTTON
//                 GestureDetector(
//                   onTap: auth.isLoading
//                       ? null
//                       : () async {
//                           debugPrint("🚀 LOGIN CLICKED");
//                           debugPrint("📱 DEVICE ID: $_deviceId");
//                           debugPrint("🔥 FCM TOKEN: $_fcmToken");

//                           /// ❌ CHECK FCM TOKEN NULL
//                           if (_fcmToken == null || _fcmToken!.isEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   "FCM Token not available. Try again.",
//                                 ),
//                               ),
//                             );
//                             return;
//                           }

//                           final success = await auth.login(
//                             loginId: _usernameCtrl.text.trim(),
//                             password: _passwordCtrl.text.trim(),
//                             deviceId: _deviceId ?? "",
//                             fcmToken: _fcmToken!,
//                           );

//                           if (success) {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const DashboardScreen(),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   auth.errorMessage ?? "Login failed",
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                   child: Container(
//                     width: 200,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     child: Center(
//                       child: auth.isLoading
//                           ? const CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             )
//                           : const Text(
//                               "Login",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 12),
//                 const Text(
//                   "Forgot Password?",
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _inputRow(
//     String label,
//     TextEditingController controller, {
//     bool isPassword = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Row(
//         children: [
//           SizedBox(width: 90, child: Text(label)),
//           Expanded(
//             child: TextFormField(
//               controller: controller,
//               obscureText: isPassword ? _isPasswordHidden : false,
//               decoration: InputDecoration(
//                 isDense: true,
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(22),
//                 ),
//                 suffixIcon: isPassword
//                     ? IconButton(
//                         icon: Icon(
//                           _isPasswordHidden
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _isPasswordHidden = !_isPasswordHidden;
//                           });
//                         },
//                       )
//                     : null,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

