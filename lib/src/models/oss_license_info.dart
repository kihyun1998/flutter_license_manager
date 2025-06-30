class OssLicenseInfo {
  final String packageName;
  final List<String> licenseTexts;
  final int licenseCount;

  OssLicenseInfo({
    required this.packageName,
    required this.licenseTexts,
    int? licenseCount,
  }) : licenseCount = licenseCount ?? licenseTexts.length;

  /// 패키지명을 리스트로 반환 (여러 패키지가 있는 경우)
  List<String> get packageNames {
    return packageName.split(',').map((name) => name.trim()).toList();
  }

  /// 여러 패키지인지 확인
  bool get isMultiplePackages {
    return packageNames.length > 1;
  }

  /// 패키지 개수
  int get packageCount {
    return packageNames.length;
  }

  /// 여러 라이센스가 있는지 확인
  bool get hasMultipleLicenses {
    return licenseTexts.length > 1;
  }

  @override
  String toString() {
    return 'OssLicenseInfo(packageName: $packageName, licenseCount: $licenseCount)';
  }
}
