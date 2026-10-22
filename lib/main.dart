import 'package:flutter/material.dart';

import 'core/api.dart';
import 'features/auth/auth_service.dart';
import 'masuk.dart';
import 'pengaturan.dart';
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

  await AuthService.cekSesi();
  runApp(MainApp(sudahLogin: AuthService.userLogin != null));
}

class MainApp extends StatelessWidget {
  // default true supaya widget test langsung membuka beranda jemaat
  const MainApp({super.key, this.sudahLogin = true});

  final bool sudahLogin;

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
        home: TabShell(sudahLogin: sudahLogin),
        routes: {
          '/beranda': (_) => const TabShell(sudahLogin: false),
          '/login-beranda': (_) => const TabShell(sudahLogin: true),
          '/masuk': (_) => const MasukPage(),
          '/pengaturan': (_) => const PengaturanPage(),
          '/ubah-profil': (_) => const UbahProfilPage(),
        },
      ),
    );
  }
}
