import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';

class ConvertDateScreen extends StatefulWidget {
  const ConvertDateScreen({Key? key}) : super(key: key);

  @override
  State<ConvertDateScreen> createState() => _ConvertDateScreenState();
}

class _ConvertDateScreenState extends State<ConvertDateScreen> {
  // 0: Gregorian -> Hijri, 1: Hijri -> Gregorian
  int _selectedTab = 0;

  // Gregorian inputs
  late int _gDay;
  late int _gMonth;
  late int _gYear;

  // Hijri inputs
  late int _hDay;
  late int _hMonth;
  late int _hYear;

  // Conversion Result
  String _resultDate = "";
  String _resultDayName = "";
  String _resultFormatted = "";

  static const List<String> _weekDays = [
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
    "الأحد",
  ];

  static const List<String> _hijriMonths = [
    "محرم",
    "صفر",
    "ربيع الأول",
    "ربيع الثاني",
    "جمادى الأولى",
    "جمادى الآخرة",
    "رجب",
    "شعبان",
    "رمضان",
    "شوال",
    "ذو القعدة",
    "ذو الحجة",
  ];

  static const List<String> _gregorianMonths = [
    "يناير",
    "فبراير",
    "مارس",
    "أبريل",
    "مايو",
    "يونيو",
    "يوليو",
    "أغسطس",
    "سبتمبر",
    "أكتوبر",
    "نوفمبر",
    "ديسمبر",
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _gDay = now.day;
    _gMonth = now.month;
    _gYear = now.year;

    // Initialize Hijri from today
    final hInit = _calcGregToIsl(_gDay, _gMonth, _gYear);
    _hDay = hInit['day'] ?? 1;
    _hMonth = hInit['month'] ?? 1;
    _hYear = hInit['year'] ?? 1448;

    _calculate();
  }

  int _intPart(double floatNum) {
    if (floatNum < -0.0000001) {
      return (floatNum - 0.0000001).ceil();
    }
    return (floatNum + 0.0000001).floor();
  }

  String _getWeekDay(int wdn) {
    int idx = wdn % 7;
    if (idx < 0) idx += 7;
    return _weekDays[idx];
  }

  Map<String, dynamic> _calcGregToIsl(int d, int m, int y) {
    int delta = 0;
    int jd;

    if ((y > 1582) ||
        ((y == 1582) && (m > 10)) ||
        ((y == 1582) && (m == 10) && (d > 14))) {
      jd = _intPart((1461 * (y + 4800 + _intPart((m - 14) / 12))) / 4) +
          _intPart((367 * (m - 2 - 12 * (_intPart((m - 14) / 12)))) / 12) -
          _intPart((3 * (_intPart((y + 4900 + _intPart((m - 14) / 12)) / 100))) / 4) +
          d -
          32075 +
          delta;
    } else {
      jd = 367 * y -
          _intPart((7 * (y + 5001 + _intPart((m - 9) / 7))) / 4) +
          _intPart((275 * m) / 9) +
          d +
          1729777 +
          delta;
    }

    int jd1 = jd - delta;
    String dayName = _getWeekDay(jd1 % 7);

    int l = jd - 1948440 + 10632;
    int n = _intPart((l - 1) / 10631);
    l = l - 10631 * n + 354;
    int j = (_intPart((10985 - l) / 5316)) * (_intPart((50 * l) / 17719)) +
        (_intPart(l / 5670)) * (_intPart((43 * l) / 15238));
    l = l -
        (_intPart((30 - j) / 15)) * (_intPart((17719 * j) / 50)) -
        (_intPart(j / 16)) * (_intPart((15238 * j) / 43)) +
        29;
    int hMonth = _intPart((24 * l) / 709);
    int hDay = l - _intPart((709 * hMonth) / 24);
    int hYear = 30 * n + j - 30;

    return {
      'day': hDay,
      'month': hMonth,
      'year': hYear,
      'dayName': dayName,
    };
  }

  Map<String, dynamic> _calcIslToGreg(int d, int m, int y) {
    int delta = 0;
    int jd = _intPart((11 * y + 3) / 30) +
        354 * y +
        30 * m -
        _intPart((m - 1) / 2) +
        d +
        1948440 -
        385 -
        delta;

    int jd1 = jd - delta;
    String dayName = _getWeekDay(jd1 % 7);

    int gDay, gMonth, gYear;
    if (jd > 2299160) {
      int l = jd + 68569;
      int n = _intPart((4 * l) / 146097);
      l = l - _intPart((146097 * n + 3) / 4);
      int i = _intPart((4000 * (l + 1)) / 1461001);
      l = l - _intPart((1461 * i) / 4) + 31;
      int j = _intPart((80 * l) / 2447);
      gDay = l - _intPart((2447 * j) / 80);
      l = _intPart(j / 11);
      gMonth = j + 2 - 12 * l;
      gYear = 100 * (n - 49) + i + l;
    } else {
      int j = jd + 1402;
      int k = _intPart((j - 1) / 1461);
      int l = j - 1461 * k;
      int n = _intPart((l - 1) / 365) - _intPart(l / 1461);
      int i = l - 365 * n + 30;
      j = _intPart((80 * i) / 2447);
      gDay = i - _intPart((2447 * j) / 80);
      i = _intPart(j / 11);
      gMonth = j + 2 - 12 * i;
      gYear = 4 * k + n + i - 4716;
    }

    return {
      'day': gDay,
      'month': gMonth,
      'year': gYear,
      'dayName': dayName,
    };
  }

