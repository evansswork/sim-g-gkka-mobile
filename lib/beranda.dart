import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';
import 'masuk.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF006F77);
const _page = Color(0xFFF3F7F7);

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildServiceCard(),
                    const SizedBox(height: 11),
                    _buildEvaluationCard(),
                    const SizedBox(height: 11),
                    _buildMinistryCard(),
                    const SizedBox(height: 17),
                    _buildActivitiesHeader(),
                    const SizedBox(height: 9),
                    _buildActivityCard(
                      day: '17',
                      weekday: 'Sab',
                      title: 'Ibadah Pemuda',
                      subtitle: 'Sabtu, 18.00 • Aula gereja',
                    ),
                    const SizedBox(height: 9),
                    _buildActivityCard(
                      day: '18',
                      weekday: 'Min',
                      title: 'Ibadah Raya',
                      subtitle: 'Minggu, 07.00 • Umum 1',
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomNavigation(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shalom',
                style: TextStyle(
                  color: _ink,
                  fontSize: 22,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Jumat, 16 Oktober',
                style: TextStyle(
                  color: _ink.withValues(alpha: 0.58),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const MasukPage()));
          },
          icon: const Icon(Icons.person_outline, size: 16),
          label: const Text('Masuk'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _ink,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFD7E1E2)),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            minimumSize: const Size(0, 34),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Minggu, 18 Oktober',
                  style: TextStyle(
                    color: Color(0xFFF4B544),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'Ibadah Raya',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.68),
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Hidup yang Berbuah',
              style: TextStyle(
                color: Color(0xFFF3F7F7),
                fontSize: 21,
                height: 1.1,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yohanes 15:1-8, Pdt. Samuel Effendi',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: _ServiceTime(time: '07.00', label: 'Umum 1'),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _ServiceTime(time: '09.30', label: 'Umum 2'),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _ServiceTime(time: '09.30', label: 'Anak (SM)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Evaluasi ibadah',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F3F2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Tanpa login',
                  style: TextStyle(
                    color: _teal,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            'Jawaban anonim lewat Google Form, sekitar 2 '
            'menit. Form minggu ini dibuka Minggu 06.00.',
            style: TextStyle(
              color: _ink.withValues(alpha: 0.7),
              fontSize: 9,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: FilledButton.icon(
              onPressed: () =>
                  _showMessage('Pengingat ibadah Minggu telah diaktifkan.'),
              icon: const Icon(Icons.notifications_none, size: 15),
              label: const Text('Ingatkan saya hari Minggu'),
              style: FilledButton.styleFrom(
                foregroundColor: _teal,
                backgroundColor: const Color(0xFFE1F3F2),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinistryCard() {
    return Material(
      color: const Color(0xFFE0F3F2),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: () => _showMessage('Masuk untuk melihat jadwal pelayanan.'),
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 11, 10, 11),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Melayani di gereja?',
                      style: TextStyle(
                        color: _teal,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Masuk untuk melihat jadwal tugas dan riwayat Anda.',
                      style: TextStyle(
                        color: _ink.withValues(alpha: 0.72),
                        fontSize: 9,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: _teal, size: 19),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitiesHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Kegiatan minggu ini',
            style: TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _showMessage('Semua kegiatan minggu ini'),
          style: TextButton.styleFrom(
            foregroundColor: _teal,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 24),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('Semua'),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required String day,
    required String weekday,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 33,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5F5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    color: _ink.withValues(alpha: 0.65),
                    fontSize: 8,
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _ink.withValues(alpha: 0.62),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF829596), size: 18),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class _ServiceTime extends StatelessWidget {
  const _ServiceTime({required this.time, required this.label});

  final String time;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4141),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFFF2F7F6),
              fontSize: 11,
              height: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
