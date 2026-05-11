import 'package:flutter/material.dart';
import '../../../core/models/course.dart';
import '../../../core/services/app_data_service.dart';
import '../../../shared/widgets/footer_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/why_section.dart';
import '../widgets/programs_section.dart';
import '../widgets/journey_section.dart';

class LandingPage extends StatefulWidget {
  final Function(int) onNavigate;
  final ScrollController? scrollController;

  const LandingPage({
    super.key,
    required this.onNavigate,
    this.scrollController,
    // Kept for backward compat — page now fetches from Firestore directly.
    List<dynamic>? courses,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _service = AppDataService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Course>>(
      stream: _service.coursesStream(),
      builder: (context, snapshot) {
        final courses = snapshot.data ?? [];
        return SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            children: [
              HeroSection(onNavigate: widget.onNavigate, activeIndex: 0),
              const WhySection(),
              ProgramsSection(courses: courses, onNavigate: widget.onNavigate),
              JourneySection(onNavigate: widget.onNavigate),
              FooterSection(onNavigate: widget.onNavigate, activeIndex: 0),
            ],
          ),
        );
      },
    );
  }
}
