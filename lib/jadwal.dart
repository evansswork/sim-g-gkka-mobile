import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
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
              padding: EdgeInsets.fromLTRB(9, 10, 9, 15),
              child: Text(
                'Jadwal',
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
                _buildTab('Tugas saya', 0),
                _buildTab('Semua kegiatan', 1),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(9, 10, 9, 16),
                child: _selectedTab == 0
                    ? _buildEmptyState(
                        icon: Icons.event_note_outlined,
                        title: 'Belum ada tugas pelayanan',
                        description:
                            'Jadwal tugas Anda muncul di sini setelah '
                            'masuk. Jadwal ibadah tetap bisa dilihat di tab '
                            'Semua kegiatan.',
                      )
                    : _buildAllActivities(),
              ),
            ),
            const AppBottomNavigation(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _teal : const Color(0xFFE3EAEA),
                width: isSelected ? 1.5 : 0.8,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? _ink : _muted,
              fontSize: 8,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD7E1E2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: _page,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _muted, size: 13),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, fontSize: 7, height: 1.4),
          ),
          const SizedBox(height: 9),
          const LoginButton(),
        ],
      ),
    );
  }

  Widget _buildAllActivities() {
    return Column(
      children: [
        _activityCard(
          day: '18',
          date: 'Minggu, 18 Oktober',
          title: 'Ibadah Raya',
          detail: '07.00, 09.30 • Umum 1, Umum 2, dan Anak (SM)',
        ),
        const SizedBox(height: 8),
        _activityCard(
          day: '17',
          date: 'Sabtu, 17 Oktober',
          title: 'Ibadah Pemuda',
          detail: '18.00 • Aula gereja',
        ),
        const SizedBox(height: 10),
        const LoginButton(),
      ],
    );
  }

  Widget _activityCard({
    required String day,
    required String date,
    required String title,
    required String detail,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Container(
            width: 33,
            height: 36,
            decoration: BoxDecoration(
              color: _page,
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: const TextStyle(
                color: _ink,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(color: _muted, fontSize: 7)),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
