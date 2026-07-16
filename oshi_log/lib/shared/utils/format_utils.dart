/// 整数の金額を3桁カンマ区切り文字列に変換する。
/// 例: 12345 → '12,345'
String formatAmount(int amount) {
  final s = amount.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
