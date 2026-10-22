import 'package:flutter/material.dart';

import 'tema.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({this.anggotaPelayanan = true, super.key});

  final bool anggotaPelayanan;

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        children: [
          const HeaderKembali('Pengaturan'),
          const LabelBagian('Notifikasi'),
          GrupList(
            indent: 16,
            children: [
              if (widget.anggotaPelayanan)
                BarisPengingat(
                  judul: 'Pengingat tugas pelayanan',
                  subjudul: 'H-1 pukul 19.00 dan 2 jam sebelum tugas',
                  nilai: pengingatTugas,
                ),
              BarisPengingat(
                judul: 'Pengingat ibadah Minggu',
                subjudul: 'Minggu pukul 05.30',
                nilai: pengingatIbadah,
              ),
              BarisPengingat(
                judul: 'Form evaluasi dibuka',
                subjudul: 'Minggu pukul 06.00',
                nilai: pengingatEvaluasi,
              ),
            ],
          ),
          const LabelBagian('Tampilan'),
          _kartuUkuranTeks(),
          const LabelBagian('Akun'),
          GrupList(
            children: [
              BarisList(
                ikon: Icons.edit_outlined,
                judul: 'Ubah profil',
                onTap: () => Navigator.of(context).pushNamed('/ubah-profil'),
              ),
              BarisList(
                ikon: Icons.lock_outline,
                judul: 'Ganti kata sandi',
                onTap: () =>
                    tampilkanPesan(context, 'Fitur ini akan segera tersedia.'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kartuUkuranTeks() {
    const contoh = {
      'Kecil': 14.0,
      'Normal': 17.0,
      'Besar': 21.0,
      'Sangat besar': 25.0,
    };
    return ValueListenableBuilder<String>(
      valueListenable: ukuranTeks,
      builder: (context, dipilih, _) => Kartu(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Ukuran teks', style: Teks.isiTebal),
            const SizedBox(height: 14),
            Row(
              children: [
                for (final e in contoh.entries) ...[
                  if (e.key != 'Kecil') const SizedBox(width: 8),
                  Expanded(child: _pilihan(e.key, e.value, e.key == dipilih)),
                ],
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Warna.halus,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contoh', style: Teks.kecil),
                  SizedBox(height: 4),
                  Text(
                    'Ibadah Umum 1, Minggu 07.00. Tema: Hidup yang Berbuah.',
                    style: Teks.isi,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pilihan(String label, double ukuranAa, bool aktif) {
    return Material(
      color: aktif ? Warna.brandTint : Warna.permukaan,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: aktif ? Warna.brand : Warna.garis,
          width: aktif ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => ukuranTeks.value = label,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
          child: Column(
            children: [
              SizedBox(
                height: 32,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  // "Aa" tidak ikut diperbesar supaya perbandingannya tetap terlihat
                  child: Text(
                    'Aa',
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      fontSize: ukuranAa,
                      fontWeight: FontWeight.w700,
                      color: aktif ? Warna.brandKuat : Warna.teksUtama,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Teks.kecil.copyWith(
                  color: aktif ? Warna.brandKuat : Warna.teksKedua,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
