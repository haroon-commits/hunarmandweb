import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/colors.dart';

class FooterSection extends StatelessWidget {
  final Function(int) onNavigate;
  final int activeIndex;
  const FooterSection({
    super.key,
    required this.onNavigate,
    this.activeIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      color: kDarkGreen,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 100,
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 60,
                runSpacing: 40,
                alignment: isMobile
                    ? WrapAlignment.center
                    : WrapAlignment.start,
                children: [
                  // Column 1: Brand & About
                  SizedBox(
                    width: isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth * 0.45,
                    child: Column(
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/Hunarmand_Kashmir_Eng4x.png',
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.school,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Empowering the youth of Kashmir through digital skills, fostering self-reliance, and building a future where talent meets opportunity right here in the valley.',
                          textAlign: isMobile
                              ? TextAlign.center
                              : TextAlign.start,
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (!isMobile)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Follow Us:',
                                style: GoogleFonts.inter(
                                  color: Colors.amber,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _socialLink(
                                    'Facebook',
                                    'https://facebook.com/hunarmandkashmir',
                                  ),
                                  const SizedBox(width: 20),
                                  _socialLink(
                                    'Instagram',
                                    'https://instagram.com/hunarmandkashmir',
                                  ),
                                  const SizedBox(width: 20),
                                  _socialLink(
                                    'TikTok',
                                    'https://tiktok.com/@hunarmandkashmir',
                                  ),
                                  const SizedBox(width: 20),
                                  _socialLink(
                                    'YouTube',
                                    'https://youtube.com/@hunarmandkashmir',
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Column 2: Links and Contact
                  SizedBox(
                    width: isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth * 0.45,
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: isMobile
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        // Sub-column: Quick Links
                        SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: isMobile
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'QUICK LINKS',
                                style: TextStyle(
                                  color: kAccentOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 25),
                              _footerLink(
                                'Our Story',
                                index: 1,
                                onTap: () => onNavigate(1),
                              ),
                              _footerLink(
                                'All Courses',
                                index: 2,
                                onTap: () => onNavigate(2),
                              ),
                              _footerLink(
                                'Gallery',
                                index: 3,
                                onTap: () => onNavigate(3),
                              ),
                              _footerLink(
                                'Contact Us',
                                index: 4,
                                onTap: () => onNavigate(4),
                              ),
                              _footerLink(
                                'Donate Now',
                                isSpecial: true,
                                index: 5,
                                onTap: () => onNavigate(5),
                              ),
                            ],
                          ),
                        ),

                        // Sub-column: Contact Info
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: isMobile
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'GET IN TOUCH',
                                style: TextStyle(
                                  color: kAccentOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 25),
                              _contactItem(
                                Icons.location_on_outlined,
                                'A.M. Design, Nangi (Behind Bank of Punjab), Allama Iqbal Road, Mirpur, AJK, Pakistanr',
                              ),
                              _contactItem(
                                Icons.phone_outlined,
                                kPhoneDisplay,
                              ),
                              _contactItem(
                                Icons.email_outlined,
                                'salam@hunarmandkashmir.com',
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 60),
          const Divider(color: Colors.white12, thickness: 1),
          const SizedBox(height: 30),
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  const Text(
                    '© 2026 Hunarmand Kashmir. All rights reserved.',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => onNavigate(6),
                    child: const Text(
                      'Admin Dashboard',
                      style: TextStyle(color: Colors.white10, fontSize: 11),
                    ),
                  ),
                ],
              ),
              if (isMobile) ...[
                const SizedBox(height: 30),
                Column(
                  children: [
                    Text(
                      'Follow Us',
                      style: GoogleFonts.inter(
                        color: Colors.amber,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialLink(
                          'Facebook',
                          'https://facebook.com/hunarmandkashmir',
                        ),
                        const SizedBox(width: 15),
                        _socialLink(
                          'Instagram',
                          'https://instagram.com/hunarmandkashmir',
                        ),
                        const SizedBox(width: 15),
                        _socialLink(
                          'TikTok',
                          'https://tiktok.com/@hunarmandkashmir',
                        ),
                        const SizedBox(width: 15),
                        _socialLink(
                          'YouTube',
                          'https://youtube.com/@hunarmandkashmir',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(
    String text, {
    bool isSpecial = false,
    VoidCallback? onTap,
    int? index,
  }) {
    bool active = index != null && activeIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: active
                ? kAccentOrange
                : (isSpecial ? kAccentOrange : Colors.white70),
            fontSize: 14,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _contactItem(IconData icon, String text, {int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kAccentOrange, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialLink(String label, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
