import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/responsive.dart';
import 'package:hoardlinks/viewmodels/profile_provder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch profile data when the screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProfileProvider>().fetchProfile();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(r.width * 0.04),
//           child: Column(
//             children: [
//               /// -------- TOP BANNER (Wrapped with Consumer) --------
//               Consumer<ProfileProvider>(
//                 builder: (context, provider, child) {
//                   if (provider.isLoading) {
//                     return _buildShimmerBanner(r);
//                   }

//                   if (provider.error.isNotEmpty) {
//                     return _buildErrorBanner(provider.error, r);
//                   }

//                   final profile = provider.profile;
                  
//                   return Container(
//                     height: r.height * 0.16, // Slightly increased to fit 3 lines
//                     padding: EdgeInsets.all(r.width * 0.04),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         /// Profile Image
//                         CircleAvatar(
//                           radius: r.width * 0.08,
//                           backgroundColor: Colors.grey.shade200,
//                           child: Icon(Icons.person, color: Colors.grey, size: r.width * 0.08),
//                         ),

//                         SizedBox(width: r.width * 0.04),

//                         /// Name, Legal Name & Role (Dynamic Data)
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 profile?.agencyMember.tradeName ?? "Loading...",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 profile?.agencyMember.legalName ?? "",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontSize: 13,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 "Role: ${profile?.roleType ?? ""}",
//                                 style: const TextStyle(
//                                   color: Color(0xFFB11226), // Branding color
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         /// KAIA Logo
//                         Image.asset(
//                           "assets/images/kaia_logo.png",
//                           height: r.height * 0.06,
//                           errorBuilder: (context, error, stackTrace) => 
//                               const Icon(Icons.business, size: 40),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),

//               SizedBox(height: r.height * 0.03),

//               /// -------- GRID CARDS --------
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: r.width * 0.04,
//                   mainAxisSpacing: r.width * 0.04,
//                   childAspectRatio: 1,
//                   children: const [
//                     _HomeCard(
//                       title: "KAIA Alerts",
//                       subtitle: "Latest notifications\n& updates",
//                       color: Color(0xFFFFE1E1),
//                     ),
//                     _EventCalendarCard(),
//                     _EventMembershipCard(),
//                     _HomeCard(
//                       title: "Emergency Alert",
//                       subtitle: "Important emergency\ncontacts",
//                       color: Color.fromARGB(255, 245, 243, 240),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Shimmer Effect for the Banner
//   Widget _buildShimmerBanner(Responsive r) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         height: r.height * 0.16,
//         padding: EdgeInsets.all(r.width * 0.04),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(radius: r.width * 0.08, backgroundColor: Colors.white),
//             SizedBox(width: r.width * 0.04),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(width: double.infinity, height: 15, color: Colors.white),
//                   const SizedBox(height: 8),
//                   Container(width: r.width * 0.3, height: 12, color: Colors.white),
//                   const SizedBox(height: 8),
//                   Container(width: r.width * 0.2, height: 10, color: Colors.white),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Error UI inside the banner
//   Widget _buildErrorBanner(String message, Responsive r) {
//     return Container(
//       height: r.height * 0.16,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.red.shade100),
//       ),
//       child: Center(
//         child: Text(
//           "Error: $message",
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: Colors.red),
//         ),
//       ),
//     );
//   }
// }

// class _HomeCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final Color color;

//   const _HomeCard({
//     required this.title,
//     required this.subtitle,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive(context);

//     return Container(
//       padding: EdgeInsets.all(r.width * 0.04),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.red,
//             ),
//           ),
//           SizedBox(height: r.height * 0.01),
//           Text(subtitle, style: const TextStyle(color: Colors.black54)),
//         ],
//       ),
//     );
//   }
// }

// class _EventCalendarCard extends StatelessWidget {
//   const _EventCalendarCard();

//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive(context);

//     return Container(
//       padding: EdgeInsets.all(r.width * 0.03),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Title
//           const Text(
//             "KAIA Event Calendar",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//               fontSize: 14,
//             ),
//           ),

//           SizedBox(height: r.height * 0.01),

//           /// Month Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Icon(Icons.chevron_left, size: 18),
//               Text(
//                 "October 2024",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Icon(Icons.chevron_right, size: 18),
//             ],
//           ),

//           SizedBox(height: r.height * 0.01),

//           /// Calendar Grid
//           Expanded(
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: 31,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 7,
//                 mainAxisSpacing: 4,
//                 crossAxisSpacing: 4,
//               ),
//               itemBuilder: (context, index) {
//                 final day = index + 1;
//                 final isEventDay = day == 7 || day == 18;

