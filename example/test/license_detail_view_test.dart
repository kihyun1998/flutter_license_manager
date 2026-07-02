import 'package:example/widgets/license_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildCopyText formats the package name and joined license texts', () {
    final license = OssLicenseInfo(
      packageName: 'my_pkg',
      licenseTexts: ['MIT text', 'Apache text'],
    );

    expect(
      buildCopyText(license),
      'Package: my_pkg\n\nMIT text\n\nApache text',
    );
  });

  testWidgets('renders one selectable block per license text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LicenseDetailView(
            license: OssLicenseInfo(
              packageName: 'p',
              licenseTexts: ['one', 'two'],
            ),
            onBack: () {},
          ),
        ),
      ),
    );

    expect(find.byType(SelectableText), findsNWidgets(2));
    expect(find.text('2 licenses'), findsOneWidget);
  });

  testWidgets('copy button writes the formatted text to the clipboard', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final license = OssLicenseInfo(packageName: 'p', licenseTexts: ['x']);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LicenseDetailView(license: license, onBack: () {}),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump();

    expect(calls, hasLength(1));
    expect((calls.single.arguments as Map)['text'], buildCopyText(license));
  });
}
