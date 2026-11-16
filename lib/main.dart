import 'package:flutter/material.dart';

import 'core/api.dart';
import 'daftar.dart';
import 'features/auth/auth_service.dart';
import 'ganti_kata_sandi.dart';
import 'masuk.dart';
import 'pengaturan.dart';
import 'splash.dart';
import 'tab_shell.dart';
import 'tema.dart';
import 'ubah_profil.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Api.saatSesiHabis = () {
    AuthService.userLogin = null;
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/beranda',
      (_) => false,
    );
  };

  // cek sesi dijalankan di dalam splash supaya animasi langsung tampil
  runApp(const MainApp(sudahLogin: true));
}

class MainApp extends StatelessWidget {
  // default true supaya widget test langsung membuka beranda jemaat
  const MainApp({super.key, this.sudahLogin = true, this.denganSplash = false});

  final bool sudahLogin;
  final bool denganSplash;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: ukuranTeks,
      builder: (context, ukuran, _) => MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: temaAplikasi(),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          final skala = mq.textScaler.scale(1) * skalaUkuranTeks[ukuran]!;
          return MediaQuery(
            data: mq.copyWith(textScaler: TextScaler.linear(skala)),
            child: child!,
          );
        },
        home: denganSplash
            ? const SplashPage()
            : TabShell(sudahLogin: sudahLogin),
        routes: {
          '/beranda': (_) => const TabShell(sudahLogin: false),
          '/login-beranda': (_) => const TabShell(sudahLogin: true),
          '/masuk': (_) => const MasukPage(),
          '/ganti-kata-sandi': (_) => const GantiKataSandiPage(),
          '/daftar': (_) => const DaftarPage(),
          '/pengaturan': (context) => PengaturanPage(
            anggotaPelayanan:
                ModalRoute.of(context)?.settings.arguments as bool? ?? true,
          ),
          '/ubah-profil': (_) => const UbahProfilPage(),
        },
      ),
    );
  }
}
