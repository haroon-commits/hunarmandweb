import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class HeroSection extends StatelessWidget {
  final Function(int) onNavigate;
  final int activeIndex;
  const HeroSection({
    super.key,
    required this.onNavigate,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      color: kDarkGreen,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 40 : 60,
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo_colored.png',
            height: isMobile ? 80 : 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            'Rooted in Kashmir. Ready for the World.',
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              color: Colors.white,
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Empowering the youth of the Valley with cutting-edge digital skills.\nTurning talent into livelihood, and dreams into reality.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isMobile ? 14 : 18,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                'Explore Our Courses →',
                kAccentOrange,
                Colors.white,
                () => onNavigate(2),
              ),
              SizedBox(width: isMobile ? 0 : 20, height: isMobile ? 15 : 0),
              _buildOutlineButton(
                'Our Mission',
                Colors.white,
                () => onNavigate(1),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildOutlineButton(String text, Color color, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
