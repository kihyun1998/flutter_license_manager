import 'package:example/services/license_manager.dart';
import 'package:flutter/material.dart';

import '../widgets/license_card.dart';

class CustomLicenseScreen extends StatelessWidget {
  const CustomLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final licenseManager = LicenseManager();
    final licenses = licenseManager.allLicenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Licenses (with Custom)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 헤더 정보
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.library_books,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LicenseRegistry + Custom Licenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${licenses.length} packages (Built-in + Custom licenses)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // 라이선스 리스트
          Expanded(
            child: licenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No licenses found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: licenses.length,
                    itemBuilder: (context, index) {
                      return LicenseCard(license: licenses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
