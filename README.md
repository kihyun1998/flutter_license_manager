# Flutter License Manager

A comprehensive Flutter package for managing and displaying OSS (Open Source Software) license information with support for custom licenses and improved UI components.

## 🌟 Features

- 📄 **Load licenses from Flutter's LicenseRegistry**: Automatically collect all licenses from Flutter dependencies
- 🔧 **Add custom licenses**: Include licenses for external libraries, DLLs, or other dependencies not covered by Flutter's registry
- 📝 **Multiple license support**: Handle packages with multiple license texts as separate strings
- 🔍 **License consolidation**: Automatically merges multiple licenses from the same package
- ⚡ **Lightweight**: Minimal dependencies and efficient data handling

## 🚀 Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_license_manager: ^2.0.0
```

Then run:

```bash
flutter pub get
```

## 📖 Usage

### Basic Usage - Load from LicenseRegistry

```dart
import 'package:flutter_license_manager/flutter_license_manager.dart';

// Load all licenses from Flutter's LicenseRegistry
final licenses = await LicenseService.loadFromLicenseRegistry();

// Display in your UI
ListView.builder(
  itemCount: licenses.length,
  itemBuilder: (context, index) {
    final license = licenses[index];
    return ListTile(
      title: Text(license.packageName),
      subtitle: Text('${license.licenseCount} license(s)'),
      onTap: () {
        // Show license details - see example app for implementation
        _showLicenseDetails(license);
      },
    );
  },
);
```

### Advanced Usage - With Custom Licenses

```dart
import 'package:flutter_license_manager/flutter_license_manager.dart';

// Create custom licenses for external dependencies
final customLicenses = [
  LicenseService.createCustomLicense(
    packageName: 'Your Golang DLL',
    licenseText: '''MIT License

Copyright (c) 2024 Your Company

Permission is hereby granted, free of charge, to any person obtaining a copy...''',
  ),
  
  // Add more custom licenses as needed
  LicenseService.createCustomLicense(
    packageName: 'External C++ Library',
    licenseText: 'Your license text here...',
  ),
];

// Load both Flutter registry and custom licenses
final allLicenses = await LicenseService.loadFromLicenseRegistry(
  customLicenses: customLicenses,
);
```

### Working with Multiple License Texts

```dart
// Check if a package has multiple licenses
if (license.hasMultipleLicenses) {
  print('${license.packageName} has ${license.licenseCount} licenses');
  
  // Access individual license texts
  for (int i = 0; i < license.licenseTexts.length; i++) {
    print('License ${i + 1}: ${license.licenseTexts[i]}');
  }
}
```

## 📚 API Reference

### Classes

#### `OssLicenseInfo`

Represents license information for a package.

**Properties:**
- `String packageName`: Name of the package
- `List<String> licenseTexts`: List of license texts (NEW in v2.0.0)
- `int licenseCount`: Number of licenses (automatically calculated)
- `List<String> packageNames`: List of package names (for multi-package licenses)
- `bool isMultiplePackages`: Whether this contains multiple packages
- `bool hasMultipleLicenses`: Whether this package has multiple license texts
- `int packageCount`: Number of packages

#### `LicenseService`

Main service class for loading and managing licenses.

**Methods:**

##### `loadFromLicenseRegistry({List<OssLicenseInfo>? customLicenses})`
Loads all licenses from Flutter's LicenseRegistry and optionally adds custom licenses.

**Parameters:**
- `customLicenses` (optional): List of custom licenses to include

**Returns:** `Future<List<OssLicenseInfo>>`

##### `createCustomLicense({required String packageName, required String licenseText})`
Creates a custom license object.

**Parameters:**
- `packageName`: Name of the package
- `licenseText`: License text content

**Returns:** `OssLicenseInfo`

## 🔄 Migration from v1.x to v2.x

### Breaking Changes

The main breaking change is in the `OssLicenseInfo` class:

**v1.x:**
```dart
class OssLicenseInfo {
  final String licenseText; // Single text
  // ...
}

// Usage
print(license.licenseText);
```

**v2.x:**
```dart
class OssLicenseInfo {
  final List<String> licenseTexts; // List of texts
  // ...
}

// Usage
for (final text in license.licenseTexts) {
  print(text);
}

// Or join them if you need a single string
final combinedText = license.licenseTexts.join('\n\n');
```

## 📱 Example

The [example](./example) directory contains a complete implementation showing:

- Dialog-based license viewing with smooth transitions
- Multiple license text display with proper separators
- Custom license integration
- Desktop-friendly UI design

To run the example:

```bash
cd example
flutter run
```

## 🎥 Demo

The example app demonstrates:

1. **Home Screen**: Choose between basic Flutter licenses or licenses with custom additions
2. **License Dialog**: View all licenses in a searchable dialog
3. **Detail View**: Smooth transition to individual license details with copy functionality
4. **Multiple Licenses**: Proper separation between multiple license texts using Flutter `Divider` widgets

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💖 Support

If you find this package helpful, please give it a ⭐ on [GitHub](https://github.com/kihyun1998/flutter_license_manager)!

For issues and feature requests, please use the [issue tracker](https://github.com/kihyun1998/flutter_license_manager/issues).