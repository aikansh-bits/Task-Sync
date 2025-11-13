import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:task_sync/components/custom_bottom_button.dart';
import 'package:task_sync/components/debouncer.dart';
import 'package:task_sync/components/global_text_field.dart';
import 'package:task_sync/components/no_leading_space_formatter.dart';
import 'package:task_sync/screens/home_page.dart';
import 'package:task_sync/services/auth_service.dart';
import 'package:task_sync/utils/color_constants.dart';
import 'package:task_sync/utils/text_style_constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailIdTextFieldController;
  late TextEditingController passwordTextFieldController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  String? errorMessage;
  bool isEmailValid = false;
  bool isLoading = false;
  bool isGoogleLoading = false;

  handleEmailIdSubmit() async {
    setState(() => isLoading = true);
    final authService = AuthService();
    final email = emailIdTextFieldController.text.trim();
    final password = passwordTextFieldController.text.trim();

    final error = await authService.loginUser(email, password);

    setState(() => isLoading = false);

    if (error == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Logged in successfully!')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ $error')));
    }
  }

  String? validateEmail(String? val) {
    if (val == null ||
        val.isEmpty ||
        RegExp(
          r"^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$",
        ).hasMatch(val)) {
      return null;
    } else {
      return "Invalid Email Id.";
    }
  }

  @override
  void initState() {
    super.initState();
    emailIdTextFieldController = TextEditingController()
      ..addListener(() {
        setState(() {
          isEmailValid = RegExp(
            r"^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$",
          ).hasMatch(emailIdTextFieldController.text);
        });
      });
    passwordTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    emailIdTextFieldController.dispose();
    passwordTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            decoration: BoxDecoration(color: ColorConstants.kTextNavBarActive),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20).w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.w),
                      Text(
                        "TASK SYNC",
                        textAlign: TextAlign.center,
                        style: TextStyleConstants.kBoldTextStyle.copyWith(
                          color: ColorConstants.kWhiteColor,
                          fontSize: 28.spMin,
                        ),
                      ),
                      SizedBox(height: 20.w),
                      Text(
                        "Stay organized and sync your tasks anytime, anywhere.",
                        textAlign: TextAlign.center,
                        style: TextStyleConstants.kMediumTextStyle.copyWith(
                          color: ColorConstants.kWhiteColor,
                          fontSize: 16.spMin,
                        ),
                      ),
                      SizedBox(height: 20.w),
                      Lottie.asset(
                        'assets/animations/task.json',
                        height: height * 0.3,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: width,
                  height: height * 0.41,
                  decoration: BoxDecoration(
                    color: ColorConstants.kWhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  margin: EdgeInsets.only(top: 10).h,
                  padding: EdgeInsets.all(16).w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8).w,
                        child: Text(
                          "Login to Manage, Sync, Achieve your Tasks!",
                          style: TextStyleConstants.kSemiboldTextStyle.copyWith(
                            fontSize: 14.spMin,
                            color: ColorConstants.kTextBaseColor,
                          ),
                        ),
                      ),
                      Divider(color: ColorConstants.kBorderSubtleColor),
                      SizedBox(height: 16.w),
                      Form(
                        key: formKey,
                        child: CustomGlobalTextField(
                          title: "Email id",
                          controller: emailIdTextFieldController,
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          errorText: errorMessage,
                          textInputFormatters: [
                            NoLeadingSpaceFormatter(),
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z0-9._%-@]"),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              errorMessage = null;
                            });

                            debouncer.run(() {
                              setState(() {
                                errorMessage = validateEmail(val);
                              });
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16.w),
                      CustomGlobalTextField(
                        controller: passwordTextFieldController,
                        title: "Password",
                        keyboardType: TextInputType.text,
                        hintText: "Enter Password",
                      ),
                      Spacer(),
                      CustomBottomButton(
                        title: "LOGIN",
                        isLoading: isLoading,
                        isActive: isEmailValid,
                        onTap: handleEmailIdSubmit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
