import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/models/bank_details.dart';

class ManageBankTab extends StatefulWidget {
  final BankDetails bankDetails;
  final VoidCallback onUpdate;

  const ManageBankTab({
    super.key,
    required this.bankDetails,
    required this.onUpdate,
  });

  @override
  State<ManageBankTab> createState() => _ManageBankTabState();
}

class _ManageBankTabState extends State<ManageBankTab> {
  late TextEditingController _nameController;
  late TextEditingController _noController;
  late TextEditingController _bankController;
  late TextEditingController _branchController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.bankDetails.accountName,
    );
    _noController = TextEditingController(text: widget.bankDetails.accountNo);
    _bankController = TextEditingController(text: widget.bankDetails.bankName);
    _branchController = TextEditingController(
      text: widget.bankDetails.branchCode,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noController.dispose();
    _bankController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bank Transfer Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'This information is displayed in the "Direct Bank Transfer" section of the Donate page.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Account Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _noController,
            decoration: const InputDecoration(
              labelText: 'Account Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _bankController,
            decoration: const InputDecoration(
              labelText: 'Bank Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance_outlined),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _branchController,
            decoration: const InputDecoration(
              labelText: 'Branch Code',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.code),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              try {
                setState(() {
                  widget.bankDetails.accountName = _nameController.text;
                  widget.bankDetails.accountNo = _noController.text;
                  widget.bankDetails.bankName = _bankController.text;
                  widget.bankDetails.branchCode = _branchController.text;
                });
                widget.onUpdate();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bank details updated successfully!'),
                  ),
                );
              } catch (e, stack) {
                debugPrint('AdminPanel Error (Update Bank): $e');
                debugPrint(stack.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating bank details: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Update Bank Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
