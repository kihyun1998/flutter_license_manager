import 'package:flutter/foundation.dart';

class LicenseParser {
  /// LicenseParagraph 리스트를 읽기 쉬운 텍스트로 변환 (indent 기반 포맷팅 복원)
  ///
  /// [LicenseParagraph.centeredIndent] 문단은 이 라이선스에서 가장 긴 줄의
  /// 폭을 기준으로 가운데 정렬한다.
  static String formatLicenseParagraphs(Iterable<LicenseParagraph> paragraphs) {
    // (줄 내용, 가운데 정렬 여부). 빈 줄은 ''.
    final lines = <(String, bool)>[];

    for (final paragraph in paragraphs) {
      // \r 문자 처리: \r\n -> \n, 남은 \r -> \n
      final normalizedText =
          paragraph.text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

      final centered = paragraph.indent == LicenseParagraph.centeredIndent;

      // indent 1당 스페이스 2개
      final indentSpaces = centered ? '' : ' ' * (paragraph.indent * 2);

      // 여러 줄인 경우 각 줄마다 들여쓰기 적용
      for (final line in normalizedText.split('\n')) {
        if (line.trim().isEmpty) {
          // 빈 줄은 들여쓰기 없이
          lines.add(('', false));
        } else {
          lines.add((centered ? line.trim() : '$indentSpaces$line', centered));
        }
      }
    }

    final width = lines.fold<int>(
        0, (max, line) => line.$1.length > max ? line.$1.length : max);

    return lines.map((line) {
      final (text, centered) = line;
      if (!centered) return text;
      return '${' ' * ((width - text.length) ~/ 2)}$text';
    }).join('\n');
  }
}
