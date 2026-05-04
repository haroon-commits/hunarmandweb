import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/course.dart';
import '../../../shared/widgets/blinking_badge.dart';

class ProgramsSection extends StatelessWidget {
  final List<Course> courses;
  final Function(int) onNavigate;
  final bool showHeader;
  const ProgramsSection({
    super.key,
    required this.courses,
    required this.onNavigate,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final visibleCourses = courses.where((c) => c.isVisible).toList();
    visibleCourses.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
    return Container(
      width: double.infinity,
      color: kLightBg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showHeader) ...[
            Text(
              'OUR PROGRAMS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kAccentOrange,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            isMobile
                ? Column(
                    children: [
                      Text(
                        'Skills for the Future',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.merriweather(
                          color: kDarkGreen,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => onNavigate(2),
                        child: const Text(
                          'View all courses →',
                          style: TextStyle(
                            color: kDarkGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Skills for the Future',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.merriweather(
                            color: kDarkGreen,
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => onNavigate(2),
                          child: const Text(
                            'View all courses →',
                            style: TextStyle(
                              color: kDarkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 40),
          ],
          isMobile
              ? Column(
                  children: visibleCourses
                      .map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: _buildCourseCard(course, context),
                        ),
                      )
                      .toList(),
                )
              : Column(
                  children: [
                    for (int i = 0; i < visibleCourses.length; i += 3) ...[
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildCourseCard(
                                visibleCourses[i],
                                context,
                              ),
                            ),
                            const SizedBox(width: 30),
                            if (i + 1 < visibleCourses.length)
                              Expanded(
                                child: _buildCourseCard(
                                  visibleCourses[i + 1],
                                  context,
                                ),
                              )
                            else
                              const Expanded(child: SizedBox()),
                            const SizedBox(width: 30),
                            if (i + 2 < visibleCourses.length)
                              Expanded(
                                child: _buildCourseCard(
                                  visibleCourses[i + 2],
                                  context,
                                ),
                              )
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
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
                child: Icon(course.icon, color: kDarkGreen, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: course.courseType == 'Online'
                            ? Colors.blue.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.courseType,
                        style: TextStyle(
                          color: course.courseType == 'Online'
                              ? Colors.blue
                              : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (course.remainingSeats.isNotEmpty)
                      BlinkingBadge(text: course.remainingSeats),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            course.title,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                course.courseType == 'Online'
                    ? Icons.videocam_outlined
                    : Icons.location_on_outlined,
                size: 14,
                color: Colors.black38,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  course.locationDetail,
                  style: const TextStyle(color: Colors.black38, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...course.subtitles.map(
            (sub) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sub,
                      style: GoogleFonts.inter(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!Responsive.isMobile(context)) const Spacer(),
          const SizedBox(height: 20),
          if (course.registrationLink.isNotEmpty)
            SizedBox(
              width: double.infinity,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Register Now'),
              ),
            ),
        ],
      ),
    );
  }
}
