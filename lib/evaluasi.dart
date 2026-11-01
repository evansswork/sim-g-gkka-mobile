import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'features/evaluasi/evaluasi_service.dart';
import 'tema.dart';

class EvaluasiPage extends StatefulWidget {
  const EvaluasiPage({this.sudahLogin = false, super.key});

  final bool sudahLogin;

  @override
  State<EvaluasiPage> createState() => _EvaluasiPageState();
}

class _EvaluasiPageState extends State<EvaluasiPage> {
  bool _memuat = true;
  String? _error;
  FormEvaluasi? _form;
  WebViewController? _web;
  // progres muat halaman form (0-100). Pakai ValueNotifier supaya yang digambar ulang
  // hanya garis progres, bukan seluruh halaman beserta WebView-nya
  final _progres = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _ambilForm();
  }

  @override
  void dispose() {
    _progres.dispose();
    super.dispose();
  }

  Future<void> _ambilForm() async {
    setState(() {
      _memuat = true;
      _error = null;
    });
    try {
      final form = await EvaluasiService.ambilForm();
      if (!mounted) return;
      setState(() {
        _form = form;
        _web = form != null && form.menerimaJawaban && form.link.isNotEmpty
            ? _buatWebView(form.link)
            : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _memuat = false);
    }
  }

  WebViewController _buatWebView(String link) {
    return WebViewController()
      // google form butuh javascript untuk validasi dan kirim jawaban
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            _progres.value = p;
          },
          onPageFinished: (url) {
            // halaman "jawaban Anda telah direkam" ada di .../formResponse
            if (url.contains('/formResponse')) _selesai();
          },
        ),
      )
      ..loadRequest(Uri.parse(link));
  }

  void _selesai() {
    if (!mounted) return;
    tampilkanPesan(context, 'Terima kasih, evaluasi Anda sudah terkirim.');
    Navigator.of(context).maybePop();
  }

  void _muatUlang() {
    if (_web != null) {
      _web!.reload();
    } else {
      _ambilForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.permukaan,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            if (_web != null)
              ValueListenableBuilder<int>(
                valueListenable: _progres,
                builder: (context, progres, _) => progres < 100
                    ? LinearProgressIndicator(
                        value: progres / 100,
                        minHeight: 2,
                        color: Warna.brandKuat,
                        backgroundColor: Colors.transparent,
                      )
                    : const SizedBox.shrink(),
              ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF0EBF8),
                child: _isi(),
              ),
            ),
            // keterangan hanya saat form tampil; saat tutup/error kartu di tengah sudah menjelaskan
            if (_web != null)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Warna.garis)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Warna.teksPudar,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _form?.ditutupPada != null
                            ? 'Jawaban anonim. Diisi paling lambat '
                                  '${formatWaktu(_form!.ditutupPada!)}.'
                            : 'Jawaban anonim.',
                        style: Teks.kecil,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _isi() {
    if (_memuat) return const Center(child: CircularProgressIndicator());
    if (_web != null) return WebViewWidget(controller: _web!);
    if (_error != null) {
      return _kartuInfo(
        ikon: Icons.wifi_off_outlined,
        judul: 'Form evaluasi gagal dimuat',
        isi: _error!,
        aksi: TextButton(onPressed: _ambilForm, child: const Text('Coba lagi')),
      );
    }
    // form belum dihubungkan backend, atau di luar jadwal dari sekretariat
    final dibuka = _form?.dibukaPada;
    return _kartuInfo(
      ikon: Icons.description_outlined,
      judul: 'Form evaluasi belum dibuka',
      isi: dibuka == null
          ? 'Jadwal form berikutnya belum diumumkan sekretariat.'
          : 'Form dibuka ${formatWaktu(dibuka)}.',
    );
  }

  Widget _kartuInfo({
    required IconData ikon,
    required String judul,
    required String isi,
    Widget? aksi,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Kartu(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ikon, size: 32, color: Warna.teksPudar),
              const SizedBox(height: 10),
              Text(judul, textAlign: TextAlign.center, style: Teks.headline),
              const SizedBox(height: 6),
              Text(isi, textAlign: TextAlign.center, style: Teks.sub),
              if (aksi != null) ...[const SizedBox(height: 8), aksi],
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    // contoh: Kebaktian Mingguan, 1 Nov 2026 (detail KU ada di header Google Form)
    final dibuka = _form?.dibukaPada;
    final judul = dibuka == null
        ? 'Kebaktian Mingguan'
        : 'Kebaktian Mingguan, ${dibuka.day} ${_bulan[dibuka.month - 1]} ${dibuka.year}';
    // keterangan kecil di bawah judul, hanya saat form Google sedang tampil
    final host = _web != null ? 'Google Form' : '';
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Warna.garis)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Tutup',
            icon: const Icon(Icons.close, size: 22, color: Warna.teksUtama),
            style: IconButton.styleFrom(fixedSize: const Size(44, 44)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Teks.headline,
                ),
                if (host.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 12,
                        color: Warna.teksPudar,
                      ),
                      const SizedBox(width: 4),
                      Text(host, style: Teks.kecil),
                    ],
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _memuat ? null : _muatUlang,
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh, size: 22, color: Warna.teksUtama),
            style: IconButton.styleFrom(fixedSize: const Size(44, 44)),
          ),
        ],
      ),
    );
  }
}

const _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

// contoh: Minggu, 1 Nov pukul 12.00
String formatWaktu(DateTime w) {
  final jam =
      '${w.hour.toString().padLeft(2, '0')}.'
      '${w.minute.toString().padLeft(2, '0')}';
  return '${_hari[w.weekday - 1]}, ${w.day} ${_bulan[w.month - 1]} pukul $jam';
}
