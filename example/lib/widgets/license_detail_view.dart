import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

class LicenseDetailView extends StatelessWidget {
  final OssLicenseInfo license;
  final VoidCallback onBack;

  const LicenseDetailView({
    super.key,
    required this.license,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    license.packageName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getLicenseCountText(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _copyLicenseText,
              icon: Icon(Icons.copy),
              tooltip: 'Copy license text',
            ),
          ],
        ),
        Divider(),
        // 라이센스 텍스트들
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildLicenseTexts(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLicenseTexts() {
    final widgets = <Widget>[];

    for (int i = 0; i < license.licenseTexts.length; i++) {
      // 라이센스 텍스트 추가
      widgets.add(
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            license.licenseTexts[i],
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              height: 1.4,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      );

      // 마지막이 아니면 Divider 추가
      if (i < license.licenseTexts.length - 1) {
        widgets.add(SizedBox(height: 16));
        widgets.add(
          Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        );
        widgets.add(SizedBox(height: 16));
      }
    }

    return widgets;
  }

  String _getLicenseCountText() {
    if (license.licenseCount == 1) {
      return '1 license';
    } else {
      return '${license.licenseCount} licenses';
    }
  }

  void _copyLicenseText() {
    final textToCopy =
        'Package: ${license.packageName}\n\n${license.licenseTexts.join('\n\n')}';
    Clipboard.setData(ClipboardData(text: textToCopy));
  }
}
