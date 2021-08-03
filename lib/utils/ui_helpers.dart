
import 'package:ereceipt/utils/utils.dart';
import 'package:flutter/material.dart';

class UIHelper {
  static const double _VerticalSpaceExtraSmall = 4.0;
  static const double _VerticalSpaceSmall = 8.0;
  static const double _VerticalSpaceMedium = 16.0;
  static const double _VerticalSpaceLarge = 24.0;
  static const double _VerticalSpaceExtraLarge = 48;

  static const double _HorizontalSpaceExtraSmall = 4;
  static const double _HorizontalSpaceSmall = 8.0;
  static const double _HorizontalSpaceMedium = 16.0;
  static const double _HorizontalSpaceLarge = 24.0;
  static const double _HorizontalSpaceExtraLarge = 48.0;

  static SizedBox verticalSpaceExtraSmall() =>
      verticalSpace(_VerticalSpaceExtraSmall);
  static SizedBox verticalSpaceSmall() => verticalSpace(_VerticalSpaceSmall);
  static SizedBox verticalSpaceMedium() => verticalSpace(_VerticalSpaceMedium);
  static SizedBox verticalSpaceLarge() => verticalSpace(_VerticalSpaceLarge);
  static SizedBox verticalSpaceExtraLarge() =>
      verticalSpace(_VerticalSpaceExtraLarge);

  static SizedBox verticalSpace(double height) => SizedBox(height: height);

  static SizedBox horizontalSpaceExtraSmall() =>
      horizontalSpace(_HorizontalSpaceExtraSmall);
  static SizedBox horizontalSpaceSmall() =>
      horizontalSpace(_HorizontalSpaceSmall);
  static SizedBox horizontalSpaceMedium() =>
      horizontalSpace(_HorizontalSpaceMedium);
  static SizedBox horizontalSpaceLarge() =>
      horizontalSpace(_HorizontalSpaceLarge);
  static SizedBox horizontalSpaceExtraLarge() =>
      horizontalSpace(_HorizontalSpaceExtraLarge);

  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  BoxShadow get mainShadow => BoxShadow(
      color: AppColors.SHADOW.withOpacity(0.25),
      offset: const Offset(1.1, 1.1),
      blurRadius: 6.0);

  BoxShadow get button03Shadow => BoxShadow(
      color: AppColors.SHADOW.withOpacity(0.50),
      offset: const Offset(1.1, 1.1),
      blurRadius: 10.0);

  BoxShadow get buttonShadow => BoxShadow(
        color: AppColors.MAIN,
        blurRadius: 4,
        offset: Offset(1, 1),
      );

  BoxShadow get markerImageShadow => BoxShadow(
        color: AppColors.MAIN.withOpacity(0.5),
        blurRadius: 7,
        offset: Offset(1, 1),
      );

  BoxShadow get smallShadow => BoxShadow(
        color: AppColors.MAIN.withOpacity(0.4),
        spreadRadius: 4,
        blurRadius: 5,
        offset: Offset(0, 3),
      );

  BorderRadius get iconRadius => BorderRadius.circular(10.0);
  BorderRadius get mainBorderRadius => BorderRadius.circular(15.0);
  BorderRadius get buttonBorderRadius => BorderRadius.circular(20.0);
  BorderRadius get searchBorderRadius => BorderRadius.circular(30.0);
}
