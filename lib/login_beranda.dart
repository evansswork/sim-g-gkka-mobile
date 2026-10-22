import 'package:flutter/material.dart';

import 'beranda.dart';
import 'tab_shell.dart';
import 'tema.dart';

enum KeadaanBeranda { bertugas, tidakBertugas, hariMinggu }

class LoginBerandaPage extends StatelessWidget {
  const LoginBerandaPage({
    super.key,
    this.namaJemaat = 'Daniel',
    this.namaLengkap = 'Daniel Susanto',
    this.keadaan = KeadaanBeranda.hariMinggu,
  });

  final String namaJemaat; // nama depan untuk sapaan
  final String namaLengkap; // untuk inisial avatar
  final KeadaanBeranda keadaan;

  bool get _hariMinggu => keadaan == KeadaanBeranda.hariMinggu;
  bool get _bertugas => keadaan != KeadaanBeranda.tidakBertugas;

  String get _inisial {
    final names = namaLengkap.trim().split(RegExp(r'\s+'));
    if (names.isEmpty || names.first.isEmpty) return '?';
    if (names.length == 1) return names.first.characters.first.toUpperCase();
    return '${names.first.characters.first}${names.last.characters.first}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        children: [
          _header(context),
          KartuIbadahMinggu(
            tanggal: _hariMinggu
                ? 'Hari ini, Minggu 18 Oktober'
                : 'Minggu, 18 Oktober',
            tugasDi: _bertugas ? 0 : null,
          ),
          if (_bertugas) _kartuTugas(context),
          _kartuEvaluasi(context),
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

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shalom, $namaJemaat',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Teks.judulBesar,
                ),
                const SizedBox(height: 4),
                Text(
                  _hariMinggu ? 'Minggu, 18 Oktober' : 'Jumat, 16 Oktober',
                  style: Teks.sub,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          TombolIkon(
            ikon: Icons.notifications_none,
            tooltip: 'Notifikasi',
            onPressed: () => _notifikasi(context),
          ),
          const SizedBox(width: 10),
          Semantics(
            button: true,
            label: 'Profil',
            child: InkWell(
              onTap: () => TabShell.pindah(context, 4),
              customBorder: const CircleBorder(),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Warna.brandTint,
                child: Text(
                  _inisial,
                  style: Teks.kecil.copyWith(color: Warna.brandKuat),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuTugas(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Warna.permukaan,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Warna.emas, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Warna.emasTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.how_to_reg_outlined,
                  size: 20,
                  color: Warna.emasTeks,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tugas Anda: Usher, Umum 1',
                      style: Teks.isiTebal,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _hariMinggu
                          ? 'Pintu utama, datang 06.30, bersama Yosua Lim'
                          : 'Minggu 18 Okt. Pintu utama, datang 06.30',
                      style: Teks.sub,
                    ),
                  ],
                ),
              ),
              if (!_hariMinggu) ...[
                const SizedBox(width: 12),
                Text(
                  '2 hari lagi',
                  style: Teks.kecil.copyWith(color: Warna.emasTeks),
                ),
              ],
            ],
          ),
          if (_hariMinggu) ...[
            const SizedBox(height: 12),
            TombolMobile(
              'Buka mode usher',
              ikon: Icons.how_to_reg_outlined,
              onPressed: () => Navigator.of(context).pushNamed('/usher-main'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kartuEvaluasi(BuildContext context) {
    return Kartu(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Evaluasi ibadah', style: Teks.headline),
              ),
              _hariMinggu
                  ? const Lencana('Sudah dibuka')
                  : const Lencana(
                      '11 Okt sudah diisi',
                      nada: NadaLencana.netral,
                    ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _hariMinggu
                ? 'Form minggu ini sudah dibuka. Isi setelah ibadah, paling '
                      'lambat Selasa 23.59.'
                : 'Terima kasih sudah mengisi minggu lalu. Form minggu ini '
                      'dibuka Minggu 06.00.',
            style: Teks.sub.copyWith(color: Warna.teksKedua),
          ),
          const SizedBox(height: 12),
          _hariMinggu
              ? TombolMobile(
                  'Isi evaluasi',
                  ikon: Icons.chat_bubble_outline,
                  onPressed: () => TabShell.pindah(context, 3),
                )
              : TombolMobile(
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
    );
  }

  void _notifikasi(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifikasi'),
        content: const Text('Belum ada notifikasi baru.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
