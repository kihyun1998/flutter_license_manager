import 'package:flutter_license_manager/flutter_license_manager.dart';

/// The licenses the example app displays: the registry-only set and the
/// registry-plus-custom set.
class AppLicenses {
  final List<OssLicenseInfo> basic;
  final List<OssLicenseInfo> all;

  const AppLicenses({required this.basic, required this.all});
}

/// Loads the example app's licenses in one place: the Flutter registry set,
/// plus an optional custom set layered on top.
Future<AppLicenses> loadAppLicenses({
  List<OssLicenseInfo> customLicenses = const [],
}) async {
  final basic = await LicenseService.loadFromLicenseRegistry();
  final all = customLicenses.isEmpty
      ? basic
      : await LicenseService.loadFromLicenseRegistry(
          customLicenses: customLicenses,
        );
  return AppLicenses(basic: basic, all: all);
}
