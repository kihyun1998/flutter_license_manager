import 'package:flutter/foundation.dart';

import '../models/oss_license_info.dart';
import '../utils/license_parser.dart';

class LicenseService {
  /// Flutter LicenseRegistry에서 모든 라이선스 정보를 로드 + 커스텀 라이선스 추가
  static Future<List<OssLicenseInfo>> loadFromLicenseRegistry({
    List<OssLicenseInfo>? customLicenses,
  }) async {
    final licenses = <OssLicenseInfo>[];

    try {
      // 1. LicenseRegistry에서 기본 라이선스들 로드
      await for (final license in LicenseRegistry.licenses) {
        final packageNames = license.packages.toList();

        // LicenseParagraph를 원문 그대로 포맷팅
        final licenseText =
            LicenseParser.formatLicenseParagraphs(license.paragraphs);

        // 빈 라이선스는 제외 (패키지명이 없는 경우만)
        if (packageNames.isEmpty) {
          continue;
        }

        // 각 패키지를 개별적으로 처리 (그룹 해체)
        for (final packageName in packageNames) {
          if (packageName.trim().isNotEmpty) {
            licenses.add(OssLicenseInfo(
              packageName: packageName.trim(),
              licenseTexts: [licenseText], // 리스트로 변경
            ));
          }
        }
      }

      // 2. 커스텀 라이선스들 추가
      if (customLicenses != null && customLicenses.isNotEmpty) {
        licenses.addAll(customLicenses);
      }
    } catch (e) {
      debugPrint('라이선스 로딩 오류: $e');
      rethrow;
    }

    // 같은 패키지명 통합 처리 (중복 제거)
    return _consolidateSamePackages(licenses);
  }

  /// 커스텀 라이선스 생성 도우미 메서드
  static OssLicenseInfo createCustomLicense({
    required String packageName,
    required String licenseText,
  }) {
    return OssLicenseInfo(
      packageName: packageName,
      licenseTexts: [licenseText], // 리스트로 변경
    );
  }

  /// 같은 패키지명을 가진 라이선스들을 통합
  static List<OssLicenseInfo> _consolidateSamePackages(
      List<OssLicenseInfo> licenses) {
    final packageGroups = <String, List<OssLicenseInfo>>{};

    // 패키지명으로 그룹화
    for (final license in licenses) {
      final normalizedName = license.packageName.toLowerCase().trim();
      if (!packageGroups.containsKey(normalizedName)) {
        packageGroups[normalizedName] = [];
      }
      packageGroups[normalizedName]!.add(license);
    }

    final consolidatedLicenses = <OssLicenseInfo>[];

    for (final group in packageGroups.values) {
      if (group.length == 1) {
        // 단일 패키지는 그대로 추가
        consolidatedLicenses.add(group.first);
      } else {
        // 여러 라이선스가 있는 경우 통합
        final consolidated = _mergeMultipleLicenses(group);
        consolidatedLicenses.add(consolidated);
      }
    }

    // 패키지명으로 정렬
    consolidatedLicenses.sort((a, b) =>
        a.packageName.toLowerCase().compareTo(b.packageName.toLowerCase()));

    return consolidatedLicenses;
  }

  /// 같은 패키지의 여러 라이선스를 하나로 합치기
  static OssLicenseInfo _mergeMultipleLicenses(List<OssLicenseInfo> licenses) {
    // 원본 패키지명 사용 (첫 번째 것)
    final packageName = licenses.first.packageName;

    // 모든 라이센스 텍스트를 리스트로 합치기
    final allLicenseTexts = <String>[];
    for (final license in licenses) {
      allLicenseTexts.addAll(license.licenseTexts);
    }

    return OssLicenseInfo(
      packageName: packageName,
      licenseTexts: allLicenseTexts,
    );
  }
}
