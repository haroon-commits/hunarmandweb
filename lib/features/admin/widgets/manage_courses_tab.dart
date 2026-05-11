import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/models/course.dart';
import '../../../../core/services/app_data_service.dart';

class ManageCoursesTab extends StatefulWidget {
  const ManageCoursesTab({super.key});

  @override
  State<ManageCoursesTab> createState() => _ManageCoursesTabState();
}

class _ManageCoursesTabState extends State<ManageCoursesTab> {
  final _service = AppDataService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Course>>(
      stream: _service.coursesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final courses = snapshot.data ?? [];

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
              child: courses.isEmpty
                  ? const Center(
                      child: Text('No courses yet. Tap "Add Course" to begin.',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return ListTile(
                          leading: Icon(course.icon, color: kDarkGreen),
                          title: Text(course.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${course.courseType} • ${course.subtitles.isNotEmpty ? course.subtitles.first : 'No subtitles'}'),
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
                                  course.isVisible = !course.isVisible;
                                  _service.saveCourse(course);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () => _editCourseDialog(course),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => _confirmDelete(course),
                              ),
                            ],
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

  void _confirmDelete(Course course) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Delete "${course.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              _service.deleteCourse(course.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addCourseDialog() => _showCourseDialog(null);
  void _editCourseDialog(Course course) => _showCourseDialog(course);

  void _showCourseDialog(Course? existing) {
    final isEdit = existing != null;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final linkController =
        TextEditingController(text: existing?.registrationLink ?? '');
    final detailController =
        TextEditingController(text: existing?.locationDetail ?? '');
    final descController =
        TextEditingController(text: existing?.description ?? '');
    final durController =
        TextEditingController(text: existing?.duration ?? '');
    final schController =
        TextEditingController(text: existing?.schedule ?? '');
    final priceController =
        TextEditingController(text: existing?.price ?? '');
    final orderController =
        TextEditingController(text: existing?.orderNumber ?? '');
    final seatsController =
        TextEditingController(text: existing?.remainingSeats ?? '');
    final queryController =
        TextEditingController(text: existing?.queryLink ?? '');
    List<String> tempSubtitles =
        existing != null ? List.from(existing.subtitles) : [''];
    if (tempSubtitles.isEmpty) tempSubtitles.add('');
    String tempType = existing?.courseType ?? 'Physical';
    IconData tempIcon = existing?.icon ?? Icons.school;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Course' : 'Add New Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: TextField(
                          controller: orderController,
                          decoration: const InputDecoration(
                              labelText: 'Order # (e.g. 01)'))),
                  const SizedBox(width: 20),
                  Expanded(
                      flex: 3,
                      child: TextField(
                          controller: titleController,
                          decoration:
                              const InputDecoration(labelText: 'Course Title'))),
                ]),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: tempType,
                  decoration:
                      const InputDecoration(labelText: 'Course Type'),
                  items: ['Physical', 'Online']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) =>
                      setDialogState(() => tempType = v!),
                ),
                TextField(
                    controller: detailController,
                    decoration: InputDecoration(
                        labelText: tempType == 'Online'
                            ? 'Platform (e.g. Zoom)'
                            : 'Address / Location')),
                TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'Main Description')),
                TextField(
                    controller: durController,
                    decoration:
                        const InputDecoration(labelText: 'Duration')),
                TextField(
                    controller: schController,
                    decoration:
                        const InputDecoration(labelText: 'Schedule')),
                TextField(
                    controller: priceController,
                    decoration:
                        const InputDecoration(labelText: 'Price')),
                TextField(
                    controller: seatsController,
                    decoration: const InputDecoration(
                        labelText: 'Remaining Seats')),
                TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                        labelText: 'Registration Link (URL)')),
                TextField(
                    controller: queryController,
                    decoration: const InputDecoration(
                        labelText: 'Query / WhatsApp Link')),
                const SizedBox(height: 16),
                const Text('Select Icon',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: [
                    Icons.school,
                    Icons.smart_toy,
                    Icons.brush,
                    Icons.shopping_bag,
                    Icons.language,
                    Icons.phone_android,
                    Icons.computer,
                    Icons.code,
                  ]
                      .map((icon) => GestureDetector(
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
                                        : Colors.grey
                                            .withValues(alpha: 0.3)),
                              ),
                              child: Icon(icon,
                                  color: tempIcon == icon
                                      ? kDarkGreen
                                      : Colors.grey,
                                  size: 24),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text('Subtitles / Features',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...tempSubtitles.asMap().entries.map((entry) {
                  final idx = entry.key;
                  return Row(children: [
                    Expanded(
                        child: TextFormField(
                            initialValue: entry.value,
                            onChanged: (v) => tempSubtitles[idx] = v,
                            decoration: InputDecoration(
                                labelText: 'Subtitle ${idx + 1}'))),
                    IconButton(
                      icon: const Icon(Icons.remove_circle,
                          color: Colors.red),
                      onPressed: () => setDialogState(
                          () => tempSubtitles.removeAt(idx)),
                    ),
                  ]);
                }),
                TextButton.icon(
                  onPressed: () =>
                      setDialogState(() => tempSubtitles.add('')),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subtitle'),
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
                final course = Course(
                  id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  subtitles: tempSubtitles.where((s) => s.isNotEmpty).toList(),
                  registrationLink: linkController.text,
                  queryLink: queryController.text.isNotEmpty
                      ? queryController.text
                      : 'https://wa.me/923138840971',
                  courseType: tempType,
                  locationDetail: detailController.text,
                  description: descController.text,
                  duration: durController.text,
                  schedule: schController.text,
                  price: priceController.text,
                  orderNumber: orderController.text.isNotEmpty
                      ? orderController.text
                      : '01',
                  remainingSeats: seatsController.text,
                  icon: tempIcon,
                  isVisible: existing?.isVisible ?? true,
                );
                try {
                  await _service.saveCourse(course);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isEdit
                          ? '✅ Course updated!'
                          : '✅ Course added!'),
                      backgroundColor: Colors.green,
                    ));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('❌ Error: $e'),
                      backgroundColor: Colors.red,
                    ));
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
