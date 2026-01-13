import 'dart:math';
import 'package:flutter/material.dart';


class SpinningWheelScreen extends StatefulWidget {
  const SpinningWheelScreen({super.key});

  @override
  State<SpinningWheelScreen> createState() => _SpinningWheelScreenState();
}

class _SpinningWheelScreenState extends State<SpinningWheelScreen>
    with TickerProviderStateMixin {
  late AnimationController _wheelController;
  late AnimationController _celebrateController;
  late Animation<double> _wheelAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  double _currentAngle = 0;
  int? _selectedIndex;

  final List<String> items = [
    'Akhil', 'Anu', 'Arjun', 'Divya', 'Hari',
    'Keerthana', 'Kiran', 'Manu', 'Megha', 'Neha',
    'Nikhil', 'Rahul', 'Riya', 'Sanjay', 'Sneha',
    'Sreya', 'Vishnu', 'Asha', 'Ramesh', 'Anjali',
  ];

  static const Color darkRed = Color(0xFF5A0E18);
  static const Color brightRed = Color(0xFFB11226);

  @override
  void initState() {
    super.initState();

    _wheelController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _celebrateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Increased for better falling effect
    );

    _wheelAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _wheelController,
        curve: Curves.easeOutQuart,
      ),
    )..addListener(
        () => setState(() => _currentAngle = _wheelAnimation.value),
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _calculateSelectedIndex();
          _celebrateController.forward(from: 0);
        }
      });

    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _celebrateController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _celebrateController, curve: Curves.easeIn),
    );
  }

  void spinWheel() {
    final random = Random();
    final spinAngle = random.nextDouble() * pi * 12;

    _wheelAnimation = Tween<double>(
      begin: _currentAngle,
      end: _currentAngle + spinAngle,
    ).animate(
      CurvedAnimation(parent: _wheelController, curve: Curves.easeOutQuart),
    );

    _selectedIndex = null;
    _celebrateController.reset();
    _wheelController.forward(from: 0);
  }

  void _calculateSelectedIndex() {
    final sliceAngle = 2 * pi / items.length;
    double angleUnderArrow = (3 * pi / 2 - _currentAngle) % (2 * pi);
    if (angleUnderArrow < 0) angleUnderArrow += 2 * pi;

    setState(() {
      _selectedIndex = (angleUnderArrow / sliceAngle).floor();
    });
  }

  @override
  void dispose() {
    _wheelController.dispose();
    _celebrateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height * 0.80,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Stack(
              children: [
                /// 🎊 FALLING CONFETTI
                if (_selectedIndex != null)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _celebrateController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: ConfettiPainter(
                            progress: _celebrateController.value,
                          ),
                        );
                      },
                    ),
                  ),

                Column(
                  children: [
                    const SizedBox(height: 40),
                    /// 🔥 HEADER
                    Column(
                      children: const [
                        Text(
                          "Chitty Lucky Draw",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkRed,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Tap SPIN to select today's lucky member",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),

                    /// 🔴 FLOATING SPIN BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: spinWheel,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [brightRed, darkRed],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.5),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.casino, color: Colors.white, size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    "SPIN",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          /// 🎉 RESULT TEXT
                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _selectedIndex == null
                                  ? const Text(
                                      "Ready to spin?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        const Text(
                                          "🎉 Congratulations ",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          items[_selectedIndex!],
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🎯 WHEEL
                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: _currentAngle,
                              child: CustomPaint(
                                size: Size(size.width * 0.9, size.width * 0.9),
                                painter: WheelPainter(
                                  items: items,
                                  selectedIndex: _selectedIndex,
                                ),
                              ),
                            ),
                             Positioned(
                              top: -12,
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;
  ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(42); // Fixed seed prevents flickering during fall

    for (int i = 0; i < 100; i++) {
      final color = Colors.primaries[random.nextInt(Colors.primaries.length)];
      final double xPos = random.nextDouble() * size.width;
      
      // Calculate Y position: Starts above screen (-50) and falls to bottom
      // We add a random offset so they don't all fall in a straight line
      final double startOffset = random.nextDouble() * size.height;
      final double yPos = ((progress * size.height * 1.5) + startOffset - size.height) % (size.height + 50);

      final paint = Paint()
        ..color = color.withOpacity(1.0 - progress.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      // Draw different shapes for variety
      if (i % 2 == 0) {
        canvas.drawCircle(Offset(xPos, yPos), random.nextDouble() * 4 + 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset(xPos, yPos), width: 6, height: 6),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}

class WheelPainter extends CustomPainter {
  final List<String> items;
  final int? selectedIndex;

  WheelPainter({required this.items, this.selectedIndex});

  static const colors = [
    Color(0xFF5A0E18),
    Color(0xFFB11226),
    Color(0xFF7A1A25),
    Color(0xFF9E2A2F),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final sliceAngle = 2 * pi / items.length;

    for (int i = 0; i < items.length; i++) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = i == selectedIndex ? Colors.green : colors[i % colors.length];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sliceAngle,
        sliceAngle,
        true,
        paint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: items[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: radius * 0.7);

      final angle = (i + 0.5) * sliceAngle;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      textPainter.paint(canvas, Offset(radius * 0.6, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}

