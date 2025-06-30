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
    await tester.pumpWidget(MyApp());

    // Verify that the home screen title is displayed
    expect(find.text('Choose License View Method'), findsOneWidget);

    // Verify that both buttons are present
    expect(find.text('Basic LicenseRegistry'), findsOneWidget);
    expect(find.text('With Custom Licenses'), findsOneWidget);
  });
}
