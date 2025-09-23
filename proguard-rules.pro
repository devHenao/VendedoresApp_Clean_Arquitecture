# Mantener las clases y métodos importantes
-keep class com.mycompany.** { *; }
-dontwarn com.mycompany.**

# Mantener clases generadas por Flutter
-keep class io.flutter.** { *; }

# No eliminar clases que usan Reflexión
-keepattributes *Annotation*

# Evita eliminar métodos utilizados por Flutter
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Permite la optimización, pero sin romper el código
-dontoptimize
