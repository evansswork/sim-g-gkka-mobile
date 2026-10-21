import 'package:flutter/material.dart';

import 'beranda.dart';
import 'jadwal.dart';
import 'login_beranda.dart';
import 'login_jadwal.dart';
import 'login_profil.dart';
import 'login_riwayat.dart';
import 'masuk.dart';
import 'pengaturan.dart';
import 'profil.dart';
import 'riwayat.dart';
import 'ubah_profil.dart';
import 'usher_absen.dart';
import 'usher_main.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006F77)),
        useMaterial3: true,
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final systemScale = mediaQuery.textScaler.scale(1);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(systemScale * 1.4),
          ),
          child: child!,
        );
      },
      home: const LoginBerandaPage(),
      routes: {
        '/beranda': (_) => const BerandaPage(),
        '/jadwal': (_) => const JadwalPage(),
        '/login-jadwal': (_) => const LoginJadwalPage(),
        '/login-riwayat': (_) => const LoginRiwayatPage(),
        '/login-profil': (_) => const LoginProfilPage(),
        '/login-beranda': (_) => const LoginBerandaPage(),
        '/riwayat': (_) => const RiwayatPage(),
        '/profil': (_) => const ProfilPage(),
        '/masuk': (_) => const MasukPage(),
        '/pengaturan': (_) => const PengaturanPage(),
        '/ubah-profil': (_) => const UbahProfilPage(),
        '/usher-main': (_) => const UsherMainPage(),
        '/usher-absen': (_) => const UsherAbsenPage(),
      },
    );
  }
}
