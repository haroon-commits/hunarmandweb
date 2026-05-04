import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/colors.dart';

class WhySection extends StatelessWidget {
  const WhySection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            'Why Hunarmand Kashmir?',
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              color: kDarkGreen,
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(width: 60, height: 3, color: kAccentOrange),
          const SizedBox(height: 30),
          Text(
            'We believe in "Skills over Degrees". In a rapidly changing world, we provide the\npractical, hands-on training that the industry demands, right here in Mirpur.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: isMobile ? 16 : 20,
              height: 1.5,
            ),
          ),
          SizedBox(height: isMobile ? 40 : 60),
          isMobile
              ? Column(
                  children: [
                    _buildFeatureCard(
                      Icons.code,
                      'Expert Mentorship',
                      'Learn from industry professionals\nwho have worked globally.',
                      context,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureCard(
                      Icons.memory,
                      'Practical Learning',
                      'No boring theory. Work on real\nprojects that build your portfolio.',
                      context,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureCard(
                      Icons.trending_up,
                      'Career Support',
                      'From resume building to freelance\ngigs, we guide your career path.',
                      context,
                    ),
                  ],
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          Icons.code,
                          'Expert Mentorship',
                          'Learn from industry professionals\nwho have worked globally.',
                          context,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildFeatureCard(
                          Icons.memory,
                          'Practical Learning',
                          'No boring theory. Work on real\nprojects that build your portfolio.',
                          context,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildFeatureCard(
                          Icons.trending_up,
                          'Career Support',
                          'From resume building to freelance\ngigs, we guide your career path.',
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
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
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: kDarkGreen.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: kDarkGreen, size: 30),
          ),
          const SizedBox(height: 25),
          Text(
            title,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 15),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
