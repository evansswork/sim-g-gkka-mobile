import 'package:flutter/material.dart';

class Warna {
  static const teksUtama = Color(0xFF0D1F21);
  static const teksKedua = Color(0xFF445759);
  static const teksPudar = Color(0xFF66787A);
  static const brand = Color(0xFF00777C);
  static const brandKuat = Color(0xFF075E62);
  static const brandTint = Color(0xFFE0F3F2);
  static const kanvas = Color(0xFFF4F7F7);
  static const permukaan = Colors.white;
  static const pudar = Color(0xFFEEF3F3);
  static const halus = Color(0xFFF7FAFA);
  static const garis = Color(0xFFE1E8E8);
  static const garisKuat = Color(0xFFCBD6D6);
  static const bahaya = Color(0xFFB42238);
  static const bahayaTint = Color(0xFFFCE8EB);
  static const peringatan = Color(0xFF8F5F00);
  static const peringatanTint = Color(0xFFFFF4D9);
  static const emas = Color(0xFFC9952B);
  static const emasTeks = Color(0xFF8A6000);
  static const emasTint = Color(0xFFFBF2DD);
  static const gelap = Color(0xFF0D2B2E);
  static const gelapAktif = Color(0xFF17403F);
  static const gelapTeks = Color(0xFFE8F1F1);
  static const gelapPudar = Color(0xFF93AFB1);
}

class Teks {
  static const _f = 'PlusJakartaSans';

  static const judulBesar = TextStyle(
    fontFamily: _f,
    fontSize: 30,
    height: 36 / 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: Warna.teksUtama,
  );
  static const judul = TextStyle(
    fontFamily: _f,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.18,
    color: Warna.teksUtama,
  );
  static const headline = TextStyle(
    fontFamily: _f,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.08,
    color: Warna.teksUtama,
  );
  static const isi = TextStyle(
    fontFamily: _f,
    fontSize: 15,
    height: 22 / 15,
    color: Warna.teksUtama,
  );
  static const isiTebal = TextStyle(
    fontFamily: _f,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w600,
    color: Warna.teksUtama,
  );
  static const sub = TextStyle(
    fontFamily: _f,
    fontSize: 13,
    height: 18 / 13,
    color: Warna.teksPudar,
  );
  static const subTebal = TextStyle(
    fontFamily: _f,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
    color: Warna.teksPudar,
  );
  static const kecil = TextStyle(
    fontFamily: _f,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    color: Warna.teksPudar,
  );
  static const tab = TextStyle(
    fontFamily: _f,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w600,
  );
  static const tombol = TextStyle(
    fontFamily: _f,
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w600,
  );
}

final ukuranTeks = ValueNotifier<String>('Normal');

// satu nilai dipakai profil & pengaturan supaya saklarnya selalu sama
final pengingatTugas = ValueNotifier<bool>(true);
final pengingatIbadah = ValueNotifier<bool>(true);
final pengingatEvaluasi = ValueNotifier<bool>(false);

const skalaUkuranTeks = {
  'Kecil': 0.9,
  'Normal': 1.0,
  'Besar': 1.15,
  'Sangat besar': 1.3,
};

ThemeData temaAplikasi() => ThemeData(
  useMaterial3: true,
  fontFamily: 'PlusJakartaSans',
  scaffoldBackgroundColor: Warna.kanvas,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Warna.brand,
    primary: Warna.brand,
    surface: Warna.permukaan,
  ),
  dividerColor: Warna.garis,
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
);

void tampilkanPesan(BuildContext context, String pesan) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(pesan), duration: const Duration(seconds: 2)),
    );
}

class IsiHalaman extends StatelessWidget {
  const IsiHalaman({required this.children, this.jarak = 16, super.key});

