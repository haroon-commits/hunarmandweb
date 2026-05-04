import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class DonateHeroSection extends StatelessWidget {
  final Function(int) onNavigate;
  const DonateHeroSection({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      color: kDarkGreen,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 40,
      ),
      child: Column(
        children: [
          SizedBox(height: isMobile ? 20 : 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, color: kAccentOrange, size: 16),
                SizedBox(width: 8),
                Text(
                  'Support the Mission',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.merriweather(
                color: Colors.white,
                fontSize: isMobile ? 36 : 64,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              children: [
                const TextSpan(text: 'Invest in Dignity,\n'),
                TextSpan(
                  text: 'Not Dependency.',
                  style: const TextStyle(color: kAccentOrange),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Your contribution doesn\'t just pay a fee, it unlocks a future. Help us empower the youth of Kashmir with the skills they need to stand tall, earn a livelihood, and build a self-reliant community.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isMobile ? 18 : 22,
              height: 1.5,
            ),
          ),
          SizedBox(height: isMobile ? 60 : 100),
        ],
      ),
    );
  }
}
