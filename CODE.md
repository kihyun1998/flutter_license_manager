# flutter_license_manager
## Project Structure

```
flutter_license_manager/
├── example/
    ├── lib/
    │   ├── screens/
    │   │   ├── custom_license_screen.dart
    │   │   ├── home_screen.dart
    │   │   └── license_screen.dart
    │   ├── widgets/
    │   │   └── license_card.dart
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
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(MyApp(
    basicLicenses: basicLicenses,
    allLicenses: allLicenses,
  ));
}

class MyApp extends StatelessWidget {
  final List<OssLicenseInfo> basicLicenses;
  final List<OssLicenseInfo> allLicenses;

  const MyApp({
    super.key,
    required this.basicLicenses,
    required this.allLicenses,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'License Manager Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Segoe UI',
      ),
      home: HomeScreen(
        basicLicenses: basicLicenses,
        allLicenses: allLicenses,
      ),
    );
  }
}

```
## example/lib/screens/custom_license_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

import '../widgets/license_card.dart';

class CustomLicenseScreen extends StatelessWidget {
  final List<OssLicenseInfo> licenses;

  const CustomLicenseScreen({
    super.key,
    required this.licenses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licenses (with Custom)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 헤더 정보
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.library_books,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LicenseRegistry + Custom Licenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${licenses.length} packages (Built-in + Custom licenses)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // 라이선스 리스트
          Expanded(
            child: licenses.isEmpty
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
                    itemCount: licenses.length,
                    itemBuilder: (context, index) {
                      return LicenseCard(license: licenses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

```
## example/lib/screens/home_screen.dart
```dart
import 'package:example/screens/custom_license_screen.dart';
import 'package:example/screens/license_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

class HomeScreen extends StatelessWidget {
  final List<OssLicenseInfo> basicLicenses;
  final List<OssLicenseInfo> allLicenses;

  const HomeScreen({
    super.key,
    required this.basicLicenses,
    required this.allLicenses,
  });

  @override
  Widget build(BuildContext context) {
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
                  'Flutter built-in license registry only (${basicLicenses.length} packages)',
              icon: Icons.flutter_dash,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LicenseScreen(licenses: basicLicenses),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            _buildMethodButton(
              context,
              title: 'With Custom Licenses',
              subtitle:
                  'LicenseRegistry + Custom licenses (${allLicenses.length} packages)',
              icon: Icons.library_books,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomLicenseScreen(licenses: allLicenses),
                  ),
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
## example/lib/screens/license_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

import '../widgets/license_card.dart';

class LicenseScreen extends StatelessWidget {
  final List<OssLicenseInfo> licenses;

  const LicenseScreen({
    super.key,
    required this.licenses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licenses (LicenseRegistry)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 헤더 정보
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flutter_dash,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LicenseRegistry Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${licenses.length} packages (Built-in Flutter registry)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // 라이선스 리스트
          Expanded(
            child: licenses.isEmpty
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
                    itemCount: licenses.length,
                    itemBuilder: (context, index) {
                      return LicenseCard(license: licenses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

```
## example/lib/widgets/license_card.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

class LicenseCard extends StatefulWidget {
  final OssLicenseInfo license;

  const LicenseCard({
    super.key,
    required this.license,
  });

  @override
  State<LicenseCard> createState() => _LicenseCardState();
}

class _LicenseCardState extends State<LicenseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.license.packageName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
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
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey.shade600,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        constraints: BoxConstraints(maxHeight: 400),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'License Text',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: _copyLicenseText,
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Copy license text',
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
            Divider(height: 16, color: Colors.grey.shade400),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: SelectableText(
                  widget.license.licenseText,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    height: 1.4,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLicenseCountText() {
    if (widget.license.licenseCount == 1) {
      return '1 license';
    } else {
      return '${widget.license.licenseCount} licenses';
    }
  }

  void _copyLicenseText() {
    final textToCopy =
        'Package: ${widget.license.packageName}\n\n${widget.license.licenseText}';

    Clipboard.setData(ClipboardData(text: textToCopy));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('License text copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

```
## example/test/widget_test.dart
```dart
import 'package:example/main.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('License Manager Example app test', (WidgetTester tester) async {
    // Mock license data for testing
    final mockLicenses = [
      OssLicenseInfo(
        packageName: 'test_package',
        licenseText: 'Test license text',
        licenseCount: 1,
      ),
    ];

    // Build our app and trigger a frame with mock data
    await tester.pumpWidget(MyApp(
      basicLicenses: mockLicenses,
      allLicenses: mockLicenses,
    ));

    // Verify that the home screen title is displayed
    expect(find.text('Choose License View Method'), findsOneWidget);

    // Verify that both buttons are present
    expect(find.text('Basic LicenseRegistry'), findsOneWidget);
    expect(find.text('With Custom Licenses'), findsOneWidget);
  });
}

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
  final String licenseText;
  final int licenseCount;

  OssLicenseInfo({
    required this.packageName,
    required this.licenseText,
    this.licenseCount = 1,
  });

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
