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
              licenseText: licenseText,
              licenseCount: 1,
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
    final formattedText = _formatCustomLicenseText(
      packageName: packageName,
      licenseText: licenseText,
    );

    return OssLicenseInfo(
      packageName: packageName,
      licenseText: formattedText,
      licenseCount: 1,
    );
  }

  /// 커스텀 라이선스 텍스트 포맷팅
  static String _formatCustomLicenseText({
    required String packageName,
    required String licenseText,
  }) {
    final buffer = StringBuffer();

    // 실제 라이선스 텍스트
    buffer.write(licenseText);

    return buffer.toString();
  }

  /// 사전 정의된 일반적인 커스텀 라이선스들
  static List<OssLicenseInfo> getCommonCustomLicenses() {
    return [
      // Go 언어 관련
      createCustomLicense(
        packageName: 'Go Runtime',
        licenseText: '''Copyright (c) 2009 The Go Authors. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following
     disclaimer in the documentation and/or other materials provided
     with the distribution.
   * Neither the name of Google Inc. nor the names of its
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.''',
      ),

      // Windows 관련 (예시)
      createCustomLicense(
        packageName: 'Microsoft Visual C++ Redistributable',
        licenseText: '''MICROSOFT SOFTWARE LICENSE TERMS
MICROSOFT VISUAL C++ REDISTRIBUTABLE

These license terms are an agreement between you and Microsoft Corporation (or one of its affiliates). They apply to the software named above and any Microsoft services or software updates (except to the extent such services or updates are accompanied by new or additional terms, in which case those different terms apply prospectively and do not alter your or Microsoft's rights relating to pre-updated software or services).

[Note: This is a simplified example. Please use actual Microsoft license text for real applications]''',
      ),
    ];
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

    // 라이선스 개수 계산
    final totalCount = licenses.length;

    // 모든 라이선스 텍스트를 divider로 구분해서 연결 (원문 그대로)
    final mergedText = _combineAllLicenseTexts(licenses);

    return OssLicenseInfo(
      packageName: packageName,
      licenseText: mergedText,
      licenseCount: totalCount,
    );
  }

  /// 모든 라이선스 텍스트를 divider로 구분해서 하나로 합치기 (원문 그대로 유지)
  static String _combineAllLicenseTexts(List<OssLicenseInfo> licenses) {
    final buffer = StringBuffer();

    for (int i = 0; i < licenses.length; i++) {
      final licenseText = licenses[i].licenseText;

      // 라이선스 텍스트를 원문 그대로 추가
      buffer.write(licenseText);

      // 마지막 라이선스가 아닌 경우 divider 추가
      if (i < licenses.length - 1) {
        buffer.writeln('\n');
        buffer.writeln('─' * 50); // divider
        buffer.writeln();
      }
    }

    return buffer.toString();
  }
}
