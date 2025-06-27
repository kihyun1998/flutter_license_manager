import 'package:flutter/foundation.dart';

class LicenseParser {
  /// LicenseParagraph 리스트를 읽기 쉬운 텍스트로 변환 (indent 기반 포맷팅 복원)
  static String formatLicenseParagraphs(Iterable<LicenseParagraph> paragraphs) {
    final buffer = StringBuffer();

    for (final paragraph in paragraphs) {
      final text = paragraph.text;
      final indent = paragraph.indent;

      // indent 값만큼 공백(스페이스) 추가
      final indentSpaces = ' ' * (indent * 2); // indent 1당 스페이스 2개

      if (text.isEmpty) {
        // 빈 텍스트는 그대로 빈 줄 추가
        buffer.writeln();
      } else {
        // 들여쓰기 적용된 텍스트 추가
        // 여러 줄인 경우 각 줄마다 들여쓰기 적용
        final lines = text.split('\n');
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.trim().isEmpty) {
            // 빈 줄은 들여쓰기 없이
            buffer.writeln();
          } else {
            // 내용이 있는 줄은 들여쓰기 적용
            buffer.writeln('$indentSpaces$line');
          }
        }
      }
    }

    // 마지막에 추가된 개행문자 하나만 제거 (원본 구조 유지)
    final result = buffer.toString();
    return result.isEmpty ? result : result.substring(0, result.length - 1);
  }
}
