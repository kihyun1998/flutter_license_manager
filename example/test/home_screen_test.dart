import 'package:example/app_licenses.dart';
import 'package:example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';
import 'package:flutter_test/flutter_test.dart';

OssLicenseInfo _pkg(String name) =>
    OssLicenseInfo(packageName: name, licenseTexts: const ['text']);

void main() {
  testWidgets('renders injected basic and all package counts', (tester) async {
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

  testWidgets('does not overflow on a short viewport', (tester) async {
    // Default 800x600 surface, deliberately NOT enlarged.
    final licenses = AppLicenses(
      basic: [_pkg('a'), _pkg('b')],
      all: [_pkg('a'), _pkg('b'), _pkg('c')],
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(licenses: licenses)),
    );

    expect(tester.takeException(), isNull);
    expect(find.textContaining('(2 packages)'), findsOneWidget);
  });
}
