import 'package:flutter/material.dart';

import 'tab_shell.dart';
import 'tema.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        children: [
          JudulHalaman(
            'Shalom',
            subjudul: 'Jumat, 16 Oktober',
            aksi: TombolMobile(
              'Masuk',
              ikon: Icons.person_outline,
              jenis: JenisTombol.kedua,
              tinggi: 44,
              lebarPenuh: false,
              onPressed: () => Navigator.of(context).pushNamed('/masuk'),
            ),
          ),
          const KartuIbadahMinggu(),
          Kartu(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text('Evaluasi ibadah', style: Teks.headline),
                    ),
                    Lencana('Tanpa login'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Jawaban anonim lewat Google Form, sekitar 2 menit. '
                  'Form minggu ini dibuka Minggu 06.00.',
                  style: Teks.sub.copyWith(color: Warna.teksKedua),
                ),
                const SizedBox(height: 12),
                TombolMobile(
                  'Ingatkan saya hari Minggu',
                  ikon: Icons.notifications_none,
                  jenis: JenisTombol.tint,
                  onPressed: () => tampilkanPesan(
                    context,
                    'Pengingat ibadah Minggu telah diaktifkan.',
                  ),
                ),
              ],
            ),
          ),
          Kartu(
            warna: Warna.brandTint,
            bergaris: false,
            onTap: () => Navigator.of(context).pushNamed('/masuk'),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Melayani di gereja?',
                        style: Teks.isiTebal.copyWith(color: Warna.brandKuat),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Masuk untuk melihat jadwal tugas dan riwayat Anda.',
                        style: Teks.sub.copyWith(color: Warna.teksKedua),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Warna.brandKuat,
                ),
              ],
            ),
          ),
          JudulBagian(
            'Kegiatan minggu ini',
            aksi: 'Semua',
            onAksi: () => TabShell.pindah(context, 1),
          ),
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
                hari: 'Rab',
                tanggal: '21',
                judul: 'Persekutuan Doa',
                keterangan: '19.00, Ruang Doa Lt. 2',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KartuIbadahMinggu extends StatelessWidget {
  const KartuIbadahMinggu({
    this.tanggal = 'Minggu, 18 Oktober',
    this.tugasDi,
    this.tugas = 'Usher',
    super.key,
  });

  final String tanggal;
  final int? tugasDi;
  final String tugas;

  static const _jadwal = [
    (jam: '07.00', label: 'Umum 1'),
    (jam: '09.30', label: 'Umum 2'),
    (jam: '09.30', label: 'Anak (SM)'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Warna.gelap,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tanggal,
                  style: Teks.subTebal.copyWith(color: Warna.emas),
                ),
              ),
              Text(
                'Ibadah Raya',
                style: Teks.kecil.copyWith(color: Warna.gelapPudar),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Hidup yang Berbuah',
            style: Teks.judulBesar.copyWith(color: Warna.gelapTeks),
          ),
          const SizedBox(height: 14),
          Text(
            'Yohanes 15:1–8, Pdt. Samuel Effendi',
            style: Teks.sub.copyWith(color: Warna.gelapPudar),
          ),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < _jadwal.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _JamIbadah(
                      jam: _jadwal[i].jam,
                      label: _jadwal[i].label,
                      tugas: i == tugasDi ? 'Anda: $tugas' : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JamIbadah extends StatelessWidget {
  const _JamIbadah({required this.jam, required this.label, this.tugas});

  final String jam;
  final String label;
  final String? tugas;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Warna.gelapAktif,
        borderRadius: BorderRadius.circular(12),
        border: tugas == null ? null : Border.all(color: Warna.emas, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(jam, style: Teks.headline.copyWith(color: Warna.gelapTeks)),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Teks.kecil.copyWith(color: Warna.gelapPudar),
          ),
          if (tugas != null) ...[
            const SizedBox(height: 2),
            Text(tugas!, style: Teks.kecil.copyWith(color: Warna.emas)),
          ],
        ],
      ),
    );
  }
}

class BarisKegiatan extends StatelessWidget {
  const BarisKegiatan({
    required this.hari,
    required this.tanggal,
    required this.judul,
    required this.keterangan,
    this.trailing,
    this.aktif = false,
    this.onTap,
    super.key,
  });

  final String hari;
  final String tanggal;
  final String judul;
  final String keterangan;
  final Widget? trailing;
  final bool aktif;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            KotakTanggal(hari: hari, tanggal: tanggal, aktif: aktif),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(judul, style: Teks.isiTebal),
                  const SizedBox(height: 2),
                  Text(keterangan, style: Teks.sub),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              // selebar isinya, maksimal 150 supaya teks kiri tetap muat
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
