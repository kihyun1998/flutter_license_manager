import 'package:flutter_license_manager/flutter_license_manager.dart';

class LicenseManager {
  static final LicenseManager _instance = LicenseManager._internal();

  factory LicenseManager() {
    return _instance;
  }

  LicenseManager._internal();

  List<OssLicenseInfo>? _basicLicenses;
  List<OssLicenseInfo>? _allLicenses;

  // Basic licenses getter/setter
  List<OssLicenseInfo> get basicLicenses => _basicLicenses ?? [];
  set basicLicenses(List<OssLicenseInfo> licenses) => _basicLicenses = licenses;

  // All licenses getter/setter
  List<OssLicenseInfo> get allLicenses => _allLicenses ?? [];
  set allLicenses(List<OssLicenseInfo> licenses) => _allLicenses = licenses;

  // 초기화 여부 확인
  bool get isInitialized => _basicLicenses != null && _allLicenses != null;

  // 클리어 메서드 (필요시)
  void clear() {
    _basicLicenses = null;
    _allLicenses = null;
  }
}
