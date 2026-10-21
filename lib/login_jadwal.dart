import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class LoginJadwalPage extends StatefulWidget {
  const LoginJadwalPage({super.key, this.namaJemaat = 'Daniel Susanto'});

  final String namaJemaat;

  @override
  State<LoginJadwalPage> createState() => _LoginJadwalPageState();
}

class _LoginJadwalPageState extends State<LoginJadwalPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Text(
                'Jadwal tugas',
                style: TextStyle(
                  color: _ink,
                  fontSize: 17,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Row(
              children: [
                _buildTab('Tugas saya', 0, badge: '4'),
                _buildTab('Semua kegiatan', 1),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 16),
                child: _selectedTab == 0
                    ? _buildMySchedule()
                    : _buildAllActivities(),
              ),
            ),
            const AppBottomNavigation(
              currentIndex: 1,
              homeRoute: '/login-beranda',
              isLoggedIn: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, {String? badge}) {
    final selected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? _teal : const Color(0xFFE5EBEB),
                width: selected ? 1.5 : 0.8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selected ? _ink : _muted,
                  fontSize: 8,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF1F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: _teal,
                      fontSize: 6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minggu ini',
          style: TextStyle(
            color: _ink,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        _scheduleCard(
          day: 'Min',
          date: '18',
          title: 'Usher, Ibadah Umum 1',
          detail: '07.00, datang 06.30. Pintu utama',
          subtitle: 'bersama Yosua Lim',
          isUpcoming: true,
        ),
        const SizedBox(height: 12),
        const Text(
          'Berikutnya',
          style: TextStyle(
            color: _ink,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        _scheduleCard(
          day: 'Min',
          date: '25',
          title: 'Multimedia, Ibadah Umum 2',
          detail: '09.30, operator slide & live stream',
        ),
        _scheduleCard(
          day: 'Sab',
          date: '8',
          month: 'Nov',
          title: 'Usher, Ibadah Umum 1',
          detail: '07.00, pintu samping bersama Natalia Sari',
        ),
        _scheduleCard(
          day: 'Sab',
          date: '22',
          month: 'Nov',
          title: 'Multimedia, Ibadah Pemuda',
          detail: '18.00, operator slide',
          showBottomBorder: true,
        ),
        const SizedBox(height: 10),
        _buildNotice(),
      ],
    );
  }

  Widget _scheduleCard({
    required String day,
    required String date,
    required String title,
    required String detail,
    String? month,
    String? subtitle,
    bool isUpcoming = false,
    bool showBottomBorder = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: const BorderSide(color: Color(0xFFE0E8E8)),
          right: const BorderSide(color: Color(0xFFE0E8E8)),
          top: const BorderSide(color: Color(0xFFE0E8E8)),
          bottom: showBottomBorder
              ? const BorderSide(color: Color(0xFFE0E8E8))
              : BorderSide.none,
        ),
        borderRadius: showBottomBorder ? BorderRadius.circular(10) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 44,
            decoration: BoxDecoration(
              color: isUpcoming ? _teal : const Color(0xFFEEF3F3),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month ?? day,
                  style: TextStyle(
                    color: isUpcoming ? Colors.white : _muted,
                    fontSize: 6,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: isUpcoming ? Colors.white : _ink,
                    fontSize: 10,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
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
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle == null ? detail : '$detail\n$subtitle',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 6,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D9),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF9E771D), size: 12),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Berhalangan? Beritahu sekretariat paling lambat Jumat sebelum hari tugas.',
              style: TextStyle(
                color: Color(0xFF8B681B),
                fontSize: 7,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Semua kegiatan',
          style: TextStyle(
            color: _ink,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        _scheduleCard(
          day: 'Min',
          date: '18',
          month: 'Okt',
          title: 'Ibadah Raya',
          detail: '07.00, 09.30 • Umum 1, Umum 2, dan Anak (SM)',
          showBottomBorder: true,
        ),
        _scheduleCard(
          day: 'Sab',
          date: '17',
          month: 'Okt',
          title: 'Ibadah Pemuda',
          detail: '18.00 • Aula gereja',
          showBottomBorder: true,
        ),
      ],
    );
  }
}
