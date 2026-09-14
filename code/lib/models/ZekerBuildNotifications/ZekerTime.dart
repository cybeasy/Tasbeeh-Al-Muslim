import 'package:timezone/timezone.dart' as tz;

class ZekerTime {
  ZekerTime();

  int hours = 0;
  int minutes = 3;
  bool modeHours = false;

  int timeID() {
    return (hours * 60) + minutes;
  }

  factory ZekerTime.fromJson(Map<String, dynamic> map) {
    var cls = ZekerTime();
    cls.hours = map["hours"] ?? 0;
    cls.minutes = map["minutes"] ?? 0;

    return cls;
  }

  String toStringFormated() {
    if (hours == 0) {
      return " $minutes دقيقه";
    } else {
      return "$hours ساعه و $minutes دقيقه";
    }
  }

  Map<String, dynamic> toJson() => {'hours': hours, 'minutes': minutes};

  tz.TZDateTime scheduledDate() {
    try {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      final tz.TZDateTime newTime =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hours, minutes);
      return newTime;
    } catch (_) {
      final now = DateTime.now();
      return tz.TZDateTime.from(
        DateTime(now.year, now.month, now.day, hours, minutes),
        tz.UTC,
      );
    }
  }
}
