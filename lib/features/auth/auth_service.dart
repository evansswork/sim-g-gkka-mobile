import 'package:dio/dio.dart';

import '../../core/api.dart';

class User {
  User({
    required this.id,
    required this.kodeJemaat,
    required this.nama,
    required this.role,
    required this.statusVerifikasi,
    this.keahlian = const [],
  });

  final int id;
  // null kalau belum diverifikasi sekretariat (baru daftar lewat app)
  final String? kodeJemaat;
  final String nama;
  final String role;
  // BELUM_TERVERIFIKASI / MENUNGGU_VERIFIKASI / TERVERIFIKASI
  final String statusVerifikasi;
  // nama keahlian yg sudah diverifikasi sekretariat, mis. Usher, Multimedia
  final List<String> keahlian;

  String get namaDepan => nama.split(' ').first;

  factory User.dariJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      kodeJemaat: json['kode_jemaat'],
      nama: json['nama'],
      role: json['role'],
      statusVerifikasi: json['status_verifikasi'] ?? 'BELUM_TERVERIFIKASI',
      keahlian: [
        for (final k in json['keahlian'] as List? ?? []) k['nama'] as String,
      ],
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
      await _simpanSesi(res.data['data']);
    } on DioException catch (e) {
      throw Api.pesanError(e);
    }
  }

  // signup: akun langsung jadi dan langsung masuk (status belum terverifikasi).
  // email atau noHp boleh kosong salah satu. tanggalLahir format "2000-05-17".
  static Future<void> daftar({
    required String nama,
    required String email,
    required String noHp,
    required String password,
    required String jenisKelamin,
    required String tanggalLahir,
    required String statusGereja,
  }) async {
    try {
      final res = await Api.dio.post(
        '/auth/signup',
        data: {
          'nama': nama,
          'email': email,
          'no_telepon': noHp,
          'password': password,
          'jenis_kelamin': jenisKelamin,
          'tanggal_lahir': tanggalLahir,
          'status_gereja': statusGereja,
          'persetujuan_data': true,
        },
      );
      await _simpanSesi(res.data['data']);
    } on DioException catch (e) {
      throw _pesanErrorIsian(e);
    }
  }

  // response login dan signup bentuknya sama: token + data user
  static Future<void> _simpanSesi(Map<String, dynamic> data) async {
    await Api.simpanToken(data['access_token'], data['refresh_token']);
    userLogin = User.dariJson(data['user']);
  }

  // error 409/422 dari signup punya pesan per field, tampilkan yang pertama supaya jelas apa yang salah
  static String _pesanErrorIsian(DioException e) {
    final body = e.response?.data;
    if (body is Map &&
        body['errors'] is Map &&
        (body['errors'] as Map).isNotEmpty) {
      final errors = body['errors'] as Map;
      final field = errors.keys.first.toString().replaceAll('_', ' ');
      return '${body['message'] ?? 'Data tidak valid'}: $field ${errors.values.first}';
    }
    return Api.pesanError(e);
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
