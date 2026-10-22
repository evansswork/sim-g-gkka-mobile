import 'package:flutter/material.dart';

import 'beranda.dart';
import 'tema.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final masuk = TombolMobile(
      'Masuk',
      onPressed: () => Navigator.of(context).pushNamed('/masuk'),
    );
    return Scaffold(
      body: IsiHalaman(
        jarak: 20,
        children: [
          const JudulHalaman('Jadwal'),
          TabGaris(
            label: const ['Tugas saya', 'Semua kegiatan'],
            aktif: _tab,
            onTap: (i) => setState(() => _tab = i),
          ),
          if (_tab == 0)
            KotakKosong(
              ikon: Icons.assignment_turned_in_outlined,
              judul: 'Belum ada tugas pelayanan',
              keterangan:
                  'Jadwal tugas Anda muncul di sini setelah masuk. Jadwal '
                  'ibadah tetap bisa dilihat di tab Semua kegiatan.',
              aksi: masuk,
            )
          else ...[
            const GrupList(
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
            masuk,
          ],
        ],
      ),
    );
  }
}
