# Flutter License Manager

A comprehensive Flutter package for managing and displaying OSS (Open Source Software) license information with support for custom licenses.

## Features

- 📄 **Load licenses from Flutter's LicenseRegistry**: Automatically collect all licenses from Flutter dependencies
- 🔧 **Add custom licenses**: Include licenses for external libraries, DLLs, or other dependencies not covered by Flutter's registry
- 📝 **Proper license formatting**: Maintains original indentation and formatting from license texts
- 🔍 **License consolidation**: Automatically merges multiple licenses from the same package
- ⚡ **Lightweight**: Minimal dependencies and efficient performance

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_license_manager: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

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
        // Show license text in your preferred way
        // See example/ directory for implementation ideas
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





## API Reference

### Classes

#### `OssLicenseInfo`

Represents license information for a package.

**Properties:**
- `String packageName`: Name of the package
- `String licenseText`: Full license text
- `int licenseCount`: Number of licenses (default: 1)
- `List<String> packageNames`: List of package names (for multi-package licenses)
- `bool isMultiplePackages`: Whether this contains multiple packages
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





## Example

Check out the [example](./example) directory for a complete implementation showing:

- Basic license display using LicenseRegistry
- Custom license integration
- Example UI components for displaying licenses
- Different display methods

To run the example:

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License
 
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a ⭐ on [GitHub](https://github.com/kihyun1998/flutter_license_manager)!

For issues and feature requests, please use the [issue tracker](https://github.com/kihyun1998/flutter_license_manager/issues).