import 'package:example/services/license_manager.dart';
import 'package:example/widgets/license_dialog.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final licenseManager = LicenseManager();

    return Scaffold(
      appBar: AppBar(
        title: Text('License Manager Example'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: Colors.blue.shade400,
            ),
            SizedBox(height: 32),
            Text(
              'Choose License View Method',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Compare different ways to display open source licenses',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 48),
            _buildMethodButton(
              context,
              title: 'Basic LicenseRegistry',
              subtitle:
                  'Flutter built-in license registry only (${licenseManager.basicLicenses.length} packages)',
              icon: Icons.flutter_dash,
              color: Colors.blue,
              onTap: () {
                LicenseDialog.show(
                  context,
                  licenses: licenseManager.basicLicenses,
                  title: 'Basic LicenseRegistry',
                );
              },
            ),
            SizedBox(height: 16),
            _buildMethodButton(
              context,
              title: 'With Custom Licenses',
              subtitle:
                  'LicenseRegistry + Custom licenses (${licenseManager.allLicenses.length} packages)',
              icon: Icons.library_books,
              color: Colors.green,
              onTap: () {
                LicenseDialog.show(
                  context,
                  licenses: licenseManager.allLicenses,
                  title: 'With Custom Licenses',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
