import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/auth/auth_service.dart';
import 'tab_shell.dart';
import 'tema.dart';

/// Splash animasi saat aplikasi pertama dibuka.
///
/// Konsep: cahaya yang turun ke ruang ibadah.
/// Seberkas cahaya emas turun dari atas layar -> menjadi batang tegak salib ->
/// batang datar melebar -> cahaya fajar merekah + satu gelombang seperti bunyi lonceng ->
/// nama gereja muncul dari balik garis. Cek sesi login berjalan bersamaan.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _masuk = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  // gerak pelan selama menunggu sesi: cahaya bernapas + garis loader
  late final AnimationController _tunggu = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  bool _menungguSesi = false;

  Animation<double> _rentang(
    double mulai,
    double selesai, [
    Curve c = Curves.easeOutCubic,
  ]) => CurvedAnimation(
    parent: _masuk,
    curve: Interval(mulai, selesai, curve: c),
  );

  late final _sinar = _rentang(0.00, 0.28, Curves.easeInCubic); // berkas turun
  late final _tegak = _rentang(0.24, 0.44, Curves.easeOutCubic);
  late final _datar = _rentang(0.40, 0.58, Curves.easeOutBack);
  late final _fajar = _rentang(0.44, 0.85, Curves.easeOut);
  late final _gelombang = _rentang(0.50, 0.90, Curves.easeOutCubic);
  late final _judul = _rentang(0.62, 0.84, Curves.easeOutQuart);
  late final _subjudul = _rentang(0.74, 0.96);

  @override
  void initState() {
    super.initState();
    _mulai();
  }

  Future<void> _mulai() async {
    final sesi = AuthService.cekSesi();

    // pengguna yang mematikan animasi di HP langsung lihat keadaan akhir
    final tanpaAnimasi = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (tanpaAnimasi) {
      _masuk.value = 1;
    } else {
      await _masuk.forward();
    }
    if (!mounted) return;

    setState(() => _menungguSesi = true);
    if (!tanpaAnimasi) _tunggu.repeat(reverse: true);
    await sesi;
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, _, _) =>
            TabShell(sudahLogin: AuthService.userLogin != null),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _masuk.dispose();
    _tunggu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Warna.gelap,
        body: SizedBox.expand(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF081E20), Warna.gelap, Color(0xFF0B3B3E)],
                stops: [0, 0.5, 1],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, ukuran) {
                // titik tengah salib sedikit di atas tengah layar
                final pusat = Offset(
                  ukuran.maxWidth / 2,
                  ukuran.maxHeight * 0.40,
                );
                return AnimatedBuilder(
                  animation: Listenable.merge([_masuk, _tunggu]),
                  builder: (context, _) => Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _CahayaSalib(
                            pusat: pusat,
                            sinar: _sinar.value,
                            tegak: _tegak.value,
                            datar: _datar.value,
                            fajar: _fajar.value,
                            gelombang: _gelombang.value,
                            napas: _tunggu.value,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        top: pusat.dy + 104,
                        child: _namaGereja(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Opacity(
                              opacity: _subjudul.value * 0.7,
                              child: Text(
                                'SIM-G',
                                textAlign: TextAlign.center,
                                style: Teks.kecil.copyWith(
                                  color: Warna.gelapPudar,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaGereja() {
    final judul = _judul.value;
    final subjudul = _subjudul.value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "GKKA" naik dari balik garis tak terlihat (dipotong ClipRect)
        ClipRect(
          child: Transform.translate(
            offset: Offset(0, 44 * (1 - judul)),
            child: Opacity(
              opacity: judul,
              child: Text(
                'GKKA',
                style: Teks.judulBesar.copyWith(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  letterSpacing: lerpDouble(10, 6, judul),
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Opacity(
          opacity: subjudul,
          child: Text(
            'Tenggilis',
            style: Teks.isi.copyWith(
              color: Warna.emas,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              letterSpacing: lerpDouble(4, 1.5, subjudul),
            ),
          ),
        ),
        const SizedBox(height: 28),
        AnimatedOpacity(
          opacity: _menungguSesi ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: _GarisMemuat(posisi: _tunggu.value),
        ),
      ],
    );
  }
}

/// Loader: seberkas cahaya kecil yang bergeser bolak-balik di atas garis tipis.
class _GarisMemuat extends StatelessWidget {
  const _GarisMemuat({required this.posisi});

  final double posisi;

  @override
  Widget build(BuildContext context) {
    const lebar = 56.0;
    const lebarCahaya = 18.0;
    final kiri = Curves.easeInOut.transform(posisi) * (lebar - lebarCahaya);
    return SizedBox(
      width: lebar,
      height: 2,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Warna.gelapPudar.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Positioned(
            left: kiri,
            width: lebarCahaya,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Warna.emas,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CahayaSalib extends CustomPainter {
  _CahayaSalib({
    required this.pusat,
    required this.sinar,
    required this.tegak,
    required this.datar,
    required this.fajar,
    required this.gelombang,
    required this.napas,
  });

  final Offset pusat;
  final double sinar;
  final double tegak;
  final double datar;
  final double fajar;
  final double gelombang;
  final double napas;

  static const _setengahTinggi = 62.0;
  static const _setengahLebar = 42.0;
  static const _naikDatar = 22.0; // batang datar sedikit di atas tengah

  @override
  void paint(Canvas canvas, Size size) {
    final atas = pusat.translate(0, -_setengahTinggi);
    final bawah = pusat.translate(0, _setengahTinggi);

    // 1. cahaya fajar merekah dari belakang salib
    if (fajar > 0) {
      final radius = size.width * (0.35 + 0.55 * fajar) + 10 * napas;
      canvas.drawCircle(
        pusat,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Warna.emas.withValues(alpha: (0.30 + 0.05 * napas) * fajar),
              Warna.emas.withValues(alpha: 0.08 * fajar),
              Warna.emas.withValues(alpha: 0),
            ],
            stops: const [0, 0.4, 1],
          ).createShader(Rect.fromCircle(center: pusat, radius: radius)),
      );
    }

    // 2. berkas cahaya turun dari atas layar, memudar saat salib terbentuk
    if (sinar > 0 && tegak < 1) {
      final ujung = Offset(atas.dx, atas.dy * sinar);
      canvas.drawLine(
        Offset(atas.dx, 0),
        ujung,
        Paint()
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..shader =
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Warna.emas.withValues(alpha: 0),
                  Warna.emas.withValues(alpha: 0.9 * (1 - tegak)),
                ],
              ).createShader(
                Rect.fromPoints(
                  Offset(atas.dx - 1, 0),
                  ujung + const Offset(1, 1),
                ),
              ),
      );
    }

    // 3. satu gelombang melebar, seperti bunyi lonceng
    if (gelombang > 0 && gelombang < 1) {
      canvas.drawCircle(
        pusat,
        lerpDouble(70, 190, gelombang)!,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Warna.emas.withValues(alpha: 0.45 * (1 - gelombang)),
      );
    }

    // 4. salib: pendar emas di bawah, garis putih di atas
    final garisSalib = Path();
    if (tegak > 0) {
      garisSalib
        ..moveTo(atas.dx, atas.dy)
        ..lineTo(atas.dx, lerpDouble(atas.dy, bawah.dy, tegak)!);
    }
    if (datar > 0) {
      final y = pusat.dy - _naikDatar;
      final lebar = _setengahLebar * datar;
      garisSalib
        ..moveTo(pusat.dx - lebar, y)
        ..lineTo(pusat.dx + lebar, y);
    }

    canvas.drawPath(
      garisSalib,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..color = Warna.emas.withValues(alpha: 0.55 * fajar)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawPath(
      garisSalib,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_CahayaSalib old) =>
      old.pusat != pusat ||
      old.sinar != sinar ||
      old.tegak != tegak ||
      old.datar != datar ||
      old.fajar != fajar ||
      old.gelombang != gelombang ||
      old.napas != napas;
}