  void _calculate() {
    setState(() {
      if (_selectedTab == 0) {
        final res = _calcGregToIsl(_gDay, _gMonth, _gYear);
        int d = res['day'];
        int m = res['month'];
        int y = res['year'];
        _resultDayName = res['dayName'];
        String monthName = (m >= 1 && m <= 12) ? _hijriMonths[m - 1] : "$m";
        _resultFormatted = "$d $monthName $y هـ";
        _resultDate = "$d / $m / $y هجري";
      } else {
        final res = _calcIslToGreg(_hDay, _hMonth, _hYear);
        int d = res['day'];
        int m = res['month'];
        int y = res['year'];
        _resultDayName = res['dayName'];
        String monthName =
            (m >= 1 && m <= 12) ? _gregorianMonths[m - 1] : "$m";
        _resultFormatted = "$d $monthName $y م";
        _resultDate = "$d / $m / $y ميلادي";
      }
    });
  }

  Future<void> _pickGregorianDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_gYear, _gMonth, _gDay),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _gDay = picked.day;
        _gMonth = picked.month;
        _gYear = picked.year;
      });
      _calculate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("محول التقويم"),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTabToggle(primaryColor),
                  const SizedBox(height: 20),
                  if (_selectedTab == 0) _buildGregorianInputCard(theme),
                  if (_selectedTab == 1) _buildHijriInputCard(theme),
                  const SizedBox(height: 24),
                  _buildResultCard(theme),
                  const SizedBox(height: 24),
                  _buildNotesCard(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabToggle(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _tabButton(
              title: "من ميلادي إلى هجري",
              icon: Icons.calendar_month,
              isSelected: _selectedTab == 0,
              onTap: () {
                setState(() => _selectedTab = 0);
                _calculate();
              },
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _tabButton(
              title: "من هجري إلى ميلادي",
              icon: Icons.nightlight_round,
              isSelected: _selectedTab == 1,
              onTap: () {
                setState(() => _selectedTab = 1);
                _calculate();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGregorianInputCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "أدخل التاريخ الميلادي:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _pickGregorianDate,
                  icon: const Icon(Icons.date_range, size: 20),
                  label: const Text("اختيار من التقويم"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDropdown<int>(
                    label: "اليوم",
                    value: _gDay,
                    items: List.generate(31, (i) => i + 1),
                    itemText: (val) => "$val",
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _gDay = val);
                        _calculate();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: _buildDropdown<int>(
                    label: "الشهر",
                    value: _gMonth,
                    items: List.generate(12, (i) => i + 1),
                    itemText: (val) => "$val - ${_gregorianMonths[val - 1]}",
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _gMonth = val);
                        _calculate();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildDropdown<int>(
                    label: "السنة",
                    value: _gYear,
                    items: List.generate(201, (i) => 1900 + i),
                    itemText: (val) => "$val",
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _gYear = val);
                        _calculate();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHijriInputCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "أدخل التاريخ الهجري:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDropdown<int>(
                    label: "اليوم",
                    value: math.min(_hDay, 30),
                    items: List.generate(30, (i) => i + 1),
                    itemText: (val) => "$val",
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _hDay = val);
                        _calculate();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: _buildDropdown<int>(
                    label: "الشهر",
                    value: _hMonth,
                    items: List.generate(12, (i) => i + 1),
                    itemText: (val) => "$val - ${_hijriMonths[val - 1]}",
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _hMonth = val);
                        _calculate();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildDropdown<int>(
                    label: "السنة",
                    value: _hYear,
                    items: List.generate(151, (i) => 1350 + i),
                    itemText: (val) => "$val",
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _hYear = val);
                        _calculate();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemText,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemText(item),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildResultCard(ThemeData theme) {
    return Card(
      elevation: 4,
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "يوم $_resultDayName",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _resultFormatted,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _resultDate,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: "يوم $_resultDayName: $_resultFormatted"));
                    Fluttertoast.showToast(msg: "تم نسخ النتيجة بنجاح");
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text("نسخ"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Share.share(
                      "يوم $_resultDayName: $_resultFormatted\nعبر تطبيق تسبيح المسلم",
                      subject: "محول التقويم",
                    );
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text("مشاركة"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "ملاحظات هامة:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "• قد تنتج من عملية التحويل نسبة صغيرة لحدوث فارق يقدر بيوم واحد نظراً لارتباط التقويم الهجري برؤية الهلال الشرعية.",
              style: TextStyle(fontSize: 13, height: 1.6, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              "• التحويل يعتمد على الحسابات الفلكية الدقيقة لتقويم أم القرى.",
              style: TextStyle(fontSize: 13, height: 1.6, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
