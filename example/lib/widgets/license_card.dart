import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

class LicenseCard extends StatefulWidget {
  final OssLicenseInfo license;

  const LicenseCard({
    super.key,
    required this.license,
  });

  @override
  State<LicenseCard> createState() => _LicenseCardState();
}

class _LicenseCardState extends State<LicenseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.license.packageName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
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
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey.shade600,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        constraints: BoxConstraints(maxHeight: 400),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'License Text',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: _copyLicenseText,
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Copy license text',
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
            Divider(height: 16, color: Colors.grey.shade400),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildLicenseTexts(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLicenseTexts() {
    final widgets = <Widget>[];

    for (int i = 0; i < widget.license.licenseTexts.length; i++) {
      // 라이센스 텍스트 추가
      widgets.add(
        SelectableText(
          widget.license.licenseTexts[i],
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            height: 1.4,
            color: Colors.grey.shade800,
          ),
        ),
      );

      // 마지막이 아니면 Divider 추가
      if (i < widget.license.licenseTexts.length - 1) {
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
    if (widget.license.licenseCount == 1) {
      return '1 license';
    } else {
      return '${widget.license.licenseCount} licenses';
    }
  }

  void _copyLicenseText() {
    final textToCopy =
        'Package: ${widget.license.packageName}\n\n${widget.license.licenseTexts.join('\n\n')}';

    Clipboard.setData(ClipboardData(text: textToCopy));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('License text copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
