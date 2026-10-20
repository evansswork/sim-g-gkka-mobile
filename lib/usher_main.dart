import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';
import 'usher_absen.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class UsherMainPage extends StatelessWidget {
  const UsherMainPage({super.key});

  static const _services = [
    (
      time: '07.00',
      title: 'Ibadah Umum 1',
      subtitle: 'Pintu utama, sedang berlangsung',
      date: 'Minggu, 18 Oktober',
      isActive: true,
    ),
    (
      time: '09.30',
      title: 'Ibadah Umum 2',
      subtitle: 'Tidak bertugas, boleh membantu',
      date: 'Minggu, 18 Oktober',
      isActive: false,
    ),
    (
      time: '09.30',
      title: 'Sekolah Minggu',
      subtitle: 'Absensi dicatat guru SM',
      date: 'Minggu, 18 Oktober',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 10, 9, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.person_pin_circle_outlined,
                      color: Color(0xFF9E771D),
                      size: 14,
                    ),
                    SizedBox(width: 7),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Anda bertugas hari ini',
                            style: TextStyle(
                              color: Color(0xFF8B681B),
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Akses usher berakhir pukul 23.59',
                            style: TextStyle(
                              color: Color(0xFF9A7A36),
                              fontSize: 7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(9, 0, 9, 7),
              child: Text(
                'Pilih kegiatan',
                style: TextStyle(
                  color: _ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E8E8)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < _services.length;
                        index++
                      ) ...[
                        _serviceRow(context, _services[index]),
                        if (index < _services.length - 1)
                          const Divider(height: 1, indent: 8, endIndent: 8),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(9, 9, 9, 12),
              child: Text(
                'Kehadiran yang terlewat bisa ditambahkan sekretariat lewat web admin.',
                style: TextStyle(color: _muted, fontSize: 7, height: 1.35),
              ),
            ),
            const Spacer(),
            const AppBottomNavigation(currentIndex: 0, isLoggedIn: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 2, 9, 2),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back, size: 17),
            color: _ink,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 4),
          const Text(
            'Mode usher',
            style: TextStyle(
              color: _ink,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceRow(
    BuildContext context,
    ({String time, String title, String subtitle, String date, bool isActive})
    service,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => UsherAbsenPage(
              serviceTitle: service.title,
              serviceDate: service.date,
              serviceTime: service.time,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 29,
                height: 31,
                decoration: BoxDecoration(
                  color: service.isActive ? _teal : const Color(0xFFEEF3F3),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Min',
                      style: TextStyle(
                        color: service.isActive ? Colors.white : _muted,
                        fontSize: 6,
                      ),
                    ),
                    Text(
                      service.time,
                      style: TextStyle(
                        color: service.isActive ? Colors.white : _ink,
                        fontSize: 9,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: TextStyle(
                        color: service.isActive ? _ink : _muted,
                        fontSize: 8,
                        fontWeight: service.isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.subtitle,
                      style: const TextStyle(color: _muted, fontSize: 7),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _muted, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
