import 'package:intl/intl.dart';

class Fmt {
  Fmt._();

  // ── Currency ──────────────────────────────────────────────────────────────
  static String currency(int paise) {
    final rupees = paise / 100;
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return f.format(rupees);
  }

  static String rupeesStr(int paise) {
    final f = NumberFormat('#,##,###', 'en_IN');
    return f.format(paise / 100);
  }

  static String amountInWords(int paise) => '${_toWords((paise / 100).round())} Rupees Only';

  // ── Phone ─────────────────────────────────────────────────────────────────
  static String phone(String raw) {
    final d = raw.replaceAll(RegExp(r'\D'), '');
    if (d.length == 10) return '+91 ${d.substring(0, 5)} ${d.substring(5)}';
    if (d.length == 12 && d.startsWith('91')) { final l = d.substring(2); return '+91 ${l.substring(0, 5)} ${l.substring(5)}'; }
    return raw;
  }
  static String maskPhone(String p) {
    final d = p.replaceAll(RegExp(r'\D'), '');
    final t = d.length >= 10 ? d.substring(d.length - 10) : d;
    return '+91 ${t.substring(0, 5)} ${t.substring(5)}';
  }

  // ── Date ──────────────────────────────────────────────────────────────────
  static String date(DateTime d)       => DateFormat('dd/MM/yyyy').format(d);
  static String monthYear(DateTime d)  => DateFormat('MMM yyyy').format(d);
  static String fullDate(DateTime d)   => DateFormat('d MMM yyyy').format(d);
  static String relative(DateTime d)   {
    final diff = DateTime.now().difference(d);
    if (diff.inDays > 0)   return '${diff.inDays} day${diff.inDays>1?'s':''} ago';
    if (diff.inHours > 0)  return '${diff.inHours} hr${diff.inHours>1?'s':''} ago';
    if (diff.inMinutes > 0)return '${diff.inMinutes} min ago';
    return 'Just now';
  }

  static int monthsLeft(DateTime end)  { final now = DateTime.now(); return end.isBefore(now) ? 0 : ((end.year-now.year)*12+(end.month-now.month)).clamp(0,999); }
  static int totalMonths(DateTime s, DateTime e) => ((e.year-s.year)*12+(e.month-s.month)).clamp(1,999);

  static String receiptId(DateTime d)  => 'BB-${d.year}-${d.month.toString().padLeft(2,'0')}-${(DateTime.now().millisecondsSinceEpoch%100000).toString().padLeft(5,'0')}';

  // ── Words ─────────────────────────────────────────────────────────────────
  static const _o = ['','One','Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve','Thirteen','Fourteen','Fifteen','Sixteen','Seventeen','Eighteen','Nineteen'];
  static const _t = ['','','Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety'];
  static String _toWords(int n) {
    if (n==0) return 'Zero';
    if (n<20) return _o[n];
    if (n<100) return _t[n~/10]+(n%10!=0?' ${_o[n%10]}':'');
    if (n<1000) return '${_o[n~/100]} Hundred${n%100!=0?' ${_toWords(n%100)}':''}';
    if (n<100000) return '${_toWords(n~/1000)} Thousand${n%1000!=0?' ${_toWords(n%1000)}':''}';
    if (n<10000000) return '${_toWords(n~/100000)} Lakh${n%100000!=0?' ${_toWords(n%100000)}':''}';
    return '${_toWords(n~/10000000)} Crore${n%10000000!=0?' ${_toWords(n%10000000)}':''}';
  }
}
