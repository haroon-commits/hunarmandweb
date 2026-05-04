import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class ContactContentSection extends StatelessWidget {
  const ContactContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    Widget leftCard = Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 30 : 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Visit Our Campus',
            style: GoogleFonts.merriweather(
              color: kDarkGreen,
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Our doors are always open for students and parents. Come see our state-of-the-art labs, meet our mentors, and feel the energy of innovation.',
            style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: isMobile ? 16 : 20,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          _contactInfo(
            Icons.location_on,
            'Address',
            'A.M. Design, Nangi (Behind Bank of Punjab), Allama Iqbal Road, Mirpur, AJK, Pakistan',
            const Color(0xFFE8F5E9),
            const Color(0xFF43A047),
          ),
          const SizedBox(height: 20),
          _contactInfo(
            Icons.phone,
            'Phone',
            kPhoneDisplay,
            const Color(0xFFE0F2F1),
            const Color(0xFF009688),
          ),
          const SizedBox(height: 20),
          _contactInfo(
            Icons.chat_bubble_outline,
            'WhatsApp',
            kPhoneDisplay,
            const Color(0xFFE1F5FE),
            const Color(0xFF03A9F4),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );

    Widget rightCard = Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 30 : 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: isMobile ? 60 : 80,
            color: kAccentOrange,
          ),
          const SizedBox(height: 30),
          Text(
            'Quick Response on WhatsApp',
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              color: kDarkGreen,
              fontSize: isMobile ? 28 : 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'The fastest way to get in touch with us is via WhatsApp. Our team is online and ready to answer your questions about courses, admissions, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: isMobile ? 16 : 20,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(kWhatsAppUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, size: 24),
                  SizedBox(width: 15),
                  Text(
                    'Contact via WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Typical response time: < 30 mins',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 150,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [leftCard, const SizedBox(height: 40), rightCard],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: leftCard),
                  const SizedBox(width: 80),
                  Expanded(child: rightCard),
                ],
              ),
            ),
    );
  }

  Widget _contactInfo(
    IconData icon,
    String label,
    String text,
    Color bgColor,
    Color iconColor, {
    int? maxLines,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                text,
                maxLines: maxLines,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
