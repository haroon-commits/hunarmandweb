import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/colors.dart';

class ValuesSection extends StatelessWidget {
  const ValuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 150,
        vertical: isMobile ? 80 : 140,
      ),
      child: isMobile
          ? Column(
              children: [
                _buildValueCard(
                  Icons.ads_click,
                  'Our Mission',
                  'To bridge the skills gap in Kashmir by delivering world-class digital training...',
                  context,
                ),
                const SizedBox(height: 40),
                _buildValueCard(
                  Icons.favorite_border,
                  'Our Vision',
                  'A self-reliant Kashmir where every young person has the skills to compete globally...',
                  context,
                ),
                const SizedBox(height: 40),
                _buildValueCard(
                  Icons.people_outline,
                  'Community',
                  'We are more than an Institute; we are a family. We support each other...',
                  context,
                ),
              ],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildValueCard(
                      Icons.ads_click,
                      'Our Mission',
                      'To bridge the skills gap in Kashmir by delivering world-class digital training...',
                      context,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: _buildValueCard(
                      Icons.favorite_border,
                      'Our Vision',
                      'A self-reliant Kashmir where every young person has the skills to compete globally...',
                      context,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: _buildValueCard(
                      Icons.people_outline,
                      'Community',
                      'We are more than an Institute; we are a family. We support each other...',
                      context,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildValueCard(
    IconData icon,
    String title,
    String desc,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(top: BorderSide(color: kDarkGreen, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kAccentOrange, size: 36),
          const SizedBox(height: 25),
          Text(
            title,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            desc,
            style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
