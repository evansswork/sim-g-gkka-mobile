import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class LoginRiwayatPage extends StatefulWidget {
  const LoginRiwayatPage({super.key});

  @override
  State<LoginRiwayatPage> createState() => _LoginRiwayatPageState();
}

class _LoginRiwayatPageState extends State<LoginRiwayatPage> {
  String _filter = 'Semua kegiatan';

  static const _octoberEvents = [
    (
      day: '11',
      weekday: 'Min',
      title: 'Ibadah Umum 1',
      detail: '07.00, Kasih Mula-mula',
      tag: 'Tugas: Usher',
    ),
    (
      day: '10',
      weekday: 'Sab',
      title: 'Ibadah Pemuda',
      detail: '18.00, Identitas Kristen',
      tag: 'Hadir',
    ),
    (
      day: '7',
      weekday: 'Rab',
      title: 'Persekutuan Doa',
      detail: '19.00, Ruang Doa Lt. 2',
      tag: 'Hadir',
    ),
    (
      day: '4',
      weekday: 'Min',
      title: 'Ibadah Umum 1',
      detail: '07.00, Iman yang Bekerja',
      tag: 'Hadir',
    ),
    (
      day: '3',
      weekday: 'Sab',
      title: 'Ibadah Pemuda',
      detail: '18.00, operator slide',
      tag: 'Tugas: Multimedia',
    ),
  ];

  static const _septemberEvents = [
    (
      day: '27',
      weekday: 'Min',
      title: 'Ibadah Umum 2',
      detail: '09.30, Bersyukur dalam Segala Hal',
      tag: 'Tugas: Multimedia',
    ),
    (
      day: '20',
      weekday: 'Min',
      title: 'Ibadah Umum 1',
      detail: '07.00, Hidup dalam Kasih',
      tag: 'Hadir',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Align(
                alignment: Alignment.centerLeft,
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
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAttendanceCard(),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Semua riwayat',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _buildFilterButton(),
                      ],
                    ),
                    const SizedBox(height: 9),
                    _buildMonth('Oktober 2026', '5 kegiatan', _octoberEvents),
                    const SizedBox(height: 10),
                    _buildMonth(
                      'September 2026',
                      '4 kegiatan',
                      _septemberEvents,
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomNavigation(
              currentIndex: 2,
              homeRoute: '/login-beranda',
              isLoggedIn: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard() {
    const dates = [
      (date: '4 Okt', label: 'Hadir', status: 'hadir'),
      (date: '11 Okt', label: 'Usher', status: 'usher'),
      (date: '18 Okt', label: 'Minggu ini', status: 'upcoming'),
      (date: '25 Okt', label: '—', status: 'empty'),
    ];

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
          const SizedBox(height: 8),
          Row(
            children: [
              for (final item in dates)
                Expanded(
                  child: Column(
                    children: [
                      _attendanceMarker(item.status),
                      const SizedBox(height: 4),
                      Text(
                        item.date,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: const TextStyle(color: _muted, fontSize: 6),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Bulan ini Anda hadir 1 kali dan bertugas 3 kali. Terima kasih sudah melayani.',
            style: TextStyle(color: _muted, fontSize: 7, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _attendanceMarker(String status) {
    final isChecked = status == 'hadir';
    final isService = status == 'usher';
    final backgroundColor = isChecked || isService ? _teal : Colors.white;
    final foregroundColor = isChecked || isService ? Colors.white : _teal;

    return Container(
      width: 19,
      height: 19,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isChecked || isService ? _teal : const Color(0xFFD8E2E2),
        ),
      ),
      child: Icon(
        isChecked
            ? Icons.check
            : isService
            ? Icons.volunteer_activism_outlined
            : null,
        color: foregroundColor,
        size: 10,
      ),
    );
  }

  Widget _buildFilterButton() {
    return PopupMenuButton<String>(
      initialValue: _filter,
      onSelected: (value) => setState(() => _filter = value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Semua kegiatan', child: Text('Semua kegiatan')),
        PopupMenuItem(value: 'Ibadah', child: Text('Ibadah')),
        PopupMenuItem(value: 'Pelayanan', child: Text('Pelayanan')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDCE5E5)),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Text(_filter, style: const TextStyle(color: _ink, fontSize: 7)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: _muted, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildMonth(
    String month,
    String count,
    List<
      ({String day, String weekday, String title, String detail, String tag})
    >
    events,
  ) {
    final visibleEvents = events.where((event) {
      if (_filter == 'Ibadah') return event.title.startsWith('Ibadah');
      if (_filter == 'Pelayanan') return event.tag.startsWith('Tugas:');
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                month,
                style: const TextStyle(color: _muted, fontSize: 7),
              ),
            ),
            Text(count, style: const TextStyle(color: _muted, fontSize: 7)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0E8E8)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              for (var index = 0; index < visibleEvents.length; index++) ...[
                _historyRow(visibleEvents[index]),
                if (index < visibleEvents.length - 1)
                  const Divider(height: 1, indent: 8, endIndent: 8),
              ],
              if (visibleEvents.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Tidak ada riwayat untuk kategori ini.',
                    style: TextStyle(color: _muted, fontSize: 7),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _historyRow(
    ({String day, String weekday, String title, String detail, String tag})
    event,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3F3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.weekday,
                  style: const TextStyle(color: _muted, fontSize: 5),
                ),
                Text(
                  event.day,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 9,
                    height: 1.05,
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
                  event.title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.detail,
                  style: const TextStyle(color: _muted, fontSize: 6),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: event.tag.startsWith('Tugas:')
                  ? const Color(0xFFDDF1F0)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.tag,
              style: TextStyle(
                color: event.tag.startsWith('Tugas:') ? _teal : _muted,
                fontSize: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
