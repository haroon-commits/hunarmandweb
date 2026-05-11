import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/models/donation_option.dart';
import '../../../../core/services/app_data_service.dart';

class ManageDonationsTab extends StatefulWidget {
  const ManageDonationsTab({super.key});

  @override
  State<ManageDonationsTab> createState() => _ManageDonationsTabState();
}

class _ManageDonationsTabState extends State<ManageDonationsTab> {
  final _service = AppDataService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DonationOption>>(
      stream: _service.donationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final options = snapshot.data ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Donation Options',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: _showAddDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Option'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentOrange,
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: options.isEmpty
                  ? const Center(
                      child: Text('No donation options yet.',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final opt = options[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(opt.icon, color: kAccentOrange),
                            title: Text(opt.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(opt.price),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (opt.isPopular)
                                  const Chip(
                                    label: Text('Popular',
                                        style: TextStyle(fontSize: 10)),
                                    backgroundColor:
                                        Color.fromRGBO(255, 215, 64, 1),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () => _showEditDialog(opt),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    await _service.deleteDonation(opt.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() => _showDialog(null);
  void _showEditDialog(DonationOption opt) => _showDialog(opt);

  void _showDialog(DonationOption? existing) {
    final isEdit = existing != null;
    final titleController =
        TextEditingController(text: existing?.title ?? '');
    final priceController =
        TextEditingController(text: existing?.price ?? '');
    final descController =
        TextEditingController(text: existing?.description ?? '');
    bool tempPopular = existing?.isPopular ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Donation Option' : 'Add Donation Option'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title')),
                TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                        labelText: 'Price (e.g. Rs. 2,000)')),
                TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(labelText: 'Description')),
                SwitchListTile(
                  title: const Text('Most Popular?'),
                  value: tempPopular,
                  onChanged: (v) =>
                      setDialogState(() => tempPopular = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkGreen,
                  foregroundColor: Colors.white),
              onPressed: () async {
                final opt = DonationOption(
                  id: existing?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  price: priceController.text,
                  description: descController.text,
                  icon: existing?.icon ?? Icons.card_giftcard,
                  isPopular: tempPopular,
                );
                try {
                  await _service.saveDonation(opt);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isEdit
                          ? '✅ Option updated!'
                          : '✅ Option added!'),
                      backgroundColor: Colors.green,
                    ));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('❌ Error: $e'),
                        backgroundColor: Colors.red));
                  }
                }
              },
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
