# flutter_license_manager
## Project Structure

```
flutter_license_manager/
├── example/
    ├── lib/
    │   ├── screens/
    │   │   └── home_screen.dart
    │   ├── services/
    │   │   └── license_manager.dart
    │   ├── widgets/
    │   │   ├── license_detail_view.dart
    │   │   └── license_dialog.dart
    │   └── main.dart
    └── test/
    │   └── widget_test.dart
├── lib/
    ├── src/
    │   ├── models/
    │   │   └── oss_license_info.dart
    │   ├── services/
    │   │   └── license_service.dart
    │   └── utils/
    │   │   └── license_parser.dart
    └── flutter_license_manager.dart
└── test/
    └── flutter_license_manager_test.dart
```

## example/lib/main.dart
```dart
import 'package:example/screens/home_screen.dart';
import 'package:example/services/license_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 라이선스 매니저 인스턴스 가져오기
  final licenseManager = LicenseManager();

  // 미리 라이센스들을 로드
  final basicLicenses = await LicenseService.loadFromLicenseRegistry();

  // 커스텀 라이센스 예시
  final customLicenses = [
    LicenseService.createCustomLicense(
      packageName: 'Your Golang DLL',
      licenseText: '''MIT License

Copyright (c) 2024 Your Company

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.''',
    ),
    LicenseService.createCustomLicense(
      packageName: 'External C++ Library',
      licenseText: '''BSD 3-Clause License

Copyright (c) 2024, Example Company
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.''',
    ),
  ];

  final allLicenses = await LicenseService.loadFromLicenseRegistry(
    customLicenses: customLicenses,
  );

  // 싱글톤에 저장
  licenseManager.basicLicenses = basicLicenses;
  licenseManager.allLicenses = allLicenses;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'License Manager Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Segoe UI',
      ),
      home: HomeScreen(),
    );
  }
}

```
## example/lib/screens/home_screen.dart
```dart
import 'package:example/services/license_manager.dart';
import 'package:example/widgets/license_dialog.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final licenseManager = LicenseManager();

    return Scaffold(
      appBar: AppBar(
        title: Text('License Manager Example'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: Colors.blue.shade400,
            ),
            SizedBox(height: 32),
            Text(
              'Choose License View Method',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Compare different ways to display open source licenses',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 48),
            _buildMethodButton(
              context,
              title: 'Basic LicenseRegistry',
              subtitle:
                  'Flutter built-in license registry only (${licenseManager.basicLicenses.length} packages)',
              icon: Icons.flutter_dash,
              color: Colors.blue,
              onTap: () {
                LicenseDialog.show(
                  context,
                  licenses: licenseManager.basicLicenses,
                  title: 'Basic LicenseRegistry',
                );
              },
            ),
            SizedBox(height: 16),
            _buildMethodButton(
              context,
              title: 'With Custom Licenses',
              subtitle:
                  'LicenseRegistry + Custom licenses (${licenseManager.allLicenses.length} packages)',
              icon: Icons.library_books,
              color: Colors.green,
              onTap: () {
                LicenseDialog.show(
                  context,
                  licenses: licenseManager.allLicenses,
                  title: 'With Custom Licenses',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```
## example/lib/services/license_manager.dart
```dart
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

```
## example/lib/widgets/license_detail_view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

class LicenseDetailView extends StatelessWidget {
  final OssLicenseInfo license;
  final VoidCallback onBack;

