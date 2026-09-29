# Flutter Core & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core & Deferred Components (Referenced by Flutter Engine)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Just Audio & Audio Service (Foreground/Background service reflection)
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.just_audio.** { *; }

# Flutter Local Notifications Plugin
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# SQLite (Sqflite plugin)
-keep class com.tekartik.sqflite.** { *; }

# Firebase Messaging, Core & Crashlytics
-keepattributes *Annotation*
-dontwarn com.google.firebase.**
-keep class com.google.firebase.** { *; }

# Desugaring & Java Time APIs
-dontwarn java.time.**
-dontwarn org.threeten.bp.**

# Native methods (JNI)
-keepclasseswithmembernames class * {
    native <methods>;
}
