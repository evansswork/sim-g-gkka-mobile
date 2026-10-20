import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class LoginProfilPage extends StatefulWidget {
  const LoginProfilPage({
    super.key,
    this.namaJemaat = 'Daniel Susanto',
    this.nomorAnggota = '0218',
  });

  final String namaJemaat;
  final String nomorAnggota;

  @override
  State<LoginProfilPage> createState() => _LoginProfilPageState();
}

class _LoginProfilPageState extends State<LoginProfilPage> {
  bool _remindersEnabled = true;
  String _textSize = 'Normal';

  String get _initials {
    final parts = widget.namaJemaat.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 10, 9, 8),
              child: Row(
                children: [
                  const Expanded(
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
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/pengaturan'),
                    tooltip: 'Pengaturan',
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _ink,
                      side: const BorderSide(color: Color(0xFFE0E8E8)),
                      minimumSize: const Size(27, 27),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(9, 0, 9, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 10),
                    _buildInformationCard(
                      title: 'Komunitas Anda',
                      trailing: 'Diatur sekretariat',
                      chips: const ['Pemuda', 'Wilayah Tenggilis'],
                    ),
                    const SizedBox(height: 8),
                    _buildInformationCard(
                      title: 'Pelayanan yang dapat diikuti',
                      trailing: 'Diatur sekretariat',
                      chips: const ['Usher', 'Multimedia'],
                    ),
                    const SizedBox(height: 10),
                    _sectionLabel('Pengaturan'),
                    const SizedBox(height: 5),
                    _buildSettings(),
                    const SizedBox(height: 10),
                    _sectionLabel('Bantuan'),
                    const SizedBox(height: 5),
                    _buildHelp(),
                    const SizedBox(height: 8),
                    _buildLogoutButton(),
                    const SizedBox(height: 7),
                    const Center(
                      child: Text(
                        'SIM-G GKKA Tenggilis, versi 1.0.0',
                        style: TextStyle(color: _muted, fontSize: 6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomNavigation(
              currentIndex: 4,
              homeRoute: '/login-beranda',
              isLoggedIn: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: const Color(0xFFDDF1F0),
          child: Text(
            _initials,
            style: const TextStyle(
              color: _teal,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.namaJemaat,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Jemaat sejak 2014, no. anggota ${widget.nomorAnggota}',
                style: const TextStyle(color: _muted, fontSize: 6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInformationCard({
    required String title,
    required String trailing,
    required List<String> chips,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                trailing,
                style: const TextStyle(color: _muted, fontSize: 6),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (final chip in chips)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: chip == 'Pemuda' || chip == 'Usher'
                        ? const Color(0xFFEEF3F3)
                        : const Color(0xFFDDF1F0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    chip,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(title, style: const TextStyle(color: _muted, fontSize: 6)),
    );
  }

  Widget _buildSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _ProfileRow(
            icon: Icons.notifications_none,
            title: 'Pengingat jadwal',
            subtitle: 'H-1 dan 2 jam sebelum tugas',
            trailing: Switch.adaptive(
              value: _remindersEnabled,
              activeTrackColor: _teal,
              onChanged: (value) => setState(() => _remindersEnabled = value),
            ),
          ),
          const Divider(height: 1, indent: 8, endIndent: 8),
          _ProfileRow(
            icon: Icons.visibility_outlined,
            title: 'Ukuran teks',
            subtitle: _textSize,
            onTap: _showTextSizeOptions,
          ),
          const Divider(height: 1, indent: 8, endIndent: 8),
          _ProfileRow(
            icon: Icons.lock_outline,
            title: 'Ganti kata sandi',
            onTap: () =>
                _showMessage('Fitur ganti kata sandi akan segera tersedia.'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelp() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _ProfileRow(
            icon: Icons.chat_bubble_outline,
            title: 'Hubungi sekretariat',
            subtitle: 'WhatsApp 0812-3301-1222',
            onTap: () => _showMessage('WhatsApp: 0812-3301-1222'),
          ),
          const Divider(height: 1, indent: 8, endIndent: 8),
          _ProfileRow(
            icon: Icons.info_outline,
            title: 'Tentang aplikasi',
            onTap: () => _showInfo(
              'Tentang aplikasi',
              'Aplikasi GKKA Mobile membantu Anda melihat jadwal ibadah, '
                  'riwayat, dan informasi pelayanan gereja.',
            ),
          ),
          const Divider(height: 1, indent: 8, endIndent: 8),
          _ProfileRow(
            icon: Icons.shield_outlined,
            title: 'Kebijakan privasi',
            onTap: () => _showInfo(
              'Kebijakan privasi',
              'Informasi akun digunakan untuk mendukung layanan gereja. '
                  'Evaluasi ibadah dapat diisi secara anonim.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: _confirmLogout,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E8E8)),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Row(
            children: [
              Icon(Icons.logout, color: Color(0xFFB3261E), size: 12),
              SizedBox(width: 6),
              Text(
                'Keluar',
                style: TextStyle(
                  color: Color(0xFFB3261E),
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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

  void _showInfo(String title, String message) {
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

  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda akan kembali ke beranda tamu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/beranda', (route) => false);
            },
            child: const Text('Keluar'),
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

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          children: [
            Icon(icon, color: _muted, size: 11),
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
                      style: const TextStyle(color: _muted, fontSize: 6),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.chevron_right, color: _muted, size: 13)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
