import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

import '../widgets/license_card.dart';

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({super.key});

  @override
  _LicenseScreenState createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  List<OssLicenseInfo> licenses = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLicenses();
  }

  Future<void> _loadLicenses() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final loadedLicenses = await LicenseService.loadFromLicenseRegistry();

      setState(() {
        licenses = loadedLicenses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licenses (LicenseRegistry)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading licenses...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'Error loading licenses',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLicenses,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (licenses.isEmpty) {
      return Center(
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
      );
    }

    return Column(
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
          child: ListView.builder(
            itemCount: licenses.length,
            itemBuilder: (context, index) {
              return LicenseCard(license: licenses[index]);
            },
          ),
        ),
      ],
    );
  }
}
