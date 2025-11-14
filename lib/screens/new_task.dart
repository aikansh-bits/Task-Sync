import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_sync/components/custom_bottom_button.dart';
import 'package:task_sync/components/global_text_field.dart';
import 'package:task_sync/models/tasks.dart';
import 'package:task_sync/services/task_service.dart';
import 'package:task_sync/utils/color_constants.dart';
import 'package:task_sync/utils/text_style_constants.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key, this.existingTask});
  final Task? existingTask;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;
  bool isLoading = false;
  bool isCreateEnabled = false;

  @override
  void initState() {
    super.initState();

    /// Pre-fill controllers if editing
    _taskTitleController = TextEditingController(
      text: widget.existingTask?.title ?? "",
    )..addListener(_updateCreateButtonState);

    _taskDescriptionController = TextEditingController(
      text: widget.existingTask?.description ?? "",
    )..addListener(_updateCreateButtonState);

    _updateCreateButtonState();
  }

  void _updateCreateButtonState() {
    setState(() {
      isCreateEnabled =
          _taskTitleController.text.isNotEmpty &&
          _taskDescriptionController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateTask() async {
    if (!isCreateEnabled) return;

    setState(() => isLoading = true);
    final taskService = TaskService();

    final success = await taskService.addTask(
      _taskTitleController.text.trim(),
      _taskDescriptionController.text.trim(),
    );

    setState(() => isLoading = false);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Task added successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Failed to add task.')));
    }
  }

  /// -------------------------------
  /// UPDATE EXISTING TASK
  /// -------------------------------
  Future<void> _handleUpdateTask() async {
    if (!isCreateEnabled || widget.existingTask == null) return;

    setState(() => isLoading = true);
    final taskService = TaskService();

    final success = await taskService.updateTask(
      widget.existingTask!.objectId!,
      _taskTitleController.text.trim(),
      _taskDescriptionController.text.trim(),
    );

    setState(() => isLoading = false);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Task updated successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Failed to update task.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.existingTask != null;

    return Scaffold(
      backgroundColor: ColorConstants.kWhiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.kWhiteColor,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: ColorConstants.kTextBaseColor,
            size: 24.spMin,
          ),
        ),
      ),
      bottomSheet: Container(
        color: ColorConstants.kWhiteColor,
        padding: const EdgeInsets.all(16).w,
        child: CustomBottomButton(
          title: isEditing ? "Update" : "Create",
          isActive: isCreateEnabled && !isLoading,
          onTap: isEditing ? _handleUpdateTask : _handleCreateTask,
          borderRadius: 100.w,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16).w,
          child: Column(
            spacing: 16.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Task' : 'New Task',
                style: TextStyleConstants.kExtraBoldTextStyle.copyWith(
                  fontSize: 32.spMin,
                  color: ColorConstants.kTextBaseColor,
                ),
              ),
              CustomGlobalTextField(
                keyboardType: TextInputType.text,
                hintText: "Enter Title",
                title: "Title",
                controller: _taskTitleController,
              ),
              CustomGlobalTextField(
                keyboardType: TextInputType.text,
                hintText: "Enter Description",
                title: "Description",
                controller: _taskDescriptionController,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
