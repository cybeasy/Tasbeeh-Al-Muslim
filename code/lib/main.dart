import 'dart:io';

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/screens/HomeScreen/View/HomeScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:tsbeh/Bloc/AppCubit.dart';
import 'package:tsbeh/Bloc/cubit/ThemeAppCubit.dart';
import 'package:tsbeh/Bloc/cubit/ThemeAppStates.dart';
import 'package:tsbeh/Notifications/Local/NotificationService.dart';
import 'package:tsbeh/Theme/AppTheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:tsbeh/firebase_options.dart';
import 'package:tsbeh/helper/connection/cash/CashLocal.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:tsbeh/helper/dbSQLiteProvider.dart';
import 'package:tsbeh/services/WebAzkarTimerService.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
const assetPath = "assets/images";
const int DurationHours = 24;
const dateFormat = 'MMM dd, yyyy';
late final AudioPlayer player;

// FirebaseAnalytics analytics = FirebaseAnalytics.instance;
// FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
//   analytics: analytics,
// );

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  if (!kIsWeb) {
    HttpOverrides.global = new MyHttpOverrides();
  }

  WidgetsFlutterBinding.ensureInitialized();
  await CashLocal.init();

  if (!kIsWeb) {
    await initFirebase();

    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );

    await NotificationService.init();

    await setupTimeZone();
  } else {
    await setupTimeZone();
    await WebAzkarTimerService.instance.initOnStartup();
  }

  await dbSQLiteProvider.db.database;

  bool isDarkModeOn = CashLocal.getStringCash('IsDark') != "true"
      ? false
      : true;

  String lang = "ar";

  player = AudioPlayer();

  if (!kIsWeb) {
    checkAppRating();
  }

  runApp(MyApp(isDarkModeOn, lang));
}

Future<void> initFirebase() async {
  if (kIsWeb) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final messaging = FirebaseMessaging.instance;

  if (Platform.isIOS) {
    // 1) تأكد إن الإشعارات مسموحة
    final settings = await messaging.getNotificationSettings();
    final allowed =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    if (!allowed) {
      // المستخدم رافض/لسه ما وافقش → لا تشترك في توبك
      return;
    }

    // 2) انتظر لحد ما APNS token يبقى متاح (المحاكي مش هيجيب توكن)
    final apns = await _waitForApnsToken(timeout: const Duration(seconds: 10));
    if (apns == null) {
      // لسه مفيش توكن (أو محاكي) → لا تشترك دلوقتي
      return;
    }

    // 3) آمن دلوقتي
    try {
      await messaging.subscribeToTopic("ios");
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: 'subscribeToTopic(ios)',
      );
    }
  } else if (Platform.isAndroid) {
    // على أندرويد الاشتراك لا يعتمد على وجود صلاحية وقتها؛ مفيش كراش
    try {
      await messaging.subscribeToTopic("android");
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: 'subscribeToTopic(android)',
      );
    }
  }
}

/// يرجّع الـ APNS token أو null لو ما ظهرش قبل الـ timeout
Future<String?> _waitForApnsToken({
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    final t = await FirebaseMessaging.instance.getAPNSToken();
    if (t != null) return t;
    await Future.delayed(const Duration(milliseconds: 300));
  }
  return null;
}

Future<void> setupTimeZone() async {
  try {
    tz.initializeTimeZones();
    final String timeZone = getNameLocalTimeZone();
    print("timeZone:$timeZone");
    if (timeZone.isNotEmpty && tz.timeZoneDatabase.locations.containsKey(timeZone)) {
      tz.setLocalLocation(tz.getLocation(timeZone));
    }
  } catch (e) {
    print("setupTimeZone error: $e");
  }
}

String getNameLocalTimeZone() {
  var locations = tz.timeZoneDatabase.locations;

  int milliseconds = DateTime.now().timeZoneOffset.inMilliseconds;
  String name = "";

  locations.forEach((key, value) {
    for (var element in value.zones) {
      if (element.offset == milliseconds) {
        name = value.name;
        break;
      }
    }
  });

  return name;
}

void checkAppRating() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    int launches = (prefs.getInt("app_launches") ?? 0) + 1;
    await prefs.setInt("app_launches", launches);

    int firstLaunch = prefs.getInt("app_first_launch") ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (firstLaunch == 0) {
      firstLaunch = now;
      await prefs.setInt("app_first_launch", firstLaunch);
    }

    final daysPassed = (now - firstLaunch) ~/ (1000 * 60 * 60 * 24);
    final alreadyReviewed = prefs.getBool("app_already_reviewed") ?? false;

    if (!alreadyReviewed && launches >= 3 && daysPassed >= 3) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await prefs.setBool("app_already_reviewed", true);
      }
    }
  } catch (_) {}
}

class MyApp extends StatelessWidget {
  final bool IsDark;
  final String langCode;
  MyApp(this.IsDark, this.langCode);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((BuildContext context) => AppCubit()..getHomeData(context)),
        ),
        BlocProvider(
          create: ((BuildContext context) =>
              ThemeAppCubit()
                ..ChangeAppMode(fromShared: IsDark, lang: langCode)),
        ),
        // BlocProvider(
        //   create: ((BuildContext context) => LanguageCubit()..changeStartLang),
        // ),
      ],
      child: BlocConsumer<ThemeAppCubit, ThemeAppStates>(
        listener: (themecontext, state) {},
        builder: (themecontext, state) {
          print("BlocConsumer called");
          return MaterialApp(
            builder: (context, child) {
              child = EasyLoading.init()(context, child);

              if (kIsWeb) {
                child = Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: child,
                  ),
                );
              }

              return Directionality(
                textDirection: TextDirection.ltr,
                child: child,
              );
            },
            // builder: EasyLoading.init(),
            navigatorKey: navigatorKey,
            initialRoute: '/',
            theme: lightTheme,
            darkTheme: darkthemes,
            themeMode: ThemeAppCubit.get(themecontext).IsDark
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
            // localizationsDelegates: const [
            //   AppLocalizations.delegate,
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            // supportedLocales: [
            //   Locale('en', ''),
            //   Locale('ar', ''),
            // ],
            // locale: ThemeAppCubit.get(themecontext).appLocal,
          );
        },
      ),
    );
  }
}
