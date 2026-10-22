import 'package:flutter/material.dart';

import 'tema.dart';

const _tabs = [
  (label: 'Beranda', icon: Icons.home_outlined),
  (label: 'Jadwal', icon: Icons.calendar_month_outlined),
  (label: 'Riwayat', icon: Icons.history),
  (label: 'Evaluasi', icon: Icons.chat_bubble_outline),
  (label: 'Profil', icon: Icons.person_outline),
];

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Warna.permukaan,
        border: Border(top: BorderSide(color: Warna.garis)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i++) Expanded(child: _item(i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(int i) {
    final aktif = i == currentIndex;
    final warna = aktif ? Warna.brand : Warna.teksPudar;
    return Semantics(
      selected: aktif,
      button: true,
      child: InkWell(
        onTap: () => onTap(i),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_tabs[i].icon, size: 24, color: warna),
              const SizedBox(height: 4),
              Text(_tabs[i].label, style: Teks.tab.copyWith(color: warna)),
            ],
          ),
        ),
      ),
    );
  }
}
