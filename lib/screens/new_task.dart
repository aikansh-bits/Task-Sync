import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_sync/components/custom_bottom_button.dart';
import 'package:task_sync/components/global_text_field.dart';
import 'package:task_sync/services/task_service.dart';
import 'package:task_sync/utils/color_constants.dart';
import 'package:task_sync/utils/text_style_constants.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

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
    _taskTitleController = TextEditingController()
      ..addListener(_updateCreateButtonState);
    _taskDescriptionController = TextEditingController()
      ..addListener(_updateCreateButtonState);
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

    // Get the current logged-in user (optional)
    final user = await ParseUser.currentUser() as ParseUser?;
    final userEmail = user?.get<String>('email');

    // You can add user info to the task if you want to make it user-specific:
    // Modify your Task model & TaskService later for that.

    final success = await taskService.addTask(
      _taskTitleController.text.trim(),
      _taskDescriptionController.text.trim(),
    );

    setState(() => isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Task added successfully!')),
      );
      Navigator.pop(context, true); // return true to refresh task list
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Failed to add task.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kWhiteColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.kWhiteColor,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
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
          title: "Create",
          isActive: isCreateEnabled && !isLoading,
          onTap: _handleCreateTask,
          borderRadius: 100.w,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16).w,
          child: Column(
            spacing: 16.w,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Task',
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
