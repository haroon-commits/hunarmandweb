import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/colors.dart';

class JourneySection extends StatelessWidget {
  final Function(int) onNavigate;
  const JourneySection({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 120,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Column(
        children: [
          Text(
            'Your Journey Begins Here',
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              color: kDarkGreen,
              fontSize: isMobile ? 36 : 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Don't let lack of opportunity hold you back. Join Hunarmand Kashmir today and unlock a\nfuture of dignity, independence, and success.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: isMobile ? 16 : 20,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => onNavigate(2),
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 40 : 50,
                vertical: 25,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Text(
              'Apply Now',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 18 : 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
