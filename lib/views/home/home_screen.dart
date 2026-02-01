import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/responsive.dart';
import 'package:hoardlinks/viewmodels/profile_provder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    await Future.wait([
      context.read<ProfileProvider>().fetchProfile(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      // CRITICAL: Set to transparent to see the banner behind
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) return _buildFullPageShimmer(r);
            if (provider.error.isNotEmpty)
              return Center(child: _buildErrorBanner(provider.error, r));

            final profile = provider.profile;
            final String? imageUrl = profile!.imgUrl;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: r.width * 0.04),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// TOP PROFILE CARD
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
  child: ClipOval(
    child: (imageUrl != null && imageUrl.isNotEmpty)
        ? Image.network(
            imageUrl,
            width: r.width * 0.16,
            height: r.width * 0.16,
            fit: BoxFit.cover,
            // THIS HANDLES THE 404 ERROR
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person,
                color: Colors.grey,
                size: r.width * 0.08,
              );
            },
            // OPTIONAL: Shows a small loading spinner while fetching
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator(strokeWidth: 2));
            },
          )
        : Icon(
            Icons.person,
            color: Colors.grey,
            size: r.width * 0.08,
          ),
  ),
),

                        // CircleAvatar(
                        //   radius: r.width * 0.08,
                        //   backgroundColor: Colors.grey.shade200,
                        //   child: Icon(Icons.person, color: Colors.grey, size: r.width * 0.08),
                        // ),
                        SizedBox(width: r.width * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                profile?.agencyMember.tradeName ?? "N/A",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                profile?.agencyMember.legalName ?? "",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
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
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: r.height * 0.03),

                  /// GRID CONTENT
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: r.width * 0.04,
                      mainAxisSpacing: r.width * 0.04,
                      // ADD BOTTOM PADDING so content isn't behind the Nav Bar
                      padding: const EdgeInsets.only(bottom: 110),
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

  // ... (Keep your _buildFullPageShimmer and _buildErrorBanner here)

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
                children: List.generate(
                  4,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
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
          Text(
            "Error: $message",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          TextButton(onPressed: () => _loadData(), child: const Text("Retry")),
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

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Container(
      padding: EdgeInsets.all(r.width * 0.04),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
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
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "KAIA Event Calendar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          SizedBox(height: r.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_left, size: 18),
              Text(
                "Oct 2024",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              Icon(Icons.chevron_right, size: 18),
            ],
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 28,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) => Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
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
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 5),
          Text(
            "KAIA Membership",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Payment due",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          Text(
            "-3000/- District",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
          ),
          Text(
            "-500/- State",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