  final List<Widget> children;
  final double jarak;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(height: jarak),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class JudulHalaman extends StatelessWidget {
  const JudulHalaman(this.judul, {this.subjudul, this.aksi, super.key});

  final String judul;
  final String? subjudul;
  final Widget? aksi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul, style: Teks.judulBesar),
                if (subjudul != null) ...[
                  const SizedBox(height: 4),
                  Text(subjudul!, style: Teks.sub),
                ],
              ],
            ),
          ),
          if (aksi != null) ...[const SizedBox(width: 12), aksi!],
        ],
      ),
    );
  }
}

class TombolIkon extends StatelessWidget {
  const TombolIkon({
    required this.ikon,
    required this.onPressed,
    this.tooltip,
    super.key,
  });

  final IconData ikon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(ikon, size: 22),
      style: IconButton.styleFrom(
        backgroundColor: Warna.permukaan,
        foregroundColor: Warna.teksUtama,
        side: const BorderSide(color: Warna.garis),
        fixedSize: const Size(44, 44),
        minimumSize: const Size(44, 44),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class LabelBagian extends StatelessWidget {
  const LabelBagian(this.teks, {this.aksi, this.onAksi, super.key});

  final String teks;
  final String? aksi;
  final VoidCallback? onAksi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Row(
        children: [
          Expanded(child: Text(teks, style: Teks.subTebal)),
          if (aksi != null) TautanTeks(aksi!, onTap: onAksi),
        ],
      ),
    );
  }
}

class JudulBagian extends StatelessWidget {
  const JudulBagian(this.teks, {this.aksi, this.onAksi, super.key});

  final String teks;
  final String? aksi;
  final VoidCallback? onAksi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(child: Text(teks, style: Teks.judul)),
          if (aksi != null) TautanTeks(aksi!, onTap: onAksi),
        ],
      ),
    );
  }
}

class TautanTeks extends StatelessWidget {
  const TautanTeks(this.teks, {this.onTap, super.key});

  final String teks;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(teks, style: Teks.subTebal.copyWith(color: Warna.brand)),
      ),
    );
  }
}

class Kartu extends StatelessWidget {
  const Kartu({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.warna = Warna.permukaan,
    this.bergaris = true,
    this.radius = 16,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color warna;
  final bool bergaris;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bentuk = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: bergaris ? const BorderSide(color: Warna.garis) : BorderSide.none,
    );
    return Material(
      color: warna,
      shape: bentuk,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class GrupList extends StatelessWidget {
  const GrupList({required this.children, this.indent = 50, super.key});

  final List<Widget> children;
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Kartu(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: indent, color: Warna.garis),
            children[i],
          ],
        ],
      ),
    );
  }
}

class BarisList extends StatelessWidget {
  const BarisList({
    required this.judul,
    this.ikon,
    this.subjudul,
    this.trailing,
    this.onTap,
    this.warna = Warna.teksUtama,
    super.key,
  });

  final IconData? ikon;
  final String judul;
  final String? subjudul;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (ikon != null) ...[
              Icon(ikon, size: 22, color: warna),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(judul, style: Teks.isiTebal.copyWith(color: warna)),
                  if (subjudul != null) ...[
                    const SizedBox(height: 2),
                    Text(subjudul!, style: Teks.sub),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Icons.chevron_right, size: 18, color: Warna.teksPudar),
          ],
        ),
      ),
    );
  }
}

enum JenisTombol { utama, kedua, tint, bahaya }

class TombolMobile extends StatelessWidget {
  const TombolMobile(
    this.label, {
    required this.onPressed,
    this.ikon,
    this.jenis = JenisTombol.utama,
    this.tinggi = 50,
    this.lebarPenuh = true,
    super.key,
  });

  final String label;
  final IconData? ikon;
  final VoidCallback? onPressed;
  final JenisTombol jenis;
  final double tinggi;
  final bool lebarPenuh;