  const LicenseDetailView({
    super.key,
    required this.license,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    license.packageName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getLicenseCountText(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _copyLicenseText,
              icon: Icon(Icons.copy),
              tooltip: 'Copy license text',
            ),
          ],
        ),
        Divider(),
        // 라이센스 텍스트들
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildLicenseTexts(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLicenseTexts() {
    final widgets = <Widget>[];

    for (int i = 0; i < license.licenseTexts.length; i++) {
      // 라이센스 텍스트 추가
      widgets.add(
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            license.licenseTexts[i],
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              height: 1.4,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      );

      // 마지막이 아니면 Divider 추가
      if (i < license.licenseTexts.length - 1) {
        widgets.add(SizedBox(height: 16));
        widgets.add(
          Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        );
        widgets.add(SizedBox(height: 16));
      }
    }

    return widgets;
  }

  String _getLicenseCountText() {
    if (license.licenseCount == 1) {
      return '1 license';
    } else {
      return '${license.licenseCount} licenses';
    }
  }

  void _copyLicenseText() {
    final textToCopy =
        'Package: ${license.packageName}\n\n${license.licenseTexts.join('\n\n')}';
    Clipboard.setData(ClipboardData(text: textToCopy));
  }
}

```
## example/lib/widgets/license_dialog.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

import 'license_detail_view.dart';

class LicenseDialog extends StatefulWidget {
  final List<OssLicenseInfo> licenses;
  final String title;

  const LicenseDialog({
    super.key,
    required this.licenses,
    required this.title,
  });

  @override
  State<LicenseDialog> createState() => _LicenseDialogState();

  static void show(
    BuildContext context, {
    required List<OssLicenseInfo> licenses,
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (context) => LicenseDialog(
        licenses: licenses,
        title: title,
      ),
    );
  }
}

class _LicenseDialogState extends State<LicenseDialog> {
  OssLicenseInfo? selectedLicense;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // 다이얼로그 헤더
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedLicense != null ? 'License Detail' : widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // 컨텐츠
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: selectedLicense != null
                    ? LicenseDetailView(
                        key: ValueKey('detail_${selectedLicense!.packageName}'),
                        license: selectedLicense!,
                        onBack: () {
                          setState(() {
                            selectedLicense = null;
                          });
                        },
                      )
                    : _buildLicenseList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseList() {
    return Column(
      key: ValueKey('list'),
      children: [
        // 헤더 정보
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Text(
            '${widget.licenses.length} packages',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        // 라이선스 리스트
        Expanded(
          child: widget.licenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No licenses found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: widget.licenses.length,
                  itemBuilder: (context, index) {
                    final license = widget.licenses[index];
                    return ListTile(
                      title: Text(
                        license.packageName,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        license.licenseCount == 1
                            ? '1 license'
                            : '${license.licenseCount} licenses',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        setState(() {
                          selectedLicense = license;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

```
## example/test/widget_test.dart
```dart
void main() {}

```
## lib/flutter_license_manager.dart
```dart
/// A comprehensive Flutter package for managing and collecting OSS license information.
///
/// This package provides utilities to:
/// - Load licenses from Flutter's LicenseRegistry
/// - Add custom licenses for packages not included in the registry
/// - Format license text with proper indentation
/// - Simple OssLicenseInfo model for easy handling
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_license_manager/flutter_license_manager.dart';
///
/// // Load all licenses (including custom ones)
/// final licenses = await LicenseService.loadFromLicenseRegistry(
///   customLicenses: [
///     LicenseService.createCustomLicense(
///       packageName: 'My Custom Package',
///       licenseText: 'Custom license text here...',
///     ),
///   ],
/// );
///
/// // Use in your UI
/// ListView.builder(
///   itemCount: licenses.length,
///   itemBuilder: (context, index) {
///     final license = licenses[index];
///     return ListTile(
///       title: Text(license.packageName),
///       subtitle: Text('${license.licenseCount} license(s)'),
///       onTap: () => showLicenseText(license.licenseText),
///     );
///   },
/// );
/// ```
library;

// Export main classes
export 'src/models/oss_license_info.dart';
export 'src/services/license_service.dart';
export 'src/utils/license_parser.dart';

```
## lib/src/models/oss_license_info.dart
```dart
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

```
## lib/src/services/license_service.dart
```dart
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

```
## lib/src/utils/license_parser.dart
```dart
import 'package:flutter/foundation.dart';

class LicenseParser {
  /// LicenseParagraph 리스트를 읽기 쉬운 텍스트로 변환 (indent 기반 포맷팅 복원)
  static String formatLicenseParagraphs(Iterable<LicenseParagraph> paragraphs) {
    final buffer = StringBuffer();

    for (final paragraph in paragraphs) {
      final text = paragraph.text;
      final indent = paragraph.indent;

      // indent 값만큼 공백(스페이스) 추가
      final indentSpaces = ' ' * (indent * 2); // indent 1당 스페이스 2개

      if (text.isEmpty) {
        // 빈 텍스트는 그대로 빈 줄 추가
        buffer.writeln();
      } else {
        // 들여쓰기 적용된 텍스트 추가
        // 여러 줄인 경우 각 줄마다 들여쓰기 적용
        final lines = text.split('\n');
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.trim().isEmpty) {
            // 빈 줄은 들여쓰기 없이
            buffer.writeln();
          } else {
            // 내용이 있는 줄은 들여쓰기 적용
            buffer.writeln('$indentSpaces$line');
          }
        }
      }
    }

    // 마지막에 추가된 개행문자 하나만 제거 (원본 구조 유지)
    final result = buffer.toString();
    return result.isEmpty ? result : result.substring(0, result.length - 1);
  }
}

```
## test/flutter_license_manager_test.dart
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {});
}

```
