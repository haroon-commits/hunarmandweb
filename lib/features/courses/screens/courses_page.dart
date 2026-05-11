import 'package:flutter/material.dart';
import '../../../core/models/course.dart';
import '../../../core/services/app_data_service.dart';
import '../../../shared/widgets/footer_section.dart';
import '../widgets/courses_hero_section.dart';
import '../widgets/courses_fees_section.dart';
import '../widgets/discounts_section.dart';
import '../widgets/orphan_support_banner.dart';
import '../widgets/ready_to_start_section.dart';

class CoursesPage extends StatefulWidget {
  final Function(int) onNavigate;
  final ScrollController? scrollController;

  const CoursesPage({
    super.key,
    required this.onNavigate,
    this.scrollController,
    // Keep courses param for backward compatibility but ignore it —
    // page fetches live data directly from Firestore.
    List<dynamic>? courses,
  });

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
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
              CoursesHeroSection(onNavigate: widget.onNavigate),
              if (snapshot.connectionState == ConnectionState.waiting &&
                  courses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                )
              else
                CoursesFeesSection(courses: courses),
              const DiscountsSection(),
              const OrphanSupportBanner(),
              ReadyToStartSection(onNavigate: widget.onNavigate),
              FooterSection(onNavigate: widget.onNavigate, activeIndex: 2),
            ],
          ),
        );
      },
    );
  }
}