  @override
  Widget build(BuildContext context) {
    final (latar, teks, garis) = switch (jenis) {
      JenisTombol.utama => (Warna.brand, Colors.white, null),
      JenisTombol.kedua => (Warna.permukaan, Warna.teksUtama, Warna.garisKuat),
      JenisTombol.tint => (Warna.brandTint, Warna.brandKuat, null),
      JenisTombol.bahaya => (Warna.permukaan, Warna.bahaya, Warna.garisKuat),
    };
    final tombol = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: latar,
        foregroundColor: teks,
        disabledBackgroundColor: latar.withValues(alpha: 0.6),
        disabledForegroundColor: teks,
        minimumSize: Size(0, tinggi),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        textStyle: Teks.tombol,
        side: garis == null ? null : BorderSide(color: garis),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ikon != null) ...[Icon(ikon, size: 20), const SizedBox(width: 8)],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
    return lebarPenuh
        ? SizedBox(width: double.infinity, child: tombol)
        : tombol;
  }
}

enum NadaLencana { brand, netral, peringatan, emas, bahaya, garis }

class Lencana extends StatelessWidget {
  const Lencana(
    this.label, {
    this.nada = NadaLencana.brand,
    this.titik = false,
    super.key,
  });

  final String label;
  final NadaLencana nada;
  final bool titik;

  @override
  Widget build(BuildContext context) {
    final (latar, teks) = switch (nada) {
      NadaLencana.brand => (Warna.brandTint, Warna.brandKuat),
      NadaLencana.netral => (Warna.pudar, Warna.teksKedua),
      NadaLencana.peringatan => (Warna.peringatanTint, Warna.peringatan),
      NadaLencana.emas => (Warna.emasTint, Warna.emasTeks),
      NadaLencana.bahaya => (Warna.bahayaTint, Warna.bahaya),
      NadaLencana.garis => (Warna.permukaan, Warna.teksKedua),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(4),
        border: nada == NadaLencana.garis
            ? Border.all(color: Warna.garisKuat)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titik) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: teks, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Teks.kecil.copyWith(color: teks),
            ),
          ),
        ],
      ),
    );
  }
}

class Chip2 extends StatelessWidget {
  const Chip2(this.label, {this.aktif = false, this.onTap, super.key});

  final String label;
  final bool aktif;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: aktif ? Warna.brandTint : Warna.pudar,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(
            label,
            style: Teks.subTebal.copyWith(
              color: aktif ? Warna.brandKuat : Warna.teksKedua,
            ),
          ),
        ),
      ),
    );
  }
}

class KotakTanggal extends StatelessWidget {
  const KotakTanggal({
    required this.hari,
    required this.tanggal,
    this.aktif = false,
    super.key,
  });

  final String hari;
  final String tanggal;
  final bool aktif;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: aktif ? Warna.brand : Warna.pudar,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hari,
            style: Teks.kecil.copyWith(
              color: aktif ? Colors.white : Warna.teksPudar,
            ),
          ),
          Text(
            tanggal,
            style: Teks.judul.copyWith(
              color: aktif ? Colors.white : Warna.teksUtama,
            ),
          ),
        ],
      ),
    );
  }
}

class TabGaris extends StatelessWidget {
  const TabGaris({
    required this.label,
    required this.aktif,
    required this.onTap,
    this.angka = const {},
    super.key,
  });

  final List<String> label;
  final int aktif;
  final ValueChanged<int> onTap;
  final Map<int, String> angka;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Warna.garis)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < label.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                child: Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == aktif ? Warna.brand : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          label[i],
                          textAlign: TextAlign.center,
                          style: i == aktif
                              ? Teks.isiTebal
                              : Teks.isi.copyWith(color: Warna.teksKedua),
                        ),
                      ),
                      if (angka[i] != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Warna.brandTint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            angka[i]!,
                            style: Teks.kecil.copyWith(color: Warna.brandKuat),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KotakKosong extends StatelessWidget {
  const KotakKosong({
    required this.ikon,
    required this.judul,
    required this.keterangan,
    this.aksi,
    super.key,
  });

  final IconData ikon;
  final String judul;
  final String keterangan;
  final Widget? aksi;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _GarisPutus(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: Warna.permukaan,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Warna.pudar,
                shape: BoxShape.circle,
              ),
              child: Icon(ikon, size: 24, color: Warna.teksPudar),
            ),
            const SizedBox(height: 10),
            Text(judul, textAlign: TextAlign.center, style: Teks.headline),
            const SizedBox(height: 10),
            Text(keterangan, textAlign: TextAlign.center, style: Teks.sub),
            if (aksi != null) ...[const SizedBox(height: 24), aksi!],
          ],
        ),
      ),
    );
  }
}

