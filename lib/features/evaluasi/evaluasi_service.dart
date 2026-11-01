import 'package:dio/dio.dart';

import '../../core/api.dart';

class FormEvaluasi {
  FormEvaluasi({
    required this.judul,
    required this.link,
    required this.menerimaJawaban,
    this.dibukaPada,
    this.ditutupPada,
  });

  final String judul;
  final String link;
  // false = di luar jadwal dari sekretariat, atau form Google ditutup
  final bool menerimaJawaban;
  // saat dibuka: jadwal sekarang; saat ditutup: jadwal berikutnya (null = belum dijadwalkan)
  final DateTime? dibukaPada;
  final DateTime? ditutupPada;

  factory FormEvaluasi.dariJson(Map<String, dynamic> json) {
    return FormEvaluasi(
      judul: json['judul'] ?? '',
      link: json['link_form'] ?? '',
      menerimaJawaban: json['menerima_jawaban'] ?? false,
      dibukaPada: DateTime.tryParse(json['dibuka_pada'] ?? '')?.toLocal(),
      ditutupPada: DateTime.tryParse(json['ditutup_pada'] ?? '')?.toLocal(),
    );
  }
}

class EvaluasiService {
  // null = Google Form belum dihubungkan di backend (503)
  static Future<FormEvaluasi?> ambilForm({String jenis = 'MINGGUAN'}) async {
    try {
      final res = await Api.dio.get(
        '/evaluasi/form',
        queryParameters: {'jenis': jenis},
      );
      return FormEvaluasi.dariJson(res.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 503) return null;
      throw Api.pesanError(e);
    }
  }
}
