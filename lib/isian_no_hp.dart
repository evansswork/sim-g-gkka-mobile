import 'package:flutter/material.dart';

import 'tema.dart';

// kode negara yang bisa dipilih; default Indonesia
const daftarKodeNegara = [
  ('+62', 'Indonesia'),
  ('+60', 'Malaysia'),
  ('+65', 'Singapura'),
  ('+61', 'Australia'),
  ('+1', 'Amerika / Kanada'),
  ('+44', 'Inggris'),
  ('+31', 'Belanda'),
  ('+49', 'Jerman'),
  ('+81', 'Jepang'),
  ('+82', 'Korea Selatan'),
  ('+86', 'Tiongkok'),
  ('+852', 'Hong Kong'),
  ('+886', 'Taiwan'),
];

// gabungNoHp: "+62" + "0812-3456 7890" -> "+6281234567890" (0 di depan dibuang).
// Backend menyimpan nomor +62 sebagai 0812..., nomor luar negeri tetap dengan +.
String gabungNoHp(String kodeNegara, String nomor) {
  var angka = nomor.replaceAll(RegExp(r'[^0-9]'), '');
  // jemaat mengetik nomor lengkap dengan + ("+6591234567"): pakai apa adanya
  if (nomor.trim().startsWith('+')) return '+$angka';
  angka = angka.replaceFirst(RegExp(r'^0+'), '');
  // jemaat mengetik kode negaranya lagi tanpa + ("62812..."): jangan dobel jadi +6262812...
  final kodeAngka = kodeNegara.substring(1);
  if (angka.startsWith(kodeAngka) && angka.length >= kodeAngka.length + 9) {
    angka = angka.substring(kodeAngka.length);
  }
  return '$kodeNegara$angka';
}

// cekNoHp: validator form, null = benar.
String? cekNoHp(String? nomor) {
  final angka = (nomor ?? '').replaceAll(RegExp(r'[^0-9]'), '');
  if (angka.isEmpty) return 'No. HP wajib diisi.';
  if (angka.length < 7 || angka.length > 15) return 'No. HP tidak valid.';
  return null;
}

// IsianNoHp: pilihan kode negara + kolom nomor.
class IsianNoHp extends StatelessWidget {
  const IsianNoHp({
    required this.kodeNegara,
    required this.onKodeNegara,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.validator = cekNoHp,
    super.key,
  });

  final String kodeNegara;
  final ValueChanged<String> onKodeNegara;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // tombol kode negara, tinggi disamakan dengan kolom isian (52)
        Material(
          color: Warna.permukaan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Warna.garisKuat),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _pilihKodeNegara(context),
            child: SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(kodeNegara, style: Teks.isiTebal),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.expand_more,
                      size: 20,
                      color: Warna.teksKedua,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            textInputAction: textInputAction,
            style: Teks.isi,
            decoration: gayaInput(hint: '812-3456-7890'),
            validator: validator,
          ),
        ),
      ],
    );
  }

  // daftar negara muncul dari bawah layar
  Future<void> _pilihKodeNegara(BuildContext context) async {
    final dipilih = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final (kode, negara) in daftarKodeNegara)
              ListTile(
                title: Text(negara, style: Teks.isi),
                trailing: Text(kode, style: Teks.isiTebal),
                selected: kode == kodeNegara,
                onTap: () => Navigator.of(context).pop(kode),
              ),
          ],
        ),
      ),
    );
    if (dipilih != null) onKodeNegara(dipilih);
  }
}
