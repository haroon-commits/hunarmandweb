import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/models/course.dart';

class ManageCoursesTab extends StatefulWidget {
  final List<Course> courses;
  final VoidCallback onUpdate;

  const ManageCoursesTab({
    super.key,
    required this.courses,
    required this.onUpdate,
  });

  @override
  State<ManageCoursesTab> createState() => _ManageCoursesTabState();
}

class _ManageCoursesTabState extends State<ManageCoursesTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Courses List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _addCourseDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.courses.length,
            itemBuilder: (context, index) {
              final course = widget.courses[index];
              return ListTile(
                leading: Icon(course.icon, color: kDarkGreen),
                title: Text(
                  course.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${course.courseType} • ${course.subtitles.isNotEmpty ? course.subtitles.first : 'No subtitles'}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        course.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() => course.isVisible = !course.isVisible);
                        widget.onUpdate();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editCourseDialog(course),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() => widget.courses.removeAt(index));
                        widget.onUpdate();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addCourseDialog() {
    final titleController = TextEditingController();
    final linkController = TextEditingController();
    final detailController = TextEditingController();
    final descController = TextEditingController();
    final durController = TextEditingController();
    final schController = TextEditingController();
    final priceController = TextEditingController();
    final orderController = TextEditingController();
    final remainingSeatsController = TextEditingController();
    final queryLinkController = TextEditingController();
    List<String> tempSubtitles = [''];
    String tempType = 'Physical';
    IconData tempIcon = Icons.school;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: orderController,
                        decoration: const InputDecoration(
                          labelText: 'Order # (e.g. 01)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Course Title',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: tempType,
                  decoration: const InputDecoration(labelText: 'Course Type'),
                  items: ['Physical', 'Online']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => tempType = v!),
                ),
                TextField(
                  controller: detailController,
                  decoration: InputDecoration(
                    labelText: tempType == 'Online'
                        ? 'Platform (e.g. Zoom)'
                        : 'Address / Location',
                  ),
                ),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Main Description',
                  ),
                ),
                TextField(
                  controller: durController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (e.g. 3 Months)',
                  ),
                ),
                TextField(
                  controller: schController,
                  decoration: const InputDecoration(
                    labelText: 'Schedule (e.g. Mon-Thu)',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (e.g. Rs. 12,000)',
                  ),
                ),
                TextField(
                  controller: remainingSeatsController,
                  decoration: const InputDecoration(
                    labelText: 'Remaining Seats (e.g. 5 Seats Left)',
                  ),
                ),
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                    labelText: 'Registration Link (URL)',
                  ),
                ),
                TextField(
                  controller: queryLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Query Link (e.g. WhatsApp URL)',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Icon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children:
                      [
                            Icons.school,
                            Icons.smart_toy,
                            Icons.brush,
                            Icons.shopping_bag,
                            Icons.language,
                            Icons.phone_android,
                            Icons.computer,
                            Icons.code,
                          ]
                          .map(
                            (icon) => GestureDetector(
                              onTap: () =>
                                  setDialogState(() => tempIcon = icon),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: tempIcon == icon
                                      ? kDarkGreen.withValues(alpha: 0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: tempIcon == icon
                                        ? kDarkGreen
                                        : Colors.grey.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  color: tempIcon == icon
                                      ? kDarkGreen
                                      : Colors.grey,
                                  size: 24,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Subtitles / Features (Bullet Points)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...tempSubtitles.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => tempSubtitles[idx] = v,
                          decoration: InputDecoration(
                            labelText: 'Subtitle ${idx + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            setDialogState(() => tempSubtitles.removeAt(idx)),
                      ),
                    ],
                  );
                }),
                TextButton.icon(
                  onPressed: () => setDialogState(() => tempSubtitles.add('')),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subtitle'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  setState(() {
                    widget.courses.add(
                      Course(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        subtitles: tempSubtitles
                            .where((s) => s.isNotEmpty)
                            .toList(),
                        registrationLink: linkController.text,
                        courseType: tempType,
                        locationDetail: detailController.text,
                        description: descController.text,
                        duration: durController.text,
                        schedule: schController.text,
                        price: priceController.text,
                        orderNumber: orderController.text.isEmpty
                            ? '01'
                            : orderController.text,
                        remainingSeats: remainingSeatsController.text,
                        queryLink: queryLinkController.text.isEmpty
                            ? 'https://wa.me/923138840971'
                            : queryLinkController.text,
                        icon: tempIcon,
                      ),
                    );
                  });
                  widget.onUpdate();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _editCourseDialog(Course course) {
    final titleController = TextEditingController(text: course.title);
    final linkController = TextEditingController(text: course.registrationLink);
    final detailController = TextEditingController(text: course.locationDetail);
    final descController = TextEditingController(text: course.description);
    final durController = TextEditingController(text: course.duration);
    final schController = TextEditingController(text: course.schedule);
    final priceController = TextEditingController(text: course.price);
    final orderController = TextEditingController(text: course.orderNumber);
    final remainingSeatsController = TextEditingController(
      text: course.remainingSeats,
    );
    final queryLinkController = TextEditingController(text: course.queryLink);
    List<String> tempSubtitles = List.from(course.subtitles);
    if (tempSubtitles.isEmpty) tempSubtitles.add('');
    String tempType = course.courseType;
    IconData tempIcon = course.icon;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: orderController,
                        decoration: const InputDecoration(labelText: 'Order #'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Course Title',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: tempType,
                  decoration: const InputDecoration(labelText: 'Course Type'),
                  items: ['Physical', 'Online']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => tempType = v!),
                ),
                TextField(
                  controller: detailController,
                  decoration: InputDecoration(
                    labelText: tempType == 'Online'
                        ? 'Platform (e.g. Zoom)'
                        : 'Address / Location',
                  ),
                ),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Main Description',
                  ),
                ),
                TextField(
                  controller: durController,
                  decoration: const InputDecoration(labelText: 'Duration'),
                ),
                TextField(
                  controller: schController,
                  decoration: const InputDecoration(labelText: 'Schedule'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: remainingSeatsController,
                  decoration: const InputDecoration(
                    labelText: 'Remaining Seats',
                  ),
                ),
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                    labelText: 'Registration Link (URL)',
                  ),
                ),
                TextField(
                  controller: queryLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Query Link (e.g. WhatsApp)',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Icon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children:
                      [
                            Icons.school,
                            Icons.smart_toy,
                            Icons.brush,
                            Icons.shopping_bag,
                            Icons.language,
                            Icons.phone_android,
                            Icons.computer,
                            Icons.code,
                          ]
                          .map(
                            (icon) => GestureDetector(
                              onTap: () =>
                                  setDialogState(() => tempIcon = icon),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: tempIcon == icon
                                      ? kDarkGreen.withValues(alpha: 0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: tempIcon == icon
                                        ? kDarkGreen
                                        : Colors.grey.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  color: tempIcon == icon
                                      ? kDarkGreen
                                      : Colors.grey,
                                  size: 24,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Subtitles / Features',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...tempSubtitles.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: entry.value,
                          onChanged: (v) => tempSubtitles[idx] = v,
                          decoration: InputDecoration(
                            labelText: 'Subtitle ${idx + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            setDialogState(() => tempSubtitles.removeAt(idx)),
                      ),
                    ],
                  );
                }),
                TextButton.icon(
                  onPressed: () => setDialogState(() => tempSubtitles.add('')),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subtitle'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  course.title = titleController.text;
                  course.subtitles = tempSubtitles
                      .where((s) => s.isNotEmpty)
                      .toList();
                  course.registrationLink = linkController.text;
                  course.courseType = tempType;
                  course.locationDetail = detailController.text;
                  course.description = descController.text;
                  course.duration = durController.text;
                  course.schedule = schController.text;
                  course.price = priceController.text;
                  course.orderNumber = orderController.text;
                  course.queryLink = queryLinkController.text;
                  course.icon = tempIcon;
                });
                widget.onUpdate();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
