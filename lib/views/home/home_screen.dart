import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(r.width * 0.04),
          child: Column(
            children: [
              /// -------- TOP BANNER --------
              Container(
                height: r.height * 0.15,
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
                    /// Profile Image
                    CircleAvatar(
                      radius: r.width * 0.08,
                      backgroundImage: const AssetImage(
                        "assets/images/profile.png",
                      ),
                    ),

                    SizedBox(width: r.width * 0.04),

                    /// Name & ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Mr. Johnson Mathew",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "KAIA ID: 123456",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    /// KAIA Logo
                    Image.asset(
                      "assets/images/kaia_logo.png",
                      height: r.height * 0.06,
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

                    /// 👇 Calendar Card
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
        ),
      ),
    );
  }
}

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
            style: TextStyle(
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
          /// Title
          const Text(
            "KAIA Event Calendar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 14,
            ),
          ),

          SizedBox(height: r.height * 0.01),

          /// Month Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_left, size: 18),
              Text(
                "October 2024",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Icon(Icons.chevron_right, size: 18),
            ],
          ),

          SizedBox(height: r.height * 0.01),

          /// Calendar Grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 31,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                final day = index + 1;
                final isEventDay = day == 7 || day == 18;

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isEventDay ? Colors.red : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 12,
                      color: isEventDay ? Colors.white : Colors.black,
                      fontWeight: isEventDay
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
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
        children: [
          /// Title
          SizedBox(height: r.height * 0.01),
          const Text(
            "KAIA Membership",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 14,
            ),
          ),

          SizedBox(height: r.height * 0.01),

          Text(
            "Payment due",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Text(
            "-3000/- to District for event hosting",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Text(
            "-500/- to State for comman event",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          

          /// Calendar Grid
        ],
      ),
    );
  }
}
