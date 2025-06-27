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
