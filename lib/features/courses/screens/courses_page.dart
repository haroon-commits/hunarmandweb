import 'package:flutter/material.dart';
import '../../../core/models/course.dart';
import '../../../shared/widgets/footer_section.dart';
import '../widgets/courses_hero_section.dart';
import '../widgets/learning_choice_section.dart';
import '../widgets/courses_fees_section.dart';
import '../widgets/discounts_section.dart';
import '../widgets/orphan_support_banner.dart';
import '../widgets/ready_to_start_section.dart';

class CoursesPage extends StatelessWidget {
  final Function(int) onNavigate;
  final List<Course> courses;
  final ScrollController? scrollController;
  const CoursesPage({
    super.key,
    required this.onNavigate,
    required this.courses,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          CoursesHeroSection(onNavigate: onNavigate),
          //   const LearningChoiceSection(),
          CoursesFeesSection(courses: courses),
          const DiscountsSection(),
          const OrphanSupportBanner(),
          ReadyToStartSection(onNavigate: onNavigate),
          FooterSection(onNavigate: onNavigate, activeIndex: 2),
        ],
      ),
    );
  }
}