class _GarisPutus extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cat = Paint()
      ..color = Warna.garisKuat
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final jalur = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(16),
        ).deflate(0.5),
      );
    for (final m in jalur.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 7) {
        canvas.drawPath(m.extractPath(d, d + 4), cat);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

InputDecoration gayaInput({String? hint, IconData? ikon, Widget? suffix}) {
  OutlineInputBorder garis(Color warna, [double tebal = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: warna, width: tebal),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: Teks.isi.copyWith(color: Warna.teksPudar),
    prefixIcon: ikon == null
        ? null
        : Icon(ikon, size: 20, color: Warna.teksKedua),
    suffixIcon: suffix,
    filled: true,
    fillColor: Warna.permukaan,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: garis(Warna.garisKuat),
    enabledBorder: garis(Warna.garisKuat),
    focusedBorder: garis(Warna.brand, 2),
    errorBorder: garis(Warna.bahaya),
    focusedErrorBorder: garis(Warna.bahaya, 2),
    errorStyle: Teks.kecil.copyWith(color: Warna.bahaya),
  );
}

class IsianForm extends StatelessWidget {
  const IsianForm({required this.label, required this.child, super.key});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Teks.subTebal.copyWith(color: Warna.teksKedua)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class BilahBawah extends StatelessWidget {
  const BilahBawah({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Warna.permukaan,
        border: Border(top: BorderSide(color: Warna.garis)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: child,
        ),
      ),
    );
  }
}

class TombolKembali extends StatelessWidget {
  const TombolKembali({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      tooltip: 'Kembali',
      icon: const Icon(Icons.arrow_back, size: 22, color: Warna.teksUtama),
      style: IconButton.styleFrom(fixedSize: const Size(44, 44)),
    );
  }
}

class HeaderKembali extends StatelessWidget {
  const HeaderKembali(this.judul, {super.key});

  final String judul;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TombolKembali(),
        const SizedBox(width: 8),
        Expanded(child: Text(judul, style: Teks.headline)),
      ],
    );
  }
}

class Saklar extends StatelessWidget {
  const Saklar({required this.nilai, required this.onChanged, super.key});

  final bool nilai;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: nilai,
      onChanged: onChanged,
      activeTrackColor: Warna.brand,
      activeThumbColor: Colors.white,
      inactiveTrackColor: Warna.garisKuat,
      inactiveThumbColor: Colors.white,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}

void pilihUkuranTeks(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final ukuran in skalaUkuranTeks.keys)
            ListTile(
              title: Text(ukuran, style: Teks.isi),
              trailing: ukuranTeks.value == ukuran
                  ? const Icon(Icons.check, color: Warna.brand)
                  : null,
              onTap: () {
                ukuranTeks.value = ukuran;
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    ),
  );
}

class BarisPengingat extends StatelessWidget {
  const BarisPengingat({
    required this.judul,
    required this.subjudul,
    required this.nilai,
    this.ikon,
    super.key,
  });

  final String judul;
  final String subjudul;
  final ValueNotifier<bool> nilai;
  final IconData? ikon;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: nilai,
      builder: (context, aktif, _) => BarisList(
        ikon: ikon,
        judul: judul,
        subjudul: subjudul,
        trailing: Saklar(nilai: aktif, onChanged: (v) => nilai.value = v),
      ),
    );
  }
}