//                 return Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: isEventDay ? Colors.red : Colors.transparent,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     "$day",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: isEventDay ? Colors.white : Colors.black,
//                       fontWeight: isEventDay
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EventMembershipCard extends StatelessWidget {
//   const _EventMembershipCard();

//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive(context);

//     return Container(
//       padding: EdgeInsets.all(r.width * 0.03),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Title
//           SizedBox(height: r.height * 0.01),
//           const Text(
//             "KAIA Membership",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//               fontSize: 14,
//             ),
//           ),

//           SizedBox(height: r.height * 0.01),

//           Text(
//             "Payment due",
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//               fontSize: 14,
//             ),
//           ),
//           Text(
//             "-3000/- to District for event hosting",
//             style: TextStyle(
//               fontWeight: FontWeight.w300,
//               color: Colors.black,
//               fontSize: 14,
//             ),
//           ),
//           Text(
//             "-500/- to State for comman event",
//             style: TextStyle(
//               fontWeight: FontWeight.w300,
//               color: Colors.black,
//               fontSize: 14,
//             ),
//           ),
          

//           /// Calendar Grid
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data with a minimum 2-second delay for the shimmer effect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Future.wait ensures both the API call and the 2-second timer complete
    await Future.wait([
      context.read<ProfileProvider>().fetchProfile(),
      Future.delayed(const Duration(seconds: 2)), 
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            // If the provider is loading OR we are in the initial 2-second window
            if (provider.isLoading) {
              return _buildFullPageShimmer(r);
            }

            if (provider.error.isNotEmpty) {
              return Center(child: _buildErrorBanner(provider.error, r));
            }

            final profile = provider.profile;

            return Padding(
              padding: EdgeInsets.all(r.width * 0.04),
              child: Column(
                children: [
                  /// -------- TOP BANNER --------
                  Container(
                    height: r.height * 0.16,
                    padding: EdgeInsets.all(r.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: r.width * 0.08,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(Icons.person, color: Colors.grey, size: r.width * 0.08),
                        ),
                        SizedBox(width: r.width * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                profile?.agencyMember.tradeName ?? "N/A",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                profile?.agencyMember.legalName ?? "",
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Role: ${profile?.roleType ?? ""}",
                                style: const TextStyle(
                                  color: Color(0xFFB11226),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/images/kaia_logo.png",
                          height: r.height * 0.06,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 40),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: r.height * 0.03),

                  /// -------- GRID CARDS --------
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: r.width * 0.04,
                      mainAxisSpacing: r.width * 0.04,
                      childAspectRatio: 1,
                      children: const [
                        _HomeCard(
                          title: "KAIA Alerts",
                          subtitle: "Latest notifications\n& updates",
                          color: Color(0xFFFFE1E1),
                        ),
                        _EventCalendarCard(),
                        _EventMembershipCard(),
                        _HomeCard(
                          title: "Emergency Alert",
                          subtitle: "Important emergency\ncontacts",
                          color: Color.fromARGB(255, 245, 243, 240),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Complete Page Shimmer Effect
  Widget _buildFullPageShimmer(Responsive r) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.all(r.width * 0.04),
        child: Column(
          children: [
            // Banner Shimmer
            Container(
              height: r.height * 0.16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: r.height * 0.03),
            // Grid Shimmer
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: r.width * 0.04,
                mainAxisSpacing: r.width * 0.04,
                children: List.generate(4, (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message, Responsive r) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text("Error: $message", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
          TextButton(onPressed: () => _loadData(), child: const Text("Retry"))
        ],
      ),
    );
  }
}

// --- KEEP YOUR _HomeCard, _EventCalendarCard, and _EventMembershipCard implementation below ---

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _HomeCard({required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Container(
      padding: EdgeInsets.all(r.width * 0.04),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
          SizedBox(height: r.height * 0.01),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _EventCalendarCard extends StatelessWidget {
  const _EventCalendarCard();

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Container(
      padding: EdgeInsets.all(r.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("KAIA Event Calendar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14)),
          SizedBox(height: r.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_left, size: 18),
              Text("Oct 2024", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Icon(Icons.chevron_right, size: 18),
            ],
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 28,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (context, index) => Center(child: Text("${index + 1}", style: const TextStyle(fontSize: 10))),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMembershipCard extends StatelessWidget {
  const _EventMembershipCard();

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Container(
      padding: EdgeInsets.all(r.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 5),
          Text("KAIA Membership", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14)),
          SizedBox(height: 10),
          Text("Payment due", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
          Text("-3000/- District", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11)),
          Text("-500/- State", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11)),
        ],
      ),
    );
  }
}