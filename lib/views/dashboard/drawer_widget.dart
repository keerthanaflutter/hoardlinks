// import 'package:flutter/material.dart';
// import 'package:hoardlinks/viewmodels/auth_provider.dart';
// import 'package:hoardlinks/views/auth/loginOriginal_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   // Opens URL inside the app
//   Future<void> _launchInAppURL(String urlString) async {
//     final Uri url = Uri.parse(urlString);
//     try {
//       if (await canLaunchUrl(url)) {
//         await launchUrl(
//           url,
//           mode: LaunchMode.inAppWebView, // Essential for "Inside the App"
//           webViewConfiguration: const WebViewConfiguration(
//             enableJavaScript: true,
//             enableDomStorage: true,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint("Could not launch $urlString: $e");
//     }
//   }

//   void _showLogoutConfirmation(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
//         content: const Text("Are you sure you want to end your session?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Keep Browsing", style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFB11226),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () async {
//               Navigator.pop(context);
//               await authProvider.logout();
//               if (context.mounted) {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                   (route) => false,
//                 );
//               }
//             },
//             child: const Text("Logout", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.75,
//       backgroundColor: const Color(0xFFF8F9FA), // Professional light grey
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Elegant minimal top spacing with a logo or text
//           SafeArea(
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//               alignment: Alignment.centerLeft,
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "HOARDLINKS",
//                     style: TextStyle(
//                       letterSpacing: 1.2,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Divider(color: Color(0xFFB11226), thickness: 2, endIndent: 180),
//                 ],
//               ),
//             ),
//           ),

//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               children: [
//                 _navTile(context, Icons.grid_view_rounded, "Dashboard", () => Navigator.pop(context)),
//                 _navTile(context, Icons.article_outlined, "Terms of Service", () {
//                   Navigator.pop(context);
//                   _launchInAppURL('https://cordsinnovations.com/terms.html');
//                 }),
//                 _navTile(context, Icons.shield_moon_outlined, "Privacy Policy", () {
//                   Navigator.pop(context);
//                   _launchInAppURL('https://cordsinnovations.com/privacy.html');
//                 }),
//                 _navTile(context, Icons.settings_suggest_outlined, "Settings", () {}),
//                 _navTile(context, Icons.contact_support_outlined, "Support", () {}),
//               ],
//             ),
//           ),

//           // Professional Logout Button at the bottom
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: InkWell(
//               onTap: () => _showLogoutConfirmation(context),
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.red.shade100),
//                   boxShadow: [
//                     BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
//                   ],
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.power_settings_new_rounded, color: Color(0xFFB11226)),
//                     SizedBox(width: 10),
//                     Text(
//                       "Sign Out",
//                       style: TextStyle(color: Color(0xFFB11226), fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _navTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: ListTile(
//         onTap: onTap,
//         leading: Icon(icon, color: const Color(0xFF635254), size: 24),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF2D3436),
//           ),
//         ),
//         trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         tileColor: Colors.transparent,
//         hoverColor: Colors.white,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/auth_provider.dart';
import 'package:hoardlinks/views/auth/loginOriginal_screen.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Add this
import 'package:shimmer/shimmer.dart'; // Add this

// Assuming these exist in your project
// import 'package:hoardlinks/providers/auth_provider.dart';
// import 'package:hoardlinks/presentation/screens/login_screen.dart';
// import 'package:hoardlinks/presentation/screens/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: const Color(0xFFF8F9FA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              alignment: Alignment.centerLeft,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "HOARDLINKS",
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(color: Color(0xFFB11226), thickness: 2, endIndent: 100),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _navTile(context, Icons.grid_view_rounded, "Dashboard", () => Navigator.pop(context)),
                _navTile(context, Icons.article_outlined, "Terms of Service", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppWebView(
                        title: "Terms of Service",
                        url: "https://cordsinnovations.com/terms.html",
                      ),
                    ),
                  );
                }),
                _navTile(context, Icons.shield_moon_outlined, "Privacy Policy", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppWebView(
                        title: "Privacy Policy",
                        url: "https://cordsinnovations.com/privacy.html",
                      ),
                    ),
                  );
                }),
                _navTile(context, Icons.settings_suggest_outlined, "Settings", () {}),
                _navTile(context, Icons.contact_support_outlined, "Support", () {}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () => _showLogoutConfirmation(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.power_settings_new_rounded, color: Color(0xFFB11226)),
                    SizedBox(width: 10),
                    Text(
                      "Sign Out",
                      style: TextStyle(color: Color(0xFFB11226), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF635254), size: 24),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
    );
  }
}

// --- INTERNAL WEBVIEW SCREEN WITH SHIMMER ---
class AppWebView extends StatefulWidget {
  final String title;
  final String url;

  const AppWebView({super.key, required this.title, required this.url});

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) => setState(() => _isLoading = true),
          onPageFinished: (String url) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) _buildShimmerEffect(),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(20),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: double.infinity, height: 20.0, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 250.0, height: 20.0, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}