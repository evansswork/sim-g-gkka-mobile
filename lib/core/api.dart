import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'config/env.dart';

class Api {
  static const penyimpanan = FlutterSecureStorage();

  static final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl))
    ..interceptors.add(
      InterceptorsWrapper(onRequest: _pasangToken, onError: _cobaRefreshToken),
    );

  static void Function()? saatSesiHabis;

  // biar refresh cuma jalan sekali walau ada beberapa request yg 401 barengan
  static Future<bool>? _refreshBerjalan;

  static Future<String?> ambilAccessToken() =>
      penyimpanan.read(key: 'access_token');

  static Future<String?> ambilRefreshToken() =>
      penyimpanan.read(key: 'refresh_token');

  static Future<void> simpanToken(String access, String refresh) async {
    await penyimpanan.write(key: 'access_token', value: access);
    await penyimpanan.write(key: 'refresh_token', value: refresh);
  }

  static Future<void> hapusToken() async {
    await penyimpanan.delete(key: 'access_token');
    await penyimpanan.delete(key: 'refresh_token');
  }

  static String pesanError(DioException e) {
    if (e.response == null) return 'Tidak dapat terhubung ke server.';
    if (e.response!.statusCode == 429) {
      return 'Terlalu banyak percobaan, coba lagi sebentar lagi.';
    }
    final body = e.response!.data;
    if (body is Map && body['message'] is String && body['message'] != '') {
      return body['message'];
    }
    return 'Terjadi kesalahan pada server.';
  }

  static Future<void> _pasangToken(
    RequestOptions request,
    RequestInterceptorHandler handler,
  ) async {
    final token = await ambilAccessToken();
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    handler.next(request);
  }

  // access token cuma 15 menit, kalau 401 refresh dulu lalu ulang request
  static Future<void> _cobaRefreshToken(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    final bukan401 = error.response?.statusCode != 401;
    // 401 di login artinya password salah, bukan token habis
    final requestLogin = request.path == '/auth/login';
    final sudahDiulang = request.extra['diulang'] == true;
    if (bukan401 || requestLogin || sudahDiulang) {
      return handler.next(error);
    }

    _refreshBerjalan ??= _refreshToken();
    final berhasil = await _refreshBerjalan!;
    _refreshBerjalan = null;

    if (!berhasil) {
      // token masih ada berarti cuma offline, jangan dilogout
      final tokenDihapus = await ambilRefreshToken() == null;
      if (tokenDihapus) saatSesiHabis?.call();
      return handler.next(error);
    }

    request.extra['diulang'] = true;
    request.headers['Authorization'] = 'Bearer ${await ambilAccessToken()}';
    try {
      handler.resolve(await dio.fetch(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  // refresh token lama langsung dicabut backend, jadi yg baru wajib disimpan
  static Future<bool> _refreshToken() async {
    final refreshToken = await ambilRefreshToken();
    if (refreshToken == null) return false;
    try {
      // dio baru tanpa interceptor biar ga refresh berulang-ulang
      final res = await Dio(BaseOptions(baseUrl: Env.apiBaseUrl))
          .post('/auth/refresh', data: {'refresh_token': refreshToken});
      final data = res.data['data'];
      await simpanToken(data['access_token'], data['refresh_token']);
      return true;
    } on DioException catch (e) {
      // ditolak backend = sesi habis, kalau offline token jangan dihapus
      if (e.response != null) await hapusToken();
      return false;
    }
  }
}
