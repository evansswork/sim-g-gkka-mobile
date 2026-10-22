import 'package:flutter/material.dart';

import 'tema.dart';

class EvaluasiPage extends StatelessWidget {
  const EvaluasiPage({this.sudahLogin = false, super.key});

  final bool sudahLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.permukaan,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF0EBF8),
                padding: const EdgeInsets.all(12),
                child: const Center(
                  child: Kartu(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 32,
                          color: Warna.teksPudar,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Form evaluasi minggu ini belum tersedia',
                          textAlign: TextAlign.center,
                          style: Teks.headline,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Form dibuka setiap Minggu pukul 06.00.',
                          textAlign: TextAlign.center,
                          style: Teks.sub,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Warna.garis)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Warna.teksPudar,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sudahLogin
                          ? 'Form dibuka dari akun Anda. Status “sudah diisi” '
                                'tercatat di aplikasi.'
                          : 'Jawaban anonim. Setelah dikirim Anda kembali ke '
                                'Beranda.',
                      style: Teks.kecil,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Warna.garis)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Tutup',
            icon: const Icon(Icons.close, size: 22, color: Warna.teksUtama),
            style: IconButton.styleFrom(fixedSize: const Size(44, 44)),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Evaluasi ibadah', style: Teks.headline),
                Row(
                  children: [
                    Icon(Icons.lock_outline, size: 12, color: Warna.teksPudar),
                    SizedBox(width: 4),
                    Text('form.google.com', style: Teks.kecil),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => tampilkanPesan(context, 'Memuat ulang form...'),
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh, size: 22, color: Warna.teksUtama),
            style: IconButton.styleFrom(fixedSize: const Size(44, 44)),
          ),
        ],
      ),
    );
  }
}
