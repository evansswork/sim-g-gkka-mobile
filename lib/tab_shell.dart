import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';
import 'beranda.dart';
import 'evaluasi.dart';
import 'features/auth/auth_service.dart';
import 'jadwal.dart';
import 'login_beranda.dart';
import 'login_jadwal.dart';
import 'login_profil.dart';
import 'login_riwayat.dart';
import 'profil.dart';
import 'riwayat.dart';
import 'usher_main.dart';

// kerangka 5 tab. IndexedStack menyimpan semua tab, jadi pindah tab
// tidak membuat ulang halaman (scroll, filter, dan data tetap).
// Tab baru dibangun saat pertama kali dibuka, supaya app lebih ringan saat start.
class TabShell extends StatefulWidget {
  const TabShell({required this.sudahLogin, this.tabAwal = 0, super.key});

  final bool sudahLogin;
  final int tabAwal;

  static void pindah(BuildContext context, int tab) =>
      context.findAncestorStateOfType<_TabShellState>()?._pindah(tab);

  @override
  State<TabShell> createState() => _TabShellState();
}

class _TabShellState extends State<TabShell> {
  late int _tab = widget.tabAwal;
  // tab yang sudah pernah dibuka; yang belum diganti kotak kosong
  late final Set<int> _sudahDibuka = {widget.tabAwal};
  // navigator khusus tab beranda jemaat, supaya mode usher tetap punya tab bar
  final _navBeranda = GlobalKey<NavigatorState>();

  void _pindah(int tab) {
    // evaluasi = google form layar penuh, bukan isi tab
    if (tab == 3) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => EvaluasiPage(sudahLogin: widget.sudahLogin),
        ),
      );
      return;
    }
    if (tab == 0 && _tab == 0) {
      _navBeranda.currentState?.popUntil((r) => r.isFirst);
    }
    setState(() {
      _tab = tab;
      _sudahDibuka.add(tab);
    });
  }

  Widget _tabBeranda(Widget beranda) {
    return NavigatorPopHandler(
      onPopWithResult: (_) => _navBeranda.currentState?.maybePop(),
      child: Navigator(
        key: _navBeranda,
        onGenerateRoute: (s) => MaterialPageRoute<void>(
          settings: s,
          builder: (_) =>
              s.name == '/usher-main' ? const UsherMainPage() : beranda,
        ),
      ),
    );
  }

  List<Widget> get _halaman {
    if (!widget.sudahLogin) {
      return const [
        BerandaPage(),
        JadwalPage(),
        RiwayatPage(),
        SizedBox.shrink(),
        ProfilPage(),
      ];
    }
    final user = AuthService.userLogin;
    return [
      _tabBeranda(
        user == null
            ? const LoginBerandaPage()
            : LoginBerandaPage(
                namaJemaat: user.namaDepan,
                namaLengkap: user.nama,
              ),
      ),
      const LoginJadwalPage(),
      const LoginRiwayatPage(),
      const SizedBox.shrink(),
      user == null
          ? const LoginProfilPage()
          : LoginProfilPage(
              namaJemaat: user.nama,
              nomorAnggota: user.kodeJemaat,
              pelayanan: user.keahlian,
            ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          for (final (i, halaman) in _halaman.indexed)
            _sudahDibuka.contains(i) ? halaman : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _tab,
        onTap: _pindah,
      ),
    );
  }
}
