import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/colors.dart';

class ReadyToStartSection extends StatelessWidget {
  final Function(int) onNavigate;
  const ReadyToStartSection({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 280,
        vertical: 40,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 60 : 100,
          horizontal: isMobile ? 24 : 40,
        ),
        decoration: BoxDecoration(
          color: kDarkGreen,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Ready to Start?',
              textAlign: TextAlign.center,
              style: GoogleFonts.merriweather(
                color: Colors.white,
                fontSize: isMobile ? 36 : 52,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Secure your spot in the upcoming batch.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: isMobile ? 16 : 22,
              ),
            ),
            const SizedBox(height: 48),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildButton(
                  'Apply Online',
                  Colors.white,
                  kDarkGreen,
                  () => onNavigate(2),
                  isMobile,
                ),
                _buildOutlineButton('Chat on WhatsApp', Colors.white, () async {
                  final uri = Uri.parse(kWhatsAppUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                }, isMobile),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 30 : 50,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildOutlineButton(
    String text,
    Color color,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: const BorderSide(color: Colors.white, width: 1.5),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 30 : 50,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
