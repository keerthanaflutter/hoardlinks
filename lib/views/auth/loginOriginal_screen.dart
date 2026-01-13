

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/banner_const.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/viewmodels/auth_provider.dart';
import 'package:hoardlinks/views/dashboard/dashboardoriginal_screen.dart.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isPasswordHidden = true;

  String? _deviceId;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    _getFcmToken();
  }

  /// 🔥 GET DEVICE ID
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

      debugPrint("📱 DEVICE ID: $_deviceId");
    } catch (e) {
      debugPrint("❌ DEVICE ID ERROR: $e");
    }
  }

  /// 🔥 GET FCM TOKEN
  Future<void> _getFcmToken() async {
    final token = await AuthStorage.getFcmToken();
    setState(() {
      _fcmToken = token;
    });

    debugPrint("🔥 FCM TOKEN: $_fcmToken");
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
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
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 260,
              child: CustomPaint(
                painter: BottomBannerPainter(),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset("assets/images/kaia_logo.png", height: 160),
                const SizedBox(height: 20),

                // /// 🔥 SHOW FCM TOKEN IN UI
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Text(
                //     _fcmToken == null
                //         ? "FCM Token: Not Available"
                //         : "FCM Token:\n$_fcmToken",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: _fcmToken == null ? Colors.red : Colors.black,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 25),

                _inputRow("Username", _usernameCtrl),
                const SizedBox(height: 16),
                _inputRow("Password", _passwordCtrl, isPassword: true),
                const SizedBox(height: 25),

                /// 🔥 LOGIN BUTTON
                GestureDetector(
                  onTap: auth.isLoading
                      ? null
                      : () async {
                          debugPrint("🚀 LOGIN CLICKED");
                          debugPrint("📱 DEVICE ID: $_deviceId");
                          debugPrint("🔥 FCM TOKEN: $_fcmToken");

                          /// ❌ CHECK FCM TOKEN NULL
                          if (_fcmToken == null || _fcmToken!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "FCM Token not available. Try again.",
                                ),
                              ),
                            );
                            return;
                          }

                          final success = await auth.login(
                            loginId: _usernameCtrl.text.trim(),
                            password: _passwordCtrl.text.trim(),
                            deviceId: _deviceId ?? "",
                            fcmToken: _fcmToken!,
                          );

                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DashboardScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  auth.errorMessage ?? "Login failed",
                                ),
                              ),
                            );
                          }
                        },
                  child: Container(
                    width: 200,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: auth.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputRow(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword ? _isPasswordHidden : false,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
