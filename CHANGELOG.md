# Changelog

## 2.0.0

### BREAKING CHANGES
- Changed `licenseText` to `licenseTexts` (List<String>) in `OssLicenseInfo`

### Added
- Support for multiple license texts per package
- `hasMultipleLicenses` getter in `OssLicenseInfo`
- Proper UI separation with Flutter `Divider` widgets
- Dialog-based license viewing in example app

### Changed
- License text display from text separators to UI widgets
- Example app UI from expandable cards to dialogs
- Improved performance with on-demand loading

### Removed
- Text-based license separators (`─` × 50)
- Expandable card implementation in example

## 1.0.0

### Added
- Initial release
- Load licenses from Flutter's LicenseRegistry
- Support for custom licenses
- License text formatting with proper indentation
- License consolidation for duplicate packages
- Example app with implementation examples