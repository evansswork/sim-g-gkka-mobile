import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _remindersEnabled = true;
  String _textSize = 'Normal';

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
              padding: EdgeInsets.fromLTRB(9, 10, 9, 9),
              child: Text(
                'Profil',
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
                padding: const EdgeInsets.fromLTRB(9, 0, 9, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGuestCard(),
                    const SizedBox(height: 10),
                    _sectionLabel('Pengaturan'),
                    const SizedBox(height: 6),
                    _buildSettingsCard(),
                    const SizedBox(height: 10),
                    _sectionLabel('Bantuan'),
                    const SizedBox(height: 6),
                    _buildHelpCard(),
                  ],
                ),
              ),
            ),
            const AppBottomNavigation(currentIndex: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: _page,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: _muted,
                  size: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamu',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Masuk untuk melihat jadwal tugas dan riwayat kehadiran Anda.',
                      style: TextStyle(color: _muted, fontSize: 7, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LoginButton(),
          const SizedBox(height: 5),
          TextButton(
            onPressed: () =>
                _showMessage('Silakan hubungi sekretariat gereja.'),
            style: TextButton.styleFrom(
              foregroundColor: _teal,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 17),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontSize: 7),
            ),
            child: const Text('Belum punya akun? Hubungi sekretariat'),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(title, style: const TextStyle(color: _muted, fontSize: 7)),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.notifications_none,
            title: 'Pengingat ibadah',
            subtitle: 'Minggu pagi dan saat form evaluasi dibuka',
            trailing: Switch.adaptive(
              value: _remindersEnabled,
              activeTrackColor: _teal,
              onChanged: (value) => setState(() => _remindersEnabled = value),
            ),
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          _SettingsRow(
            icon: Icons.visibility_outlined,
            title: 'Ukuran teks',
            subtitle: _textSize,
            onTap: _showTextSizeOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.chat_bubble_outline,
            title: 'Hubungi sekretariat',
            subtitle: 'WhatsApp 0812-3301-1222',
            onTap: () => _showMessage('WhatsApp: 0812-3301-1222'),
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          _SettingsRow(
            icon: Icons.info_outline,
            title: 'Tentang aplikasi',
            onTap: () => _showInfoDialog(
              'Tentang aplikasi',
              'Aplikasi GKKA Mobile membantu Anda melihat jadwal ibadah, '
                  'riwayat, dan informasi pelayanan gereja.',
            ),
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          _SettingsRow(
            icon: Icons.shield_outlined,
            title: 'Kebijakan privasi',
            onTap: () => _showInfoDialog(
              'Kebijakan privasi',
              'Informasi akun digunakan untuk mendukung layanan gereja. '
                  'Evaluasi ibadah dapat diisi secara anonim.',
            ),
          ),
        ],
      ),
    );
  }

  void _showTextSizeOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final size in ['Normal', 'Besar'])
              ListTile(
                title: Text(size),
                trailing: _textSize == size
                    ? const Icon(Icons.check, color: _teal)
                    : null,
                onTap: () {
                  setState(() => _textSize = size);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
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

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(
          children: [
            Icon(icon, color: _muted, size: 12),
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
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 6,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.chevron_right, color: _muted, size: 14)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
