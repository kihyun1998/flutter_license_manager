import 'package:example/app_licenses.dart';
import 'package:example/license_labels.dart';
import 'package:example/screens/home_screen.dart';
import 'package:example/widgets/license_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';
import 'package:flutter_test/flutter_test.dart';

OssLicenseInfo _pkg(String name, [String text = 'text']) =>
    OssLicenseInfo(packageName: name, licenseTexts: [text]);

void main() {
  group('licenseCountLabel', () {
    test('singular for one license', () {
      expect(licenseCountLabel(1), '1 license');
    });

    test('plural for zero or many', () {
      expect(licenseCountLabel(0), '0 licenses');
      expect(licenseCountLabel(3), '3 licenses');
    });
  });

  group('LicenseDialog', () {
    testWidgets('lists packages, opens a detail, and returns on back', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LicenseDialog(
              licenses: [_pkg('alpha', 'A license'), _pkg('beta')],
              title: 'Licenses',
            ),
          ),
        ),
      );

      // List state.
      expect(find.text('2 packages'), findsOneWidget);
      expect(find.text('alpha'), findsOneWidget);
      expect(find.text('beta'), findsOneWidget);

      // Open a detail.
      await tester.tap(find.text('alpha'));
      await tester.pumpAndSettle();
      expect(find.text('License Detail'), findsOneWidget);
      expect(find.byType(SelectableText), findsWidgets);

      // Back to the list.
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('2 packages'), findsOneWidget);
    });

    testWidgets('shows an empty state when there are no licenses', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LicenseDialog(licenses: [], title: 'Licenses'),
          ),
        ),
      );

      expect(find.text('No licenses found'), findsOneWidget);
      expect(find.text('0 packages'), findsOneWidget);
    });
  });

  testWidgets('tapping a HomeScreen method button opens the dialog', (
    tester,
  ) async {
    final licenses = AppLicenses(basic: [_pkg('alpha')], all: [_pkg('alpha')]);
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(licenses: licenses)),
    );

    await tester.tap(find.text('Basic LicenseRegistry'));
    await tester.pumpAndSettle();

    expect(find.text('1 packages'), findsOneWidget);
    expect(find.text('alpha'), findsOneWidget);

    // Close button dismisses the dialog.
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('1 packages'), findsNothing);
  });

  testWidgets('tapping the custom-licenses button opens the dialog', (
    tester,
  ) async {
    final licenses = AppLicenses(
      basic: [_pkg('alpha')],
      all: [_pkg('alpha'), _pkg('beta')],
    );
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(licenses: licenses)),
    );

    await tester.tap(find.text('With Custom Licenses'));
    await tester.pumpAndSettle();

    expect(find.text('2 packages'), findsOneWidget);
  });
}
