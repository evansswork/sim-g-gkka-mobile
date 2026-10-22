import 'package:flutter/material.dart';

import 'beranda.dart';
import 'riwayat.dart';
import 'tema.dart';

typedef _Kegiatan = ({
  String tanggal,
  String hari,
  String judul,
  String detail,
  String tag,
});

class LoginRiwayatPage extends StatefulWidget {
  const LoginRiwayatPage({super.key});

  @override
  State<LoginRiwayatPage> createState() => _LoginRiwayatPageState();
}

class _LoginRiwayatPageState extends State<LoginRiwayatPage> {
  String _filter = 'Semua kegiatan';

  static const List<_Kegiatan> _oktober = [
    (
      tanggal: '11',
      hari: 'Min',
      judul: 'Ibadah Umum 1',
      detail: '07.00, Kasih Mula-mula',
      tag: 'Tugas: Usher',
    ),
    (
      tanggal: '10',
      hari: 'Sab',
      judul: 'Ibadah Pemuda',
      detail: '18.00, Identitas Kristen',
      tag: 'Hadir',
    ),
    (
      tanggal: '7',
      hari: 'Rab',
      judul: 'Persekutuan Doa',
      detail: '19.00, Ruang Doa Lt. 2',
      tag: 'Hadir',
    ),
    (
      tanggal: '4',
      hari: 'Min',
      judul: 'Ibadah Umum 1',
      detail: '07.00, Iman yang Bekerja',
      tag: 'Hadir',
    ),
    (
      tanggal: '3',
      hari: 'Sab',
      judul: 'Ibadah Pemuda',
      detail: '18.00, operator slide',
      tag: 'Tugas: Multimedia',
    ),
  ];

  static const List<_Kegiatan> _september = [
    (
      tanggal: '27',
      hari: 'Min',
      judul: 'Ibadah Umum 2',
      detail: '09.30, Bersyukur dalam Segala Hal',
      tag: 'Tugas: Multimedia',
    ),
    (
      tanggal: '20',
      hari: 'Min',
      judul: 'Ibadah Umum 1',
      detail: '07.00, Dipanggil untuk Melayani',
      tag: 'Hadir',
    ),
    (
      tanggal: '13',
      hari: 'Min',
      judul: 'Ibadah Umum 1',
      detail: '07.00, Kasih Mula-mula',
      tag: 'Tugas: Usher',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        children: [
          const JudulHalaman('Riwayat'),
          const KartuHadirMinggu(
            minggu: [
              (tanggal: '4 Okt', status: StatusHadir.hadir),
              (tanggal: '11 Okt', status: StatusHadir.usher),
              (tanggal: '18 Okt', status: StatusHadir.mingguIni),
              (tanggal: '25 Okt', status: StatusHadir.nanti),
            ],
            keterangan:
                'Bulan ini Anda hadir 11 kali dan bertugas 3 kali. '
                'Terima kasih sudah melayani.',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Expanded(child: Text('Semua riwayat', style: Teks.judul)),
                _tombolFilter(),
              ],
            ),
          ),
          ..._bulan('Oktober 2026', _oktober),
          ..._bulan('September 2026', _september),
        ],
      ),
    );
  }

  Widget _tombolFilter() {
    return PopupMenuButton<String>(
      initialValue: _filter,
      onSelected: (value) => setState(() => _filter = value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Semua kegiatan', child: Text('Semua kegiatan')),
        PopupMenuItem(value: 'Ibadah', child: Text('Ibadah')),
        PopupMenuItem(value: 'Pelayanan', child: Text('Pelayanan')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Warna.garisKuat),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _filter,
              style: Teks.subTebal.copyWith(color: Warna.teksKedua),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Warna.teksKedua,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _bulan(String bulan, List<_Kegiatan> semua) {
    final daftar = semua.where((k) {
      if (_filter == 'Ibadah') return k.judul.startsWith('Ibadah');
      if (_filter == 'Pelayanan') return k.tag.startsWith('Tugas:');
      return true;
    }).toList();
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
        child: Row(
          children: [
            Expanded(child: Text(bulan, style: Teks.subTebal)),
            Text('${daftar.length} kegiatan', style: Teks.kecil),
          ],
        ),
      ),
      if (daftar.isEmpty)
        const Kartu(
          child: Text('Tidak ada riwayat untuk kategori ini.', style: Teks.sub),
        )
      else
        GrupList(
          indent: 76,
          children: [
            for (final k in daftar)
              BarisKegiatan(
                hari: k.hari,
                tanggal: k.tanggal,
                judul: k.judul,
                keterangan: k.detail,
                trailing: k.tag.startsWith('Tugas:')
                    ? Lencana(k.tag)
                    : Text(k.tag, style: Teks.sub),
              ),
          ],
        ),
    ];
  }
}
