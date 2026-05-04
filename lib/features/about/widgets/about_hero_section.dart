import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class AboutHeroSection extends StatelessWidget {
  final Function(int) onNavigate;
  const AboutHeroSection({super.key, required this.onNavigate});

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
          Text(
            'Our Story',
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              color: Colors.white,
              fontSize: isMobile ? 48 : 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Building a legacy of skill, self-reliance, and pride in the heart of Kashmir.',
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
