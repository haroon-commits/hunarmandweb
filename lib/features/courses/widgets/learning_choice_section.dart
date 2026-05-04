// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../core/utils/responsive.dart';
// import '../../../core/constants/colors.dart';

// class LearningChoiceSection extends StatelessWidget {
//   const LearningChoiceSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     bool isMobile = Responsive.isMobile(context);
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: isMobile ? 40 : 80,
//         horizontal: isMobile ? 24 : 150,
//       ),
//       child: Column(
//         children: [
//           Text(
//             'Your Learning, Your Choice',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.merriweather(
//               color: kPrimaryGreen,
//               fontSize: isMobile ? 28 : 32,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Choose the location and schedule that fits your routine.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.black54),
//           ),
//           const SizedBox(height: 50),
//           Wrap(
//             spacing: 20,
//             runSpacing: 20,
//             alignment: WrapAlignment.center,
//             children: [
//               _buildChoiceCard(
//                 'Freelancing Hub (B.I.S.E)',
//                 'Khaliq Abad Barrier Blvd, Gov Degree College, Mirpur',
//                 const Color(0xFFFFEBF0),
//                 const Color(0xFFE91E63),
//                 Icons.location_on,
//                 context,
//               ),
//               _buildChoiceCard(
//                 'Software Technology Park',
//                 'SCO Software Technology Park, Kotli Road, Mirpur',
//                 const Color(0xFFFFF4E5),
//                 const Color(0xFFFF9800),
//                 Icons.apartment,
//                 context,
//               ),
//               _buildChoiceCard(
//                 'Online Classes (Live Sessions)',
//                 'Mastering from the live Zoom / Google Meet',
//                 const Color(0xFFE3F2FD),
//                 const Color(0xFF2196F3),
//                 Icons.videocam,
//                 context,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChoiceCard(
//     String title,
//     String location,
//     Color bgColor,
//     Color accentColor,
//     IconData icon,
//     BuildContext context,
//   ) {
//     bool isMobile = Responsive.isMobile(context);
//     return Container(
//       width: isMobile ? double.infinity : 320,
//       padding: const EdgeInsets.all(30),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: accentColor.withValues(alpha: 0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.02),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: accentColor, size: 24),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Text(
//             location,
//             style: const TextStyle(
//               color: Colors.black54,
//               fontSize: 12,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 20),
//           _bulletItem(
//             Icons.calendar_today,
//             '4 Days a Week (Mon-Thu)',
//             bgColor,
//             accentColor,
//           ),
//           _bulletItem(Icons.person, 'Our for everyone', bgColor, accentColor),
//           _bulletItem(Icons.verified, 'Course Basics', bgColor, accentColor),
//         ],
//       ),
//     );
//   }

//   Widget _bulletItem(
//     IconData icon,
//     String text,
//     Color bgColor,
//     Color accentColor,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: bgColor.withValues(alpha: 0.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: accentColor, size: 14),
//             const SizedBox(width: 10),
//             Text(
//               text,
//               style: TextStyle(
//                 color: accentColor,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
