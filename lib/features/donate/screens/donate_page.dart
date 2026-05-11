import 'package:flutter/material.dart';

import '../../../core/models/bank_details.dart';
import '../../../core/models/donation_option.dart';
import '../../../core/services/app_data_service.dart';
import '../../../shared/widgets/footer_section.dart';
import '../widgets/donate_hero_section.dart';
import '../widgets/pillars_section.dart';
import '../widgets/transparency_section.dart';
import '../widgets/ways_to_contribute_section.dart';
import '../widgets/bank_transfer_section.dart';

class DonatePage extends StatefulWidget {
  final Function(int) onNavigate;
  final ScrollController? scrollController;

  const DonatePage({
    super.key,
    required this.onNavigate,
    this.scrollController,
    // Kept for backward compat — page now fetches from Firestore directly.
    List<dynamic>? donationOptions,
    BankDetails? bankDetails,
  });

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _service = AppDataService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DonationOption>>(
      stream: _service.donationsStream(),
      builder: (context, donationSnap) {
        return StreamBuilder<BankDetails?>(
          stream: _service.bankStream(),
          builder: (context, bankSnap) {
            final donations = donationSnap.data ?? [];
            final bank = bankSnap.data ??
                BankDetails(
                  accountName: '',
                  accountNo: '',
                  bankName: '',
                  branchCode: '',
                );

            return SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                children: [
                  DonateHeroSection(onNavigate: widget.onNavigate),
                  const PillarsSection(),
                  const TransparencySection(),
                  WaysToContributeSection(donationOptions: donations),
                  BankTransferSection(bankDetails: bank),
                  FooterSection(onNavigate: widget.onNavigate, activeIndex: 5),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
