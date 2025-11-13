import 'package:flutter/material.dart';
import 'package:task_sync/utils/color_constants.dart';

class TextConstants {
  static String kIndianRupeeSymbol = "₹";
  static String kDollarSymbol = "\$";
}

class TextStyleConstants {
  static TextStyle kRegularTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    color: ColorConstants.kTextBaseColor,
    fontSize: 14,
  );
  static TextStyle kMediumTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    color: ColorConstants.kTextBaseColor,
    fontSize: 14,
  );
  static TextStyle kSemiboldTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    color: ColorConstants.kTextBaseColor,
    fontSize: 14,
  );
  static TextStyle kBoldTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    color: ColorConstants.kTextBaseColor,
    fontSize: 14,
  );
  static TextStyle kExtraBoldTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w800,
    color: ColorConstants.kTextBaseColor,
    fontSize: 14,
  );
}
