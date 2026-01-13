import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String iconPath;

  const FeatureCard({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(iconPath),
      ),
    );
  }
}
