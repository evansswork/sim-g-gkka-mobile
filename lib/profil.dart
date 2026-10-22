import 'package:flutter/material.dart';

import 'login_profil.dart';
import 'tema.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _remindersEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        children: [
          const JudulHalaman('Profil'),
          Kartu(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Warna.pudar,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 30,
                        color: Warna.teksPudar,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tamu', style: Teks.judul),
                          SizedBox(height: 2),
                          Text(
                            'Masuk untuk melihat jadwal tugas dan riwayat '
                            'keikutsertaan Anda.',
                            style: Teks.sub,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TombolMobile(
                  'Masuk',
                  onPressed: () => Navigator.of(context).pushNamed('/masuk'),
                ),
                const SizedBox(height: 16),
                TautanTeks(
                  'Belum punya akun? Hubungi sekretariat',
                  onTap: () => tampilkanPesan(
                    context,
                    'Silakan hubungi sekretariat gereja.',
                  ),
                ),
              ],
            ),
          ),
          const LabelBagian('Pengaturan'),
          GrupList(
            children: [
              BarisList(
                ikon: Icons.notifications_none,
                judul: 'Pengingat ibadah',
                subjudul: 'Minggu pagi dan saat form evaluasi dibuka',
                trailing: Saklar(
                  nilai: _remindersEnabled,
                  onChanged: (v) => setState(() => _remindersEnabled = v),
                ),
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
            ],
          ),
          const LabelBagian('Bantuan'),
          const GrupBantuan(),
          const Text(
            'SIM-G GKKA Tenggilis, versi 1.0.0',
            textAlign: TextAlign.center,
            style: Teks.kecil,
          ),
        ],
      ),
    );
  }
}
