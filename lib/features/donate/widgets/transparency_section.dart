import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class TransparencySection extends StatelessWidget {
  const TransparencySection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 150,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTransparencyContent(isMobile),
                const SizedBox(height: 40),
                _buildTransparencyUtil(isMobile),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildTransparencyContent(isMobile)),
                const SizedBox(width: 80),
                Expanded(child: _buildTransparencyUtil(isMobile)),
              ],
            ),
    );
  }

  Widget _buildTransparencyContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Promise of Transparency',
          style: GoogleFonts.merriweather(
            color: kDarkGreen,
            fontSize: isMobile ? 32 : 44,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'We understand that trust is the foundation of any contribution. At Hunarmand Kashmir, every rupee is accounted for. We operate with a strict policy of ethical allocation.',
          style: GoogleFonts.inter(
            color: Colors.black54,
            fontSize: isMobile ? 16 : 20,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        _promiseItem(
          '100% of student scholarship funds go directly to training costs.',
        ),
        _promiseItem('Regular impact reports sent to all donors.'),
        _promiseItem(
          'Open-door policy: Visit our campus to see your impact in action.',
        ),
        _promiseItem(
          'Focus on long-term sustainability, not temporary relief.',
        ),
      ],
    );
  }

  Widget _buildTransparencyUtil(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'How Funds Are Utilized',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 40),
          _utilBar('Student Scholarships & Training', 0.7, Colors.green),
          const SizedBox(height: 25),
          _utilBar('Infrastructure & Tools', 0.2, Colors.orange),
          const SizedBox(height: 25),
          _utilBar('Community Outreach & Operations', 0.1, Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _promiseItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: kAccentOrange,
            size: 20,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _utilBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.black.withValues(alpha: 0.05),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
