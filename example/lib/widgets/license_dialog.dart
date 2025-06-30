import 'package:flutter/material.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

import 'license_detail_view.dart';

class LicenseDialog extends StatefulWidget {
  final List<OssLicenseInfo> licenses;
  final String title;

  const LicenseDialog({
    super.key,
    required this.licenses,
    required this.title,
  });

  @override
  State<LicenseDialog> createState() => _LicenseDialogState();

  static void show(
    BuildContext context, {
    required List<OssLicenseInfo> licenses,
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (context) => LicenseDialog(
        licenses: licenses,
        title: title,
      ),
    );
  }
}

class _LicenseDialogState extends State<LicenseDialog> {
  OssLicenseInfo? selectedLicense;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // 다이얼로그 헤더
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedLicense != null ? 'License Detail' : widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // 컨텐츠
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: selectedLicense != null
                    ? LicenseDetailView(
                        key: ValueKey('detail_${selectedLicense!.packageName}'),
                        license: selectedLicense!,
                        onBack: () {
                          setState(() {
                            selectedLicense = null;
                          });
                        },
                      )
                    : _buildLicenseList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseList() {
    return Column(
      key: ValueKey('list'),
      children: [
        // 헤더 정보
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Text(
            '${widget.licenses.length} packages',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        // 라이선스 리스트
        Expanded(
          child: widget.licenses.isEmpty
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
                  itemCount: widget.licenses.length,
                  itemBuilder: (context, index) {
                    final license = widget.licenses[index];
                    return ListTile(
                      title: Text(
                        license.packageName,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        license.licenseCount == 1
                            ? '1 license'
                            : '${license.licenseCount} licenses',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        setState(() {
                          selectedLicense = license;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
