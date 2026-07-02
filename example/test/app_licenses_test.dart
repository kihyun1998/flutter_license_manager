import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

import 'package:example/app_licenses.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(LicenseRegistry.reset);

  test('with no custom licenses, "all" matches "basic"', () async {
    LicenseRegistry.addLicense(() async* {
      yield const LicenseEntryWithLineBreaks(['pkg'], 'MIT');
    });

    final licenses = await loadAppLicenses();

    expect(licenses.basic.map((l) => l.packageName).toList(), ['pkg']);
    expect(licenses.all.length, licenses.basic.length);
  });

  test('custom licenses are layered on top of the registry set', () async {
    LicenseRegistry.addLicense(() async* {
      yield const LicenseEntryWithLineBreaks(['pkg'], 'MIT');
    });

    final custom = [
      LicenseService.createCustomLicense(
          packageName: 'Custom A', licenseText: 'A'),
      LicenseService.createCustomLicense(
          packageName: 'Custom B', licenseText: 'B'),
    ];

    final licenses = await loadAppLicenses(customLicenses: custom);

    expect(licenses.basic.length, 1);
    expect(licenses.all.length, licenses.basic.length + 2);
    expect(
      licenses.all.map((l) => l.packageName),
      containsAll(<String>['Custom A', 'Custom B']),
    );
  });
}
