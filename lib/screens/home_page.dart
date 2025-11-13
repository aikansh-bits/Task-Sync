import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_sync/components/custom_color_button.dart';
import 'package:task_sync/screens/auth_screen.dart';
import 'package:task_sync/screens/new_task.dart';
import 'package:task_sync/services/auth_service.dart';
import 'package:task_sync/services/task_service.dart';
import 'package:task_sync/models/tasks.dart';
import 'package:task_sync/utils/color_constants.dart';
import 'package:task_sync/utils/text_style_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _subscribeToTasks();
  }

  // Load current user's tasks
  Future<void> _loadTasks() async {
    final tasks = await _taskService.getTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  // Real-time updates with LiveQuery
  Future<void> _subscribeToTasks() async {
    await _taskService.subscribeToUserTasks(
      onTaskChanged: () async {
        final updatedTasks = await _taskService.getTasks();
        if (mounted) {
          setState(() {
            _tasks = updatedTasks;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _taskService.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundBaseColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.kWhiteColor,
        title: Row(
          children: [
            Icon(
              Icons.event_note_outlined,
              color: ColorConstants.kTextBaseColor,
              size: 24.spMin,
            ),
            SizedBox(width: 8.w),
            Text(
              'TaskSync',
              style: TextStyleConstants.kMediumTextStyle.copyWith(
                fontSize: 18.spMin,
                color: ColorConstants.kTextBaseColor,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16).w,
            child: InkWell(
              onTap: () async {
                final authService = AuthService();
                await authService.logoutUser();
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: Container(
                height: 38.w,
                width: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.kBackgroundBaseColor,
                ),
                child: const Center(child: Icon(Icons.logout_outlined)),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: ColorConstants.kWhiteColor,
        padding: const EdgeInsets.all(16).w,
        child: CustomColorButton(
          title: "CREATE TASK",
          isActive: true,
          onTap: () async {
            final shouldRefresh = await Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NewTask()));
            if (shouldRefresh == true) _loadTasks();
          },
          borderRadius: 100.w,
          buttonColor: ColorConstants.kButtonBlueColor,
          textColor: ColorConstants.kWhiteColor,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16).w,
              child: Column(
                children: [
                  // Welcome section
                  Container(
                    padding: EdgeInsets.all(12).w,
                    decoration: BoxDecoration(
                      color: ColorConstants.kWhiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to TaskSync!',
                                style: TextStyleConstants.kSemiboldTextStyle
                                    .copyWith(
                                      fontSize: 16.spMin,
                                      color: ColorConstants.kTextBaseColor,
                                    ),
                              ),
                              Text(
                                'Your productivity companion.',
                                style: TextStyleConstants.kRegularTextStyle
                                    .copyWith(
                                      fontSize: 12.spMin,
                                      color: ColorConstants.kTextSubtleColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.task_alt_outlined,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.w),

                  // Task list section
                  Expanded(
                    child: _tasks.isEmpty
                        ? const Center(child: Text('No tasks yet!'))
                        : ListView.builder(
                            itemCount: _tasks.length,
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 8.w),
                                decoration: BoxDecoration(
                                  color: ColorConstants.kWhiteColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: ListTile(
                                  title: Text(
                                    task.title,
                                    style: TextStyleConstants.kSemiboldTextStyle
                                        .copyWith(
                                          fontSize: 16.spMin,
                                          color: ColorConstants.kTextBaseColor,
                                        ),
                                  ),
                                  subtitle: Text(
                                    task.description,
                                    style: TextStyleConstants.kRegularTextStyle
                                        .copyWith(
                                          fontSize: 14.spMin,
                                          color:
                                              ColorConstants.kTextSubtleColor,
                                        ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      await _taskService.deleteTask(
                                        task.objectId!,
                                      );
                                      _loadTasks();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
