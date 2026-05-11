import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/models/bank_details.dart';
import '../../../../core/services/app_data_service.dart';

class ManageBankTab extends StatefulWidget {
  const ManageBankTab({super.key});

  @override
  State<ManageBankTab> createState() => _ManageBankTabState();
}

class _ManageBankTabState extends State<ManageBankTab> {
  final _service = AppDataService();
  final _nameController = TextEditingController();
  final _noController = TextEditingController();
  final _bankController = TextEditingController();
  final _branchController = TextEditingController();
  bool _loaded = false;

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
    return StreamBuilder<BankDetails?>(
      stream: _service.bankStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && !_loaded) {
          final b = snapshot.data!;
          _nameController.text = b.accountName;
          _noController.text = b.accountNo;
          _bankController.text = b.bankName;
          _branchController.text = b.branchCode;
          _loaded = true;
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bank Transfer Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Displayed on the Donate page.',
                  style: TextStyle(color: Colors.grey)),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: LinearProgressIndicator()),
              const SizedBox(height: 30),
              TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Account Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 20),
              TextField(
                  controller: _noController,
                  decoration: const InputDecoration(
                      labelText: 'Account Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers))),
              const SizedBox(height: 20),
              TextField(
                  controller: _bankController,
                  decoration: const InputDecoration(
                      labelText: 'Bank Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance_outlined))),
              const SizedBox(height: 20),
              TextField(
                  controller: _branchController,
                  decoration: const InputDecoration(
                      labelText: 'Branch Code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.code))),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _service.saveBank(BankDetails(
                      accountName: _nameController.text,
                      accountNo: _noController.text,
                      bankName: _bankController.text,
                      branchCode: _branchController.text,
                    ));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('✅ Bank details saved!'),
                          backgroundColor: Colors.green));
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('❌ Error: $e'),
                          backgroundColor: Colors.red));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('Save Bank Details',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}
