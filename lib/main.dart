import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/services/notification/pushnotification_service.dart';
import 'package:hoardlinks/viewmodels/advanced_serch_provider.dart';
import 'package:hoardlinks/viewmodels/agency_details_provider.dart';
import 'package:hoardlinks/viewmodels/auth_provider.dart';
import 'package:hoardlinks/viewmodels/aution_provider.dart';
import 'package:hoardlinks/viewmodels/chitttybig_provider.dart';
import 'package:hoardlinks/viewmodels/chitty_agency_district_provider.dart';
import 'package:hoardlinks/viewmodels/chitty_join_provider.dart';
import 'package:hoardlinks/viewmodels/chittydetails_provider.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/viewmodels/chittyscheem_get_provider.dart';
import 'package:hoardlinks/viewmodels/district_get_provider.dart';
import 'package:hoardlinks/viewmodels/emialotp_get_provider.dart';
import 'package:hoardlinks/viewmodels/forgotpassword_prvoder.dart';
import 'package:hoardlinks/viewmodels/profileimage_provider.dart';
import 'package:hoardlinks/viewmodels/rest_password_provider.dart';
import 'package:hoardlinks/viewmodels/profile_provder.dart';
import 'package:hoardlinks/viewmodels/profile_update_provider.dart';
import 'package:hoardlinks/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase initialization
  final notificationService = PushnotificationService();
  await notificationService.initFCM(); // Initialize FCM

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  runApp(const MyApp());
}



Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("📩 Background message: ${message.notification?.title}");
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChittyProvider()),
        ChangeNotifierProvider(create: (_) => ChittyDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ChittyBidProvider()),
        ChangeNotifierProvider(create: (_) => AuctionIdProvider()),
        ChangeNotifierProvider(create: (_) => ChittyJoinProvider()),
        ChangeNotifierProvider(create: (_) => AgencyProvider()),
        ChangeNotifierProvider(create: (_) => ChittyDistrictAgencyProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PasswordUpdateProvider()),
        ChangeNotifierProvider(create: (_) => ProfileUpdateProvider()),
        ChangeNotifierProvider(create: (_) => DistrictGetProvider()),
        ChangeNotifierProvider(create: (_) => AdvanceSearchProvider()),
        ChangeNotifierProvider(create: (_) => AgencyDetailprovider()),
        ChangeNotifierProvider(create: (_) => EmailOtpGetProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ProfileImageUploadProvider()),
      ],
      child: MaterialApp(
        navigatorKey: AppNavigator.navigatorKey, // ⭐ REQUIRED
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        
      ),
    );
  }
}
