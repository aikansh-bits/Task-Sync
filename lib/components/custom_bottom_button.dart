import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:task_sync/utils/color_constants.dart';
import 'package:task_sync/utils/text_style_constants.dart';

class CustomBottomButton extends StatefulWidget {
  const CustomBottomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.isDelete = false,
    this.isLoading = false,
    this.iconData,
    this.height = 48,
    this.padding,
    this.showRedDot = false,
    this.borderRadius = 8,
  });

  final String title;
  final void Function()? onTap;
  final bool isActive;
  final bool isDelete;
  final bool isLoading;
  final IconData? iconData;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool showRedDot;
  final double? borderRadius;

  @override
  State<CustomBottomButton> createState() => _CustomBottomButtonState();
}

class _CustomBottomButtonState extends State<CustomBottomButton> {
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = widget.isDelete
        ? ColorConstants.kBgDeleteColor
        : widget.isActive
        ? ColorConstants.kBackgroundButtonPrimary
        : ColorConstants.kBorderSubtleColor;

    final Color borderColor = widget.isDelete
        ? ColorConstants.kBackgroundStatusRed
        : widget.isActive
        ? ColorConstants.kBorderButtonPrimary
        : ColorConstants.kBorderDisabledColor;

    final Color textColor = widget.isActive
        ? ColorConstants.kTextBaseColor
        : ColorConstants.kTextDisabledColor;

    return InkWell(
      onTap: widget.isActive && !widget.isLoading ? widget.onTap : null,
      child: Container(
        padding: widget.padding,
        height: widget.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.w),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: Lottie.asset(
                    'assets/spinners/spinner.json',
                    frameRate: FrameRate.max,
                    fit: BoxFit.contain,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.iconData != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 4).w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(widget.iconData, color: textColor, size: 16.w),
                            if (widget.showRedDot)
                              Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kTextStatusRedColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    Text(
                      widget.title,
                      style: TextStyleConstants.kSemiboldTextStyle.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
