import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/colors.dart';
import '../../../core/models/donation_option.dart';
import '../../../core/utils/responsive.dart';

class WaysToContributeSection extends StatelessWidget {
  final List<DonationOption> donationOptions;
  const WaysToContributeSection({super.key, required this.donationOptions});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      color: kLightBg,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Column(
        children: [
          Text(
            'Ways to Contribute',
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              color: kDarkGreen,
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Choose how you want to make a difference. Every amount counts towards\nbuilding a skilled Kashmir.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: donationOptions
                      .map(
                        (opt) => Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: _priceCard(
                            opt.title,
                            opt.price,
                            opt.description,
                            opt.icon,
                            opt.isPopular ? kAccentOrange : kDarkGreen,
                            context,
                            isPopular: opt.isPopular,
                          ),
                        ),
                      )
                      .toList(),
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: donationOptions
                        .expand(
                          (opt) => [
                            Expanded(
                              child: _priceCard(
                                opt.title,
                                opt.price,
                                opt.description,
                                opt.icon,
                                opt.isPopular ? kAccentOrange : kDarkGreen,
                                context,
                                isPopular: opt.isPopular,
                              ),
                            ),
                            if (opt != donationOptions.last)
                              const SizedBox(width: 30),
                          ],
                        )
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _priceCard(
    String title,
    String price,
    String desc,
    IconData icon,
    Color color,
    BuildContext context, {
    bool isPopular = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isPopular
                ? Border.all(color: color, width: 2)
                : Border.all(color: Colors.black.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 25),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                price,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -12,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
