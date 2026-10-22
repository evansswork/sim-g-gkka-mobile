import 'package:dio/dio.dart';

import '../../core/api.dart';

class User {
  User({
    required this.id,
    required this.kodeJemaat,
    required this.nama,
    required this.role,
  });

  final int id;
  final String kodeJemaat;
  final String nama;
  final String role;

  String get namaDepan => nama.split(' ').first;

  factory User.dariJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      kodeJemaat: json['kode_jemaat'],
      nama: json['nama'],
      role: json['role'],
    );
  }
}

class AuthService {
  static User? userLogin;

  // identifier bisa no. hp, email, atau kode jemaat
  static Future<void> login(String identifier, String password) async {
    try {
      final res = await Api.dio.post(
        '/auth/login',
        data: {'identifier': identifier, 'password': password},
      );
      final data = res.data['data'];
      await Api.simpanToken(data['access_token'], data['refresh_token']);
      userLogin = User.dariJson(data['user']);
    } on DioException catch (e) {
      throw Api.pesanError(e);
    }
  }

  static Future<void> cekSesi() async {
    if (await Api.ambilRefreshToken() == null) return;
    try {
      final res = await Api.dio.get('/auth/me');
      userLogin = User.dariJson(res.data['data']);
    } on DioException {
      userLogin = null;
    }
  }

  static Future<void> logout() async {
    final refreshToken = await Api.ambilRefreshToken();
    try {
      await Api.dio.post('/auth/logout', data: {'refresh_token': refreshToken});
    } on DioException {
      // server ga bisa dihubungi, tetap logout di hp
    }
    await Api.hapusToken();
    userLogin = null;
  }
}
