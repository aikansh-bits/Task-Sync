import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_sync/utils/color_constants.dart';
import 'package:task_sync/utils/text_style_constants.dart';

class CustomGlobalTextField extends StatefulWidget {
  const CustomGlobalTextField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    required this.controller,
    this.title,
    this.textInputFormatters,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.prefixIcon,
    this.boxConstraints,
    this.showErrorText = true,
    this.borderSide = const BorderSide(color: Color(0xFFECECEC)),
    this.fillColor = Colors.transparent,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 14,
      horizontal: 12,
    ),
    this.errorText,
    this.autoFocus = false,
    this.warningText,
    this.labelText,
    this.height,
    this.minLines,
    this.maxLines,
    this.expands = false,
    this.titleSubWidget,
  });

  final TextEditingController controller;
  final List<TextInputFormatter>? textInputFormatters;
  final bool readOnly;
  final TextInputType keyboardType;
  final void Function()? onTap;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final BorderSide borderSide;
  final Color fillColor;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? boxConstraints;
  final bool showErrorText;
  final String? errorText;
  final bool autoFocus;
  final String? title;
  final String? warningText;
  final String? labelText;
  final Widget? titleSubWidget;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final bool expands;

  @override
  State<CustomGlobalTextField> createState() => _CustomGlobalTextFieldState();
}

class _CustomGlobalTextFieldState extends State<CustomGlobalTextField> {
  @override
  Widget build(BuildContext context) {
    final showCustomError = widget.showErrorText && widget.errorText != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null || widget.titleSubWidget != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4).w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: TextStyleConstants.kRegularTextStyle.copyWith(
                      fontSize: 14.spMin,
                      color: ColorConstants.kTextBaseColor,
                    ),
                  ),
                if (widget.titleSubWidget != null) widget.titleSubWidget!,
              ],
            ),
          ),
        SizedBox(
          height: widget.height, // ✅ Constrains height if needed
          child: TextFormField(
            validator: widget.validator,
            onChanged: widget.onChanged,
            controller: widget.controller,
            autofocus: widget.autoFocus,
            textDirection: TextDirection.ltr,
            cursorColor: ColorConstants.kTextBaseColor,
            textAlignVertical: TextAlignVertical.top, // ✅ Better for multiline
            inputFormatters: widget.textInputFormatters,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onFieldSubmitted,
            keyboardType: widget.keyboardType,
            style: TextStyleConstants.kRegularTextStyle.copyWith(
              color: ColorConstants.kTextBaseColor,
              fontSize: 14.spMin,
            ),
            autocorrect: false,
            enableSuggestions: false,
            minLines: widget.minLines, // ✅
            maxLines: widget.maxLines, // ✅
            expands: widget.expands, // ✅
            decoration: InputDecoration(
              errorText: null, // hide default error
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: widget.boxConstraints,
              contentPadding: widget.contentPadding,
              isDense: true,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: widget.borderSide,
                borderRadius: BorderRadius.all(Radius.circular(8)).r,
              ),
              border: OutlineInputBorder(
                borderSide: widget.borderSide,
                borderRadius: BorderRadius.all(Radius.circular(8)).r,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: widget.borderSide,
                borderRadius: BorderRadius.all(Radius.circular(8)).r,
              ),
              hintText: widget.hintText,
              hintTextDirection: TextDirection.ltr,
              hintStyle: TextStyleConstants.kRegularTextStyle.copyWith(
                color: ColorConstants.kTextSubtleColor,
                fontSize: 14.spMin,
              ),
              fillColor: widget.fillColor,
              errorStyle: const TextStyle(height: 0),
              errorMaxLines: 2,
            ),
          ),
        ),
        if (showCustomError)
          Padding(
            padding: const EdgeInsets.only(top: 4).w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: ColorConstants.kTextStatusRedColor,
                  size: 20.w,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: TextStyleConstants.kRegularTextStyle.copyWith(
                      fontSize: 12.spMin,
                      color: ColorConstants.kTextStatusRedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (widget.warningText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4).w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: ColorConstants.kTextLabelColor,
                  size: 14.w,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    widget.warningText!,
                    style: TextStyleConstants.kRegularTextStyle.copyWith(
                      fontSize: 10.spMin,
                      color: ColorConstants.kTextLabelColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4).w,
            child: Text(
              widget.labelText!,
              style: TextStyleConstants.kRegularTextStyle.copyWith(
                fontSize: 12.spMin,
                color: ColorConstants.kTextLabelColor,
              ),
            ),
          ),
      ],
    );
  }
}
