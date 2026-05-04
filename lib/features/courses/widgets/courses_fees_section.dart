import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/course.dart';
import '../../../shared/widgets/blinking_badge.dart';

class CoursesFeesSection extends StatelessWidget {
  final List<Course> courses;
  const CoursesFeesSection({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final visibleCourses = courses.where((c) => c.isVisible).toList();
    visibleCourses.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
    return Container(
      color: kLightBg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Column(
        children: [
          Text(
            'Courses & Fees',
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              color: kDarkGreen,
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: visibleCourses
                      .map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: _buildCourseDetailCard(course, context),
                        ),
                      )
                      .toList(),
                )
              : Column(
                  children: [
                    for (int i = 0; i < visibleCourses.length; i += 2) ...[
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildCourseDetailCard(
                                visibleCourses[i],
                                context,
                              ),
                            ),
                            const SizedBox(width: 40),
                            if (i + 1 < visibleCourses.length)
                              Expanded(
                                child: _buildCourseDetailCard(
                                  visibleCourses[i + 1],
                                  context,
                                ),
                              )
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildCourseDetailCard(Course course, BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: isMobile ? StackFit.loose : StackFit.expand,
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Text(
              course.orderNumber,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.05),
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kDarkGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(course.icon, color: kDarkGreen, size: 28),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      course.title,
                      style: GoogleFonts.merriweather(
                        color: kDarkGreen,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _badge(course.courseType),
                  if (course.locationDetail.isNotEmpty)
                    _badge(course.locationDetail),
                  if (course.remainingSeats.isNotEmpty)
                    BlinkingBadge(text: course.remainingSeats),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                course.description,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              if (course.subtitles.isNotEmpty) ...[
                const SizedBox(height: 20),
                ...course.subtitles.map(
                  (sub) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            sub,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                'Duration: ${course.duration}',
                style: const TextStyle(
                  color: kAccentOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!Responsive.isMobile(context)) const Spacer(),
              const SizedBox(height: 30),
              _priceRow(
                course.schedule,
                course.price,
                const Color(0xFFFFEBF0),
                const Color(0xFFE91E63),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final url = Uri.parse(course.queryLink);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kDarkGreen,
                        side: const BorderSide(color: kDarkGreen),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Query',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (course.registrationLink.isNotEmpty) ...[
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final url = Uri.parse(course.registrationLink);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.green,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _priceRow(
    String batch,
    String price,
    Color bgColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            fit: FlexFit.loose,
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: accentColor, size: 16),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    batch,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            price,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
