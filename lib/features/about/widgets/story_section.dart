import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/colors.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From Kashmir to Global Opportunities',
          style: GoogleFonts.merriweather(
            color: kDarkGreen,
            fontSize: isMobile ? 36 : 48,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          'Hunarmand Kashmir was born from a simple yet powerful truth: talent is everywhere, but opportunity is not. For far too long, the brilliant minds of Kashmir have faced challenges—geographical isolation, limited infrastructure, and limited exposure to global industries.',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: isMobile ? 16 : 20,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'We chose to change that.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'We believe digital skills are the great equalizer. With the right training, mentorship, and access, a student from even the most remote areas of Kashmir can work with companies and clients across the world.',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: isMobile ? 16 : 20,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: kAccentOrange, width: 4)),
          ),
          child: Text(
            '"At Hunarmand Kashmir, we don’t just teach skills—we open doors, restore confidence, and help build futures rooted in dignity, independence, and global opportunity."',
            style: GoogleFonts.inter(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
              fontSize: isMobile ? 16 : 20,
              height: 1.6,
            ),
          ),
        ),
      ],
    );

    final image = Column(
      children: [
        const SizedBox(height: 40),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&q=80',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile ? content : Expanded(flex: 6, child: content),
          if (!isMobile) const SizedBox(width: 80),
          if (isMobile) const SizedBox(height: 40),
          isMobile ? image : Expanded(flex: 4, child: image),
        ],
      ),
    );
  }
}
