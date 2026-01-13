import 'package:flutter/material.dart';
import 'package:hoardlinks/core/services/notification/pushnotification_service.dart';
import 'package:hoardlinks/viewmodels/auth_provider.dart';
import 'package:hoardlinks/views/auth/loginOriginal_screen.dart';
import 'package:hoardlinks/views/dashboard/dashboardoriginal_screen.dart.dart';
import 'package:provider/provider.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
     PushnotificationService().initFCM();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    _navigateNext();
  }

  Future<void> _navigateNext() async {
     final auth = context.read<AuthProvider>();

    // ✅ CHECK TOKEN
    await auth.checkLoginStatus();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => auth.isLoggedIn
            ? const DashboardScreen()
            : LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/kaia_logo.png',
              height: 140,
            ),
          ),
        ),
      ),
    );
  }
}

