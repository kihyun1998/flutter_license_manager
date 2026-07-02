import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

void main() {
  // LicenseRegistry is process-global; reset before each test so the
  // registry-backed cases start from a known-empty state.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(LicenseRegistry.reset);

  group('OssLicenseInfo', () {
    test('licenseCount defaults to the number of license texts', () {
      final info = OssLicenseInfo(packageName: 'foo', licenseTexts: ['a', 'b']);
      expect(info.licenseCount, 2);
      expect(info.hasMultipleLicenses, isTrue);
    });

    test('a single license text is not "multiple"', () {
      final info = OssLicenseInfo(packageName: 'foo', licenseTexts: ['only']);
      expect(info.licenseCount, 1);
      expect(info.hasMultipleLicenses, isFalse);
    });

    test('packageName is one opaque identity — commas carry no meaning', () {
      final info =
          OssLicenseInfo(packageName: 'Foo, Bar', licenseTexts: ['t']);
      expect(info.packageName, 'Foo, Bar');
    });

    test('toString names the package and the license count', () {
      final info = OssLicenseInfo(packageName: 'foo', licenseTexts: ['a', 'b']);
      expect(
        info.toString(),
        'OssLicenseInfo(packageName: foo, licenseCount: 2)',
      );
    });
  });

  group('LicenseService.createCustomLicense', () {
    test('produces a single-package record', () {
      final info = LicenseService.createCustomLicense(
        packageName: 'My Pkg',
        licenseText: 'MIT',
      );
      expect(info.packageName, 'My Pkg');
      expect(info.licenseTexts, ['MIT']);
      expect(info.licenseCount, 1);
    });
  });

  group('LicenseService.loadFromLicenseRegistry', () {
    test('explodes a multi-package registry entry into one record per package',
        () async {
      LicenseRegistry.addLicense(() async* {
        yield const LicenseEntryWithLineBreaks(
          ['pkg_a', 'pkg_b'],
          'shared license text',
        );
      });

      final licenses = await LicenseService.loadFromLicenseRegistry();
      final names = licenses.map((l) => l.packageName).toList();

      expect(names, containsAll(<String>['pkg_a', 'pkg_b']));
      final a = licenses.firstWhere((l) => l.packageName == 'pkg_a');
      expect(a.licenseTexts.single, contains('shared license text'));
      expect(a.hasMultipleLicenses, isFalse);
    });

    test('consolidates same-name records case-insensitively, then sorts',
        () async {
      final licenses = await LicenseService.loadFromLicenseRegistry(
        customLicenses: [
          OssLicenseInfo(packageName: 'Zed', licenseTexts: ['z']),
          OssLicenseInfo(packageName: 'alpha', licenseTexts: ['a1']),
          OssLicenseInfo(packageName: 'Alpha', licenseTexts: ['a2']),
        ],
      );

      // 'alpha' and 'Alpha' merge into one record (first occurrence's casing),
      // sorted case-insensitively before 'Zed'.
      expect(licenses.map((l) => l.packageName).toList(), ['alpha', 'Zed']);

      final alpha = licenses.first;
      expect(alpha.licenseTexts, ['a1', 'a2']);
      expect(alpha.hasMultipleLicenses, isTrue);
    });

    test('drops identical license texts when merging a package', () async {
      final licenses = await LicenseService.loadFromLicenseRegistry(
        customLicenses: [
          OssLicenseInfo(packageName: 'dup', licenseTexts: ['SAME']),
          OssLicenseInfo(packageName: 'dup', licenseTexts: ['SAME']),
        ],
      );

      final record = licenses.singleWhere((l) => l.packageName == 'dup');
      expect(record.licenseTexts, ['SAME']);
      expect(record.hasMultipleLicenses, isFalse);
    });

    test('preserves distinct license texts, in order, when merging', () async {
      final licenses = await LicenseService.loadFromLicenseRegistry(
        customLicenses: [
          OssLicenseInfo(packageName: 'multi', licenseTexts: ['A']),
          OssLicenseInfo(packageName: 'multi', licenseTexts: ['B']),
          OssLicenseInfo(packageName: 'multi', licenseTexts: ['A']),
        ],
      );

      final record = licenses.singleWhere((l) => l.packageName == 'multi');
      expect(record.licenseTexts, ['A', 'B']);
      expect(record.licenseCount, 2);
    });

    test('rethrows when a license collector fails', () async {
      LicenseRegistry.addLicense(() async* {
        throw StateError('collector boom');
      });

      await expectLater(
        LicenseService.loadFromLicenseRegistry(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
