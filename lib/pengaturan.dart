import 'package:flutter/material.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool _ministryReminder = true;
  bool _sundayReminder = true;
  bool _evaluationReminder = false;
  String _textSize = 'Normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Notifikasi'),
                    const SizedBox(height: 6),
                    _buildNotificationCard(),
                    const SizedBox(height: 14),
                    _sectionLabel('Tampilan'),
                    const SizedBox(height: 6),
                    _buildAppearanceCard(),
                    const SizedBox(height: 14),
                    _sectionLabel('Akun'),
                    const SizedBox(height: 6),
                    _buildAccountCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 2, 10, 5),
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
          const SizedBox(width: 5),
          const Text(
            'Pengaturan',
            style: TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(label, style: const TextStyle(color: _muted, fontSize: 8)),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        children: [
          _NotificationSetting(
            title: 'Pengingat tugas pelayanan',
            subtitle: 'H-1 pukul 19.00 dan 2 jam sebelum tugas',
            value: _ministryReminder,
            onChanged: (value) => setState(() => _ministryReminder = value),
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          _NotificationSetting(
            title: 'Pengingat ibadah Minggu',
            subtitle: 'Minggu pukul 05.30',
            value: _sundayReminder,
            onChanged: (value) => setState(() => _sundayReminder = value),
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          _NotificationSetting(
            title: 'Form evaluasi dibuka',
            subtitle: 'Minggu pukul 06.00',
            value: _evaluationReminder,
            onChanged: (value) => setState(() => _evaluationReminder = value),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard() {
    const sizes = ['Kecil', 'Normal', 'Besar', 'Sangat besar'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ukuran teks',
            style: TextStyle(
              color: _ink,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final size in sizes)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: size == sizes.last ? 0 : 4),
                    child: _textSizeOption(size),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _page,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Contoh\nIbadah Umum 1, Minggu 07.00. Tema: Hidup yang Berbuah.',
              style: TextStyle(
                color: _ink,
                fontSize: switch (_textSize) {
                  'Kecil' => 7,
                  'Besar' => 9,
                  'Sangat besar' => 11,
                  _ => 8,
                },
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textSizeOption(String size) {
    final selected = _textSize == size;
    final previewSize = switch (size) {
      'Kecil' => 9.0,
      'Besar' => 12.0,
      'Sangat besar' => 14.0,
      _ => 11.0,
    };

    return InkWell(
      onTap: () => setState(() => _textSize = size),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 53,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE7F5F4) : Colors.white,
          border: Border.all(
            color: selected ? _teal : const Color(0xFFE0E8E8),
            width: selected ? 1.2 : 0.8,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aa',
              style: TextStyle(
                color: selected ? _teal : _ink,
                fontSize: previewSize,
                height: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                size,
                style: TextStyle(
                  color: selected ? _teal : _muted,
                  fontSize: 6,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _AccountSetting(
            icon: Icons.edit_outlined,
            title: 'Ubah profil',
            onTap: () => Navigator.of(context).pushNamed('/ubah-profil'),
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          _AccountSetting(
            icon: Icons.lock_outline,
            title: 'Ganti kata sandi',
            onTap: () => _showMessage('Fitur ini akan segera tersedia.'),
          ),
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

class _NotificationSetting extends StatelessWidget {
  const _NotificationSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 3, 5, 3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: _teal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _AccountSetting extends StatelessWidget {
  const _AccountSetting({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        child: Row(
          children: [
            Icon(icon, color: _muted, size: 13),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: _muted, size: 15),
          ],
        ),
      ),
    );
  }
}
