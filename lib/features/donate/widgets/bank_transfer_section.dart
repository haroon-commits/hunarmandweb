import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/colors.dart';
import '../../../core/models/bank_details.dart';
import '../../../core/utils/responsive.dart';

class BankTransferSection extends StatelessWidget {
  final BankDetails bankDetails;
  const BankTransferSection({super.key, required this.bankDetails});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 150,
      ),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 30 : 60),
        decoration: BoxDecoration(
          color: kDarkGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: isMobile
            ? Column(
                children: [
                  _buildBankInfo(isMobile, context),
                  const SizedBox(height: 40),
                  _buildBankCta(isMobile),
                ],
              )
            : Row(
                children: [
                  Expanded(flex: 3, child: _buildBankInfo(isMobile, context)),
                  const SizedBox(width: 40),
                  Expanded(flex: 2, child: _buildBankCta(isMobile)),
                ],
              ),
      ),
    );
  }

  Widget _buildBankInfo(bool isMobile, BuildContext context) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Direct Bank Transfer',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.merriweather(
            color: Colors.white,
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Prefer to transfer directly? You can send your contributions to our registered trust account. Please share the receipt via WhatsApp.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(color: Colors.white70, fontSize: isMobile ? 16 : 20),
        ),
        const SizedBox(height: 40),
        _bankRow('Account Name:', bankDetails.accountName, context),
        _bankRow('Account No:', bankDetails.accountNo, context),
        _bankRow('Bank:', bankDetails.bankName, context),
        _bankRow('Branch Code:', bankDetails.branchCode, context),
      ],
    );
  }

  Widget _buildBankCta(bool isMobile) {
    return Column(
      children: [
        Icon(
          Icons.favorite_border,
          color: Colors.white12,
          size: isMobile ? 60 : 100,
        ),
        const SizedBox(height: 20),
        const Text(
          '"Charity does not decrease wealth."',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontStyle: FontStyle.italic,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: isMobile ? double.infinity : null,
          child: ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse(kWhatsAppUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: kDarkGreen,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble_outline, size: 18),
                SizedBox(width: 10),
                Text(
                  'Contact Finance Team',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bankRow(String label, String value, BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: isMobile ? 100 : 120,
            child: Text(
              label,
              style: const TextStyle(
                color: kAccentOrange,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 13 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
