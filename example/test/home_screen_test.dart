import 'package:example/app_licenses.dart';
import 'package:example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';
import 'package:flutter_test/flutter_test.dart';

OssLicenseInfo _pkg(String name) =>
    OssLicenseInfo(packageName: name, licenseTexts: const ['text']);

void main() {
  testWidgets('renders injected basic and all package counts', (tester) async {
    // Give the test a realistic device-sized surface; HomeScreen is a
    // full-screen layout, not sized for the default 800x600 test window.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final licenses = AppLicenses(
      basic: [_pkg('a'), _pkg('b')],
      all: [_pkg('a'), _pkg('b'), _pkg('c')],
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(licenses: licenses)),
    );

    expect(find.textContaining('(2 packages)'), findsOneWidget);
    expect(find.textContaining('(3 packages)'), findsOneWidget);
  });
}
