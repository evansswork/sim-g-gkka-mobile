import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

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
              padding: EdgeInsets.fromLTRB(9, 10, 9, 10),
              child: Text(
                'Riwayat',
                style: TextStyle(
                  color: _ink,
                  fontSize: 17,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(9, 0, 9, 16),
                child: Column(
                  children: [
                    _buildAttendanceCard(),
                    const SizedBox(height: 9),
                    _buildEmptyState(),
                  ],
                ),
              ),
            ),
            const AppBottomNavigation(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 10, 9, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ibadah Minggu, Oktober',
            style: TextStyle(
              color: _ink,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              for (final date in ['4 Okt', '11 Okt', '18 Okt', '25 Okt'])
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE1E8E8)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: const TextStyle(color: _muted, fontSize: 7),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 9),
          const Text(
            'Kehadiran Anda di setiap ibadah Minggu tercatat di sini setelah masuk.',
            style: TextStyle(color: _muted, fontSize: 7, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
            child: const Icon(Icons.history, color: _muted, size: 14),
          ),
          const SizedBox(height: 6),
          const Text(
            'Riwayat masih kosong',
            style: TextStyle(
              color: _ink,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Masuk untuk melihat ibadah dan pelayanan yang pernah Anda ikuti.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 7, height: 1.4),
          ),
          const SizedBox(height: 9),
          const LoginButton(),
        ],
      ),
    );
  }
}
