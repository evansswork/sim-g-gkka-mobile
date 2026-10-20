import 'package:flutter/material.dart';

import 'app_bottom_navigation.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

class UsherAbsenPage extends StatefulWidget {
  const UsherAbsenPage({
    super.key,
    this.serviceTitle = 'Ibadah Umum 1',
    this.serviceDate = 'Minggu, 18 Okt',
    this.serviceTime = '07.00',
  });

  final String serviceTitle;
  final String serviceDate;
  final String serviceTime;

  @override
  State<UsherAbsenPage> createState() => _UsherAbsenPageState();
}

class _UsherAbsenPageState extends State<UsherAbsenPage> {
  final _searchController = TextEditingController();
  final List<_Congregant> _congregants = [
    _Congregant(
      name: 'Agnes Natalia',
      community: 'Kaum Wanita',
      initials: 'AN',
    ),
    _Congregant(
      name: 'Albert Sutanto',
      community: 'Wil. Rungkut',
      initials: 'AS',
    ),
    _Congregant(
      name: 'Andreas Wijaya',
      community: 'Hadir 07.12',
      initials: 'AW',
      isPresent: true,
    ),
    _Congregant(name: 'Benny Kurniadi', community: 'Lansia', initials: 'BK'),
    _Congregant(name: 'Caroline Putri', community: 'Pemuda', initials: 'CP'),
    _Congregant(name: 'Christian Halim', community: 'Pemuda', initials: 'CH'),
  ];

  String? _lastMarkedName;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _presentCount =>
      286 + _congregants.where((item) => item.isPresent).length;

  List<_Congregant> get _filteredCongregants {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _congregants;
    return _congregants
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final attendees = _filteredCongregants;

    return Scaffold(
      backgroundColor: _page,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummary(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(9, 7, 9, 5),
                    child: Text(
                      'Ketuk baris untuk mencatat. HP bergerak sebagai tanda tercatat.',
                      style: TextStyle(color: _muted, fontSize: 7),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(9, 0, 9, 5),
                      itemCount: attendees.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 1),
                      itemBuilder: (context, index) =>
                          _buildAttendeeRow(attendees[index]),
                    ),
                  ),
                  _buildBottomActions(),
                ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 2, 9, 4),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.serviceTitle,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${widget.serviceDate}, ${widget.serviceTime}',
                  style: const TextStyle(color: _muted, fontSize: 6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final absentCount = 789 - _presentCount;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(9, 2, 9, 6),
          child: Row(
            children: [
              Icon(Icons.circle, color: _teal, size: 6),
              SizedBox(width: 5),
              Text(
                'Tersinkron, 3 usher lain aktif. Anda mencatat 94.',
                style: TextStyle(color: _muted, fontSize: 7),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFE1E9E9)),
              bottom: BorderSide(color: Color(0xFFE1E9E9)),
            ),
          ),
          child: Row(
            children: [
              _stat('789', 'Semua', selected: true),
              _stat('$absentCount', 'Belum hadir'),
              _stat('$_presentCount', 'Hadir'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stat(String value, String label, {bool selected = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: selected ? _ink : _muted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected ? _teal : _muted,
              fontSize: 7,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (selected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 32,
              height: 1.5,
              color: _teal,
            ),
        ],
      ),
    );
  }

  Widget _buildAttendeeRow(_Congregant attendee) {
    return Material(
      color: attendee.isPresent ? const Color(0xFFDDF1F0) : Colors.white,
      child: InkWell(
        onTap: () => _toggleAttendance(attendee),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFFDDF1F0),
                child: Text(
                  attendee.initials,
                  style: const TextStyle(
                    color: _teal,
                    fontSize: 6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attendee.name,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      attendee.isPresent && attendee.name == 'Andreas Wijaya'
                          ? 'Hadir 07.12'
                          : attendee.community,
                      style: const TextStyle(color: _muted, fontSize: 6),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: attendee.isPresent ? _teal : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: attendee.isPresent ? _teal : const Color(0xFFD8E1E2),
                    width: 1,
                  ),
                ),
                child: attendee.isPresent
                    ? const Icon(Icons.check, color: Colors.white, size: 13)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 4, 7, 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_lastMarkedName != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _ink,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF8AD8D3),
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '$_lastMarkedName tercatat hadir',
                      style: const TextStyle(color: Colors.white, fontSize: 7),
                    ),
                  ),
                  TextButton(
                    onPressed: _undoLastAttendance,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF8AD8D3),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: const Size(0, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(fontSize: 7),
                    ),
                    child: const Text('Batalkan'),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 30,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: _ink, fontSize: 8),
              decoration: InputDecoration(
                hintText: 'Cari nama jemaat...',
                hintStyle: const TextStyle(color: _muted, fontSize: 8),
                prefixIcon: const Icon(Icons.search, color: _muted, size: 14),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 7),
                filled: true,
                fillColor: const Color(0xFFEEF3F3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleAttendance(_Congregant attendee) {
    setState(() {
      attendee.isPresent = !attendee.isPresent;
      _lastMarkedName = attendee.isPresent ? attendee.name : null;
    });
  }

  void _undoLastAttendance() {
    final name = _lastMarkedName;
    if (name == null) return;

    setState(() {
      for (final attendee in _congregants) {
        if (attendee.name == name) {
          attendee.isPresent = false;
          break;
        }
      }
      _lastMarkedName = null;
    });
  }
}

class _Congregant {
  _Congregant({
    required this.name,
    required this.community,
    required this.initials,
    this.isPresent = false,
  });

  final String name;
  final String community;
  final String initials;
  bool isPresent;
}
