import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:task_sync/components/custom_color_button.dart';
import 'package:task_sync/screens/home_page.dart';
import 'package:task_sync/screens/login_screen.dart';
import 'package:task_sync/screens/sign_up_screen.dart';
import 'package:task_sync/services/auth_service.dart';
import 'package:task_sync/utils/color_constants.dart';
import 'package:task_sync/utils/text_style_constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _checkUser() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isUserLoggedIn();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        padding: EdgeInsets.all(16).w,
        decoration: BoxDecoration(color: ColorConstants.kTextNavBarActive),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 16.w,
          children: [
            SizedBox(height: 40.w),
            Lottie.asset('assets/animations/task.json', height: height * 0.4),
            Spacer(),
            Text(
              "TASK SYNC",
              textAlign: TextAlign.center,
              style: TextStyleConstants.kBoldTextStyle.copyWith(
                color: ColorConstants.kWhiteColor,
                fontSize: 28.spMin,
              ),
            ),

            CustomColorButton(
              title: "LOGIN",
              isActive: true,
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => const Login()));
              },
              iconData: Icons.login_outlined,
              borderRadius: 100.w,
              buttonColor: ColorConstants.kWhiteColor,
              textColor: ColorConstants.kTextBaseColor,
            ),
            CustomColorButton(
              title: "SIGN UP",
              isActive: true,
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => const SignUp()));
              },
              borderRadius: 100.w,
              iconData: Icons.person_outline_outlined,
              buttonColor: ColorConstants.kButtonBlueColor,
              textColor: ColorConstants.kWhiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
