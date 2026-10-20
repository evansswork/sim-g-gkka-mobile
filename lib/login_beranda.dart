import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _page = Color(0xFFF3F7F7);
const _muted = Color(0xFF708384);

class LoginBerandaPage extends StatelessWidget {
  const LoginBerandaPage({super.key, this.namaJemaat = 'Daniel'});

  final String namaJemaat;

  String get _inisial {
    final names = namaJemaat.trim().split(RegExp(r'\s+'));
    if (names.isEmpty || names.first.isEmpty) return '?';
    if (names.length == 1) return names.first.characters.first.toUpperCase();
    return '${names.first.characters.first}${names.last.characters.first}'
        .toUpperCase();
  }

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
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 12),
                    _buildServiceCard(),
                    const SizedBox(height: 10),
                    _buildMinistryCard(context),
                    const SizedBox(height: 10),
                    _buildEvaluationCard(context),
                  ],
                ),
              ),
            ),
            const AppBottomNavigation(
              currentIndex: 0,
              homeRoute: '/login-beranda',
              isLoggedIn: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shalom, $namaJemaat',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 18,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Minggu, 18 Oktober',
                style: TextStyle(
                  color: _ink.withValues(alpha: 0.6),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => _showNotifications(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0E8E8)),
            ),
            child: const Icon(Icons.notifications_none, color: _ink, size: 15),
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed('/login-profil'),
          borderRadius: BorderRadius.circular(20),
          child: CircleAvatar(
            radius: 13,
            backgroundColor: const Color(0xFFDDF1F0),
            child: Text(
              _inisial,
              style: const TextStyle(
                color: _teal,
                fontSize: 7,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Hari ini, Minggu 18 Oktober',
                  style: TextStyle(
                    color: Color(0xFFF4B544),
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'Ibadah Raya',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Hidup yang Berbuah',
            style: TextStyle(
              color: Color(0xFFF3F7F7),
              fontSize: 18,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Yohanes 15:1-8, Pdt. Samuel Effendi',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 7,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _serviceTime(time: '07.00', label: 'Umum 1', isAssignment: true),
              const SizedBox(width: 5),
              _serviceTime(time: '09.30', label: 'Umum 2'),
              const SizedBox(width: 5),
              _serviceTime(time: '09.30', label: 'Anak (SM)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceTime({
    required String time,
    required String label,
    bool isAssignment = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF1A4141),
          borderRadius: BorderRadius.circular(8),
          border: isAssignment
              ? Border.all(color: const Color(0xFFF4B544), width: 0.8)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: Color(0xFFF2F7F6),
                fontSize: 10,
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
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 7,
                ),
              ),
            ),
            if (isAssignment) ...[
              const SizedBox(height: 2),
              const FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Anda: Usher',
                  style: TextStyle(
                    color: Color(0xFFF4B544),
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMinistryCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0B94C)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF5DF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volunteer_activism_outlined,
                  color: Color(0xFF9E771D),
                  size: 13,
                ),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tugas Anda: Usher, Umum 1',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pintu utama, datang 06.30, bersama Yosua Lim',
                      style: TextStyle(color: _muted, fontSize: 7),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 29,
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/usher-main'),
              icon: const Icon(Icons.person_pin_circle_outlined, size: 13),
              label: const Text('Buka mode usher'),
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: _teal,
                textStyle: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(11),
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
                    fontSize: 8,
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
                  'Sudah dibuka',
                  style: TextStyle(
                    color: _teal,
                    fontSize: 6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Form minggu ini sudah dibuka. Isi setelah ibadah, paling lambat Selasa 23.59.',
            style: TextStyle(color: _muted, fontSize: 7, height: 1.35),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 29,
            child: FilledButton.icon(
              onPressed: () => _showMessage(
                context,
                'Form evaluasi ibadah akan segera tersedia.',
              ),
              icon: const Icon(Icons.chat_bubble_outline, size: 12),
              label: const Text('Isi evaluasi'),
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: _teal,
                textStyle: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifikasi'),
        content: const Text('Belum ada notifikasi baru.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
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
