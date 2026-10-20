import 'package:flutter/material.dart';

const _tabRoutes = <String?>[
  '/beranda',
  '/jadwal',
  '/riwayat',
  null,
  '/profil',
];

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.currentIndex,
    this.homeRoute = '/beranda',
    this.isLoggedIn = false,
    super.key,
  });

  final int currentIndex;
  final String homeRoute;
  final bool isLoggedIn;

  String? _routeForTab(int index) {
    if (index == 0) return homeRoute;
    if (!isLoggedIn) return _tabRoutes[index];

    return switch (index) {
      1 => '/login-jadwal',
      2 => '/login-riwayat',
      4 => '/login-profil',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (label: 'Beranda', icon: Icons.home_outlined, active: Icons.home),
      (
        label: 'Jadwal',
        icon: Icons.calendar_month_outlined,
        active: Icons.calendar_month,
      ),
      (label: 'Riwayat', icon: Icons.history, active: Icons.history),
      (label: 'Evaluasi', icon: Icons.article_outlined, active: Icons.article),
      (label: 'Profil', icon: Icons.person_outline, active: Icons.person),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E8E8))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 51,
          child: Row(
            children: [
              for (var index = 0; index < tabs.length; index++)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      final route = _routeForTab(index);
                      if (route != null && index != currentIndex) {
                        Navigator.of(context).pushReplacementNamed(route);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          currentIndex == index
                              ? tabs[index].active
                              : tabs[index].icon,
                          size: 19,
                          color: currentIndex == index
                              ? const Color(0xFF006F77)
                              : const Color(0xFF657879),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tabs[index].label,
                          style: TextStyle(
                            color: currentIndex == index
                                ? const Color(0xFF006F77)
                                : const Color(0xFF657879),
                            fontSize: 8,
                            fontWeight: currentIndex == index
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, this.label = 'Masuk'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: FilledButton(
        onPressed: () => Navigator.of(context).pushNamed('/masuk'),
        style: FilledButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF008080),
          textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}
