class Env {
  /// Ganti saat run: flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8080/gkki/api
  /// 10.0.2.2 = localhost PC dari emulator Android; /gkki/api = BasePath backend.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/gkki/api',
  );
}
