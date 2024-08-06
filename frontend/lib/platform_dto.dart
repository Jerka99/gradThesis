import 'package:platform_detector/enums.dart';

class PlatformDto{
  final PlatformType currentPlatformType;
  final PlatformName currentPlatformName;
  final PlatformCompany currentPlatformCompany;

  PlatformDto(
      {required this.currentPlatformCompany,
      required this.currentPlatformName,
      required this.currentPlatformType});
}
