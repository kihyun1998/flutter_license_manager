class OssLicenseInfo {
  /// A single, opaque package identity.
  ///
  /// Never a comma-joined list of packages: the loader explodes multi-package
  /// registry entries into one record each, so a record always names exactly
  /// one package. A comma in this string carries no special meaning.
  final String packageName;
  final List<String> licenseTexts;

  OssLicenseInfo({
    required this.packageName,
    required this.licenseTexts,
  });

  /// Number of license texts for this package. Derived from [licenseTexts];
  /// it can never desync or be constructed to lie.
  int get licenseCount => licenseTexts.length;

  /// 여러 라이센스가 있는지 확인
  bool get hasMultipleLicenses {
    return licenseTexts.length > 1;
  }

  @override
  String toString() {
    return 'OssLicenseInfo(packageName: $packageName, licenseCount: $licenseCount)';
  }
}
