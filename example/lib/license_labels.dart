/// Human-readable label for a license count: "1 license" / "N licenses".
String licenseCountLabel(int count) {
  return count == 1 ? '1 license' : '$count licenses';
}
