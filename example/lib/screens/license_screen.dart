import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

import '../widgets/license_card.dart';

class LicenseScreen extends StatelessWidget {
  final List<OssLicenseInfo> licenses;

  const LicenseScreen({
    super.key,
    required this.licenses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licenses (LicenseRegistry)'),
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
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flutter_dash,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LicenseRegistry Method',
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
                  '${licenses.length} packages (Built-in Flutter registry)',
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
