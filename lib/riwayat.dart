import 'package:flutter/material.dart';

import 'tema.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsiHalaman(
        children: [
          const JudulHalaman('Riwayat'),
          const KartuHadirMinggu(
            minggu: [
              (tanggal: '4 Okt', status: StatusHadir.kosong),
              (tanggal: '11 Okt', status: StatusHadir.kosong),
              (tanggal: '18 Okt', status: StatusHadir.kosong),
              (tanggal: '25 Okt', status: StatusHadir.kosong),
            ],
            keterangan:
                'Kehadiran Anda di setiap ibadah Minggu tercatat di sini '
                'setelah masuk.',
          ),
          KotakKosong(
            ikon: Icons.history,
            judul: 'Riwayat masih kosong',
            keterangan: 'Masuk untuk melihat ibadah dan pelayanan yang pernah Anda ikuti.',
            aksi: TombolMobile(
              'Masuk',
              onPressed: () => Navigator.of(context).pushNamed('/masuk'),
            ),
          ),
        ],
      ),
    );
  }
}

enum StatusHadir { kosong, hadir, usher, mingguIni, nanti }

class KartuHadirMinggu extends StatelessWidget {
  const KartuHadirMinggu({
    required this.minggu,
    required this.keterangan,
    super.key,
  });

  final List<({String tanggal, StatusHadir status})> minggu;
  final String keterangan;

  @override
  Widget build(BuildContext context) {
    return Kartu(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ibadah Minggu, Oktober', style: Teks.headline),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < minggu.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _item(minggu[i])),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(keterangan, style: Teks.sub.copyWith(color: Warna.teksKedua)),
        ],
      ),
    );
  }

  Widget _item(({String tanggal, StatusHadir status}) m) {
    final (label, warnaLabel) = switch (m.status) {
      StatusHadir.hadir => ('Hadir', Warna.teksPudar),
      StatusHadir.usher => ('Usher', Warna.brandKuat),
      StatusHadir.mingguIni => ('Minggu ini', Warna.teksPudar),
      _ => ('—', Warna.teksPudar),
    };
    final pudar =
        m.status == StatusHadir.kosong || m.status == StatusHadir.nanti;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          _lingkaran(m.status),
          const SizedBox(height: 8),
          Text(
            m.tanggal,
            style: Teks.subTebal.copyWith(
              color: pudar ? Warna.teksPudar : Warna.teksUtama,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Teks.kecil.copyWith(color: warnaLabel),
          ),
        ],
      ),
    );
  }

  Widget _lingkaran(StatusHadir s) {
    return switch (s) {
      StatusHadir.hadir => _bulat(
        Warna.brandTint,
        const Icon(Icons.check, size: 16, color: Warna.brandKuat),
      ),
      StatusHadir.usher => _bulat(
        Warna.brand,
        const Icon(Icons.how_to_reg_outlined, size: 16, color: Colors.white),
      ),
      StatusHadir.mingguIni => _bulat(null, null, garis: Warna.brand),
      StatusHadir.nanti => _bulat(null, null, garis: Warna.garisKuat),
      StatusHadir.kosong => CustomPaint(
        painter: _LingkaranPutus(),
        child: const SizedBox(width: 32, height: 32),
      ),
    };
  }

  Widget _bulat(Color? isi, Widget? ikon, {Color? garis}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isi,
        shape: BoxShape.circle,
        border: garis == null ? null : Border.all(color: garis),
      ),
      child: ikon,
    );
  }
}

class _LingkaranPutus extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cat = Paint()
      ..color = Warna.garisKuat
      ..style = PaintingStyle.stroke;
    final jalur = Path()..addOval((Offset.zero & size).deflate(0.5));
    for (final m in jalur.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 6) {
        canvas.drawPath(m.extractPath(d, d + 3), cat);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
