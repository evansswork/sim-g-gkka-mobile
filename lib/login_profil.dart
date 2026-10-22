import 'package:flutter/material.dart';

import 'features/auth/auth_service.dart';
import 'tema.dart';

class LoginProfilPage extends StatefulWidget {
  const LoginProfilPage({
    super.key,
    this.namaJemaat = 'Daniel Susanto',
    this.nomorAnggota = '0218',
    this.pelayanan = const ['Usher', 'Multimedia'],
  });

  final String namaJemaat;
  final String nomorAnggota;
  final List<String> pelayanan;

  @override
  State<LoginProfilPage> createState() => _LoginProfilPageState();
}

class _LoginProfilPageState extends State<LoginProfilPage> {
  bool get _anggotaPelayanan => widget.pelayanan.isNotEmpty;

  String get _initials {
    final parts = widget.namaJemaat.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        children: [
          JudulHalaman(
            'Profil',
            aksi: TombolIkon(
              ikon: Icons.edit_outlined,
              tooltip: 'Pengaturan',
              onPressed: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/pengaturan', arguments: _anggotaPelayanan),
            ),
          ),
          _header(),
          _kartuInfo(
            judul: 'Komunitas Anda',
            chips: const ['Pemuda', 'Wilayah Tenggilis'],
          ),
          if (_anggotaPelayanan)
            _kartuInfo(
              judul: 'Pelayanan yang dapat diikuti',
              chips: widget.pelayanan,
              brand: true,
            ),
          const LabelBagian('Pengaturan'),
          GrupList(
            children: [
              if (_anggotaPelayanan)
                BarisPengingat(
                  ikon: Icons.assignment_ind_outlined,
                  judul: 'Pengingat tugas pelayanan',
                  subjudul: 'H-1 pukul 19.00 dan 2 jam sebelum tugas',
                  nilai: pengingatTugas,
                ),
              BarisPengingat(
                ikon: Icons.notifications_none,
                judul: 'Pengingat ibadah Minggu',
                subjudul: 'Minggu pukul 05.30',
                nilai: pengingatIbadah,
              ),
              ValueListenableBuilder<String>(
                valueListenable: ukuranTeks,
                builder: (context, ukuran, _) => BarisList(
                  ikon: Icons.visibility_outlined,
                  judul: 'Ukuran teks',
                  subjudul: ukuran,
                  onTap: () => pilihUkuranTeks(context),
                ),
              ),
              BarisList(
                ikon: Icons.lock_outline,
                judul: 'Ganti kata sandi',
                onTap: () => tampilkanPesan(
                  context,
                  'Fitur ganti kata sandi akan segera tersedia.',
                ),
              ),
            ],
          ),
          const LabelBagian('Bantuan'),
          const GrupBantuan(),
          GrupList(
            children: [
              BarisList(
                ikon: Icons.logout,
                judul: 'Keluar',
                warna: Warna.bahaya,
                trailing: const SizedBox.shrink(),
                onTap: _confirmLogout,
              ),
            ],
          ),
          const Text(
            'SIM-G GKKA Tenggilis, versi 1.0.0',
            textAlign: TextAlign.center,
            style: Teks.kecil,
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Warna.brandTint,
            child: Text(
              _initials,
              style: Teks.kecil.copyWith(color: Warna.brandKuat),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.namaJemaat, style: Teks.judul),
                const SizedBox(height: 2),
                Text(
                  'Jemaat sejak 2014, no. anggota ${widget.nomorAnggota}',
                  style: Teks.sub,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuInfo({
    required String judul,
    required List<String> chips,
    bool brand = false,
  }) {
    return Kartu(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(judul, style: Teks.headline)),
              const SizedBox(width: 8),
              const Text('Diatur sekretariat', style: Teks.kecil),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final c in chips) Chip2(c, aktif: brand)],
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda akan kembali ke beranda tamu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await AuthService.logout();
              if (!mounted) return;
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil('/beranda', (route) => false);
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class GrupBantuan extends StatelessWidget {
  const GrupBantuan({super.key});

  @override
  Widget build(BuildContext context) {
    void info(String judul, String isi) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(judul),
          content: Text(isi),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }

    return GrupList(
      children: [
        BarisList(
          ikon: Icons.chat_bubble_outline,
          judul: 'Hubungi sekretariat',
          subjudul: 'WhatsApp 0812-3000-1122',
          onTap: () => tampilkanPesan(context, 'WhatsApp: 0812-3000-1122'),
        ),
        BarisList(
          ikon: Icons.info_outline,
          judul: 'Tentang aplikasi',
          onTap: () => info(
            'Tentang aplikasi',
            'Aplikasi GKKA Mobile membantu Anda melihat jadwal ibadah, '
                'riwayat, dan informasi pelayanan gereja.',
          ),
        ),
        BarisList(
          ikon: Icons.shield_outlined,
          judul: 'Kebijakan privasi',
          onTap: () => info(
            'Kebijakan privasi',
            'Informasi akun digunakan untuk mendukung layanan gereja. '
                'Evaluasi ibadah dapat diisi secara anonim.',
          ),
        ),
      ],
    );
  }
}
