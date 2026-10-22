import 'package:flutter/material.dart';

import 'beranda.dart';
import 'tema.dart';

class LoginJadwalPage extends StatefulWidget {
  const LoginJadwalPage({super.key});

  @override
  State<LoginJadwalPage> createState() => _LoginJadwalPageState();
}

class _LoginJadwalPageState extends State<LoginJadwalPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        jarak: 20,
        children: [
          const JudulHalaman('Jadwal tugas'),
          TabGaris(
            label: const ['Tugas saya', 'Semua kegiatan'],
            angka: const {0: '4'},
            aktif: _tab,
            onTap: (i) => setState(() => _tab = i),
          ),
          if (_tab == 0) ..._tugasSaya() else ..._semuaKegiatan(),
        ],
      ),
    );
  }

  List<Widget> _tugasSaya() {
    return [
      const JudulBagian('Minggu ini'),
      const GrupList(
        indent: 76,
        children: [
          BarisKegiatan(
            hari: 'Min',
            tanggal: '18',
            aktif: true,
            judul: 'Usher, Ibadah Umum 1',
            keterangan: '07.00, datang 06.30. Pintu utama bersama Yosua Lim',
          ),
        ],
      ),
      const JudulBagian('Berikutnya'),
      const GrupList(
        indent: 76,
        children: [
          BarisKegiatan(
            hari: 'Min',
            tanggal: '25',
            judul: 'Multimedia, Ibadah Umum 2',
            keterangan: '09.30, operator slide & live stream',
          ),
          BarisKegiatan(
            hari: 'Nov',
            tanggal: '8',
            judul: 'Usher, Ibadah Umum 1',
            keterangan: '07.00, pintu samping bersama Natalia Sari',
          ),
          BarisKegiatan(
            hari: 'Nov',
            tanggal: '22',
            judul: 'Multimedia, Ibadah Pemuda',
            keterangan: '18.00, operator slide',
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Warna.peringatanTint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 20, color: Warna.peringatan),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Berhalangan? Beri tahu sekretariat paling lambat Jumat '
                'sebelum hari tugas.',
                style: Teks.sub.copyWith(color: Warna.peringatan),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _semuaKegiatan() {
    return const [
      GrupList(
        indent: 76,
        children: [
          BarisKegiatan(
            hari: 'Sab',
            tanggal: '17',
            judul: 'Ibadah Pemuda',
            keterangan: '18.00, Berani Berbeda',
          ),
          BarisKegiatan(
            hari: 'Min',
            tanggal: '18',
            judul: 'Ibadah Raya',
            keterangan: '07.00 & 09.30, Umum dan Anak (SM)',
          ),
          BarisKegiatan(
            hari: 'Rab',
            tanggal: '21',
            judul: 'Persekutuan Doa',
            keterangan: '19.00, Ruang Doa Lt. 2',
          ),
        ],
      ),
    ];
  }
}
