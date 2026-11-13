import 'package:flutter/material.dart';

import 'features/auth/auth_service.dart';
import 'isian_no_hp.dart';
import 'tema.dart';

// Daftar akun 2 langkah. Setelah berhasil, jemaat langsung masuk dengan status
// "Belum terverifikasi" lalu melengkapi data diri di Profil.
//   Langkah 1 - Akun: nama, no. HP dan/atau email (min. salah satu), kata sandi, konfirmasi
//   Langkah 2 - Data diri: tanggal lahir, jenis kelamin, status di gereja
class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _formLangkah1 = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  int _langkah = 1;
  String _kodeNegara = '+62';
  bool _obscurePassword = true;

  DateTime? _tanggalLahir;
  String? _jenisKelamin; // L / P
  String? _statusGereja; // JEMAAT_GKKA / SIMPATISAN / TAMU
  bool _setujuData = false;
  String? _errorLangkah2;
  bool _sedangDaftar = false;

  static const _pilihanStatusGereja = [
    ('JEMAAT_GKKA', 'Jemaat GKKA'),
    ('SIMPATISAN', 'Simpatisan'),
    ('TAMU', 'Tamu'),
  ];

  @override
  void initState() {
    super.initState();
    // label No. HP / Email ikut berubah (opsional) saat salah satunya diisi
    _noHpController.addListener(_perbaruiLabel);
    _emailController.addListener(_perbaruiLabel);
    // tanda cocok / belum cocok di bawah konfirmasi kata sandi
    _passwordController.addListener(_perbaruiLabel);
    _konfirmasiController.addListener(_perbaruiLabel);
  }

  void _perbaruiLabel() => setState(() {});

  // isian ini opsional hanya selama dirinya masih kosong dan isian lainnya sudah diisi
  bool _opsional(TextEditingController ini, TextEditingController lain) =>
      ini.text.trim().isEmpty && lain.text.trim().isNotEmpty;

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // tombol kembali HP di langkah 2 balik ke langkah 1, bukan keluar halaman
    return PopScope(
      canPop: _langkah == 1,
      onPopInvokedWithResult: (sudahKeluar, _) {
        if (!sudahKeluar) setState(() => _langkah = 1);
      },
      child: Scaffold(
        backgroundColor: Warna.permukaan,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TombolKembali(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Langkah $_langkah dari 2',
                  style: Teks.subTebal.copyWith(color: Warna.brand),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _langkah / 2,
                    minHeight: 6,
                    color: Warna.brand,
                    backgroundColor: Warna.pudar,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _langkah == 1 ? 'Buat akun' : 'Data diri',
                  style: Teks.judulBesar,
                ),
                const SizedBox(height: 8),
                Text(
                  _langkah == 1
                      ? 'Dipakai untuk masuk ke aplikasi.'
                      : 'Data lain bisa dilengkapi nanti di Profil.',
                  style: Teks.isi.copyWith(color: Warna.teksKedua),
                ),
                const SizedBox(height: 20),
                if (_langkah == 1) _isianLangkah1() else _isianLangkah2(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BilahBawah(
          child: _langkah == 1
              ? TombolMobile('Lanjut', onPressed: _lanjut)
              : Row(
                  children: [
                    Expanded(
                      child: TombolMobile(
                        'Kembali',
                        jenis: JenisTombol.kedua,
                        onPressed: _sedangDaftar
                            ? null
                            : () => setState(() => _langkah = 1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TombolMobile(
                        _sedangDaftar ? 'Memproses...' : 'Daftar',
                        onPressed: _sedangDaftar ? null : _daftar,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ================= Langkah 1: akun =================

  Widget _isianLangkah1() {
    return Form(
      key: _formLangkah1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IsianForm(
            label: 'Nama lengkap',
            child: TextFormField(
              controller: _namaController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              style: Teks.isi,
              decoration: gayaInput(
                hint: 'Sesuai KTP',
                ikon: Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama lengkap wajib diisi.';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          // No. HP dan email boleh diisi salah satu atau keduanya;
          // yang satu jadi opsional begitu yang lain sudah diisi
          IsianForm(
            label: _opsional(_noHpController, _emailController)
                ? 'No. HP (opsional)'
                : 'No. HP',
            child: IsianNoHp(
              kodeNegara: _kodeNegara,
              onKodeNegara: (kode) => setState(() => _kodeNegara = kode),
              controller: _noHpController,
              validator: (value) {
                final kosong = (value ?? '').trim().isEmpty;
                if (kosong) {
                  return _emailController.text.trim().isEmpty
                      ? 'Isi No. HP atau email.'
                      : null;
                }
                return cekNoHp(value);
              },
            ),
          ),
          const SizedBox(height: 20),
          IsianForm(
            label: _opsional(_emailController, _noHpController)
                ? 'Email (opsional)'
                : 'Email',
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              style: Teks.isi,
              decoration: gayaInput(
                hint: 'nama@email.com',
                ikon: Icons.mail_outline,
              ),
              validator: (value) {
                final email = (value ?? '').trim();
                if (email.isEmpty) {
                  return _noHpController.text.trim().isEmpty
                      ? 'Isi No. HP atau email.'
                      : null;
                }
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                  return 'Format email tidak valid.';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          IsianForm(
            label: 'Kata sandi',
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              style: Teks.isi,
              decoration: gayaInput(
                hint: 'Minimal 8 karakter',
                ikon: Icons.lock_outline,
                suffix: IconButton(
                  tooltip: _obscurePassword
                      ? 'Tampilkan kata sandi'
                      : 'Sembunyikan kata sandi',
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: Warna.teksKedua,
                  ),
                ),
              ),
              validator: (value) {
                final password = value ?? '';
                if (password.isEmpty) return 'Kata sandi wajib diisi.';
                if (password.length < 8) return 'Minimal 8 karakter.';
                if (password.length > 72) return 'Maksimal 72 karakter.';
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          IsianForm(
            label: 'Konfirmasi kata sandi',
            child: TextFormField(
              controller: _konfirmasiController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _lanjut(),
              style: Teks.isi,
              decoration: gayaInput(
                hint: 'Ketik ulang kata sandi',
                ikon: Icons.lock_outline,
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Kata sandi tidak sama.';
                }
                return null;
              },
            ),
          ),
          if (_konfirmasiController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            _tandaCocok(_konfirmasiController.text == _passwordController.text),
          ],
        ],
      ),
    );
  }

  // muncul saat konfirmasi mulai diketik: hijau-teal kalau sama, merah kalau belum
  Widget _tandaCocok(bool cocok) {
    final warna = cocok ? Warna.brand : Warna.bahaya;
    return Row(
      children: [
        Icon(cocok ? Icons.check_circle : Icons.cancel, size: 18, color: warna),
        const SizedBox(width: 6),
        Text(
          cocok ? 'Kata sandi cocok' : 'Kata sandi belum cocok',
          style: Teks.sub.copyWith(color: warna),
        ),
      ],
    );
  }

  void _lanjut() {
    if (!_formLangkah1.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _langkah = 2);
  }

  // ================= Langkah 2: data diri =================

  Widget _isianLangkah2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IsianForm(
          label: 'Tanggal lahir',
          child: Material(
            color: Warna.permukaan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Warna.garisKuat),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pilihTanggalLahir,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Warna.teksKedua,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _tanggalLahir == null
                            ? 'Pilih tanggal'
                            : _tulisTanggal(_tanggalLahir!),
                        style: _tanggalLahir == null
                            ? Teks.isi.copyWith(color: Warna.teksPudar)
                            : Teks.isi,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        IsianForm(
          label: 'Jenis kelamin',
          child: Row(
            children: [
              Expanded(
                child: _tombolPilihan(
                  'Laki-laki',
                  'L',
                  _jenisKelamin,
                  (v) => _jenisKelamin = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _tombolPilihan(
                  'Perempuan',
                  'P',
                  _jenisKelamin,
                  (v) => _jenisKelamin = v,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        IsianForm(
          label: 'Status di gereja',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (nilai, label) in _pilihanStatusGereja) ...[
                _tombolPilihan(
                  label,
                  nilai,
                  _statusGereja,
                  (v) => _statusGereja = v,
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: _setujuData,
          onChanged: (v) => setState(() => _setujuData = v ?? false),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Warna.brand,
          title: Text(
            'Saya setuju data saya disimpan dan dipakai sekretariat gereja '
            'untuk keperluan pelayanan jemaat.',
            style: Teks.sub,
          ),
        ),
        if (_errorLangkah2 != null) ...[
          const SizedBox(height: 8),
          Text(_errorLangkah2!, style: Teks.sub.copyWith(color: Warna.bahaya)),
        ],
      ],
    );
  }

  // tombol pilihan: aktif = garis + latar warna brand
  Widget _tombolPilihan(
    String label,
    String nilai,
    String? nilaiTerpilih,
    void Function(String) simpan,
  ) {
    final aktif = nilai == nilaiTerpilih;
    return Material(
      color: aktif ? Warna.brandTint : Warna.permukaan,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: aktif ? Warna.brand : Warna.garisKuat,
          width: aktif ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() {
          simpan(nilai);
          _errorLangkah2 = null;
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: aktif
                ? Teks.isiTebal.copyWith(color: Warna.brandKuat)
                : Teks.isi,
          ),
        ),
      ),
    );
  }

  Future<void> _pilihTanggalLahir() async {
    final sekarang = DateTime.now();
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(sekarang.year - 20),
      firstDate: DateTime(1900),
      lastDate: sekarang,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih tanggal lahir',
    );
    if (dipilih != null) {
      setState(() {
        _tanggalLahir = dipilih;
        _errorLangkah2 = null;
      });
    }
  }

  Future<void> _daftar() async {
    if (_sedangDaftar) return;
    final kurang = <String>[
      if (_tanggalLahir == null) 'tanggal lahir',
      if (_jenisKelamin == null) 'jenis kelamin',
      if (_statusGereja == null) 'status di gereja',
    ];
    if (kurang.isNotEmpty) {
      setState(() => _errorLangkah2 = 'Pilih ${kurang.join(', ')}.');
      return;
    }
    if (!_setujuData) {
      setState(
        () => _errorLangkah2 = 'Centang persetujuan data untuk melanjutkan.',
      );
      return;
    }

    setState(() => _sedangDaftar = true);
    try {
      await AuthService.daftar(
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
        noHp: _noHpController.text.trim().isEmpty
            ? ''
            : gabungNoHp(_kodeNegara, _noHpController.text),
        password: _passwordController.text,
        jenisKelamin: _jenisKelamin!,
        tanggalLahir: _formatTanggalApi(_tanggalLahir!),
        statusGereja: _statusGereja!,
      );
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login-beranda', (_) => false);
      tampilkanPesan(
        context,
        'Akun berhasil dibuat. Lengkapi data diri di Profil supaya bisa diverifikasi sekretariat.',
      );
    } catch (pesan) {
      if (mounted) tampilkanPesan(context, '$pesan');
    }
    if (mounted) setState(() => _sedangDaftar = false);
  }

  static const _namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // "17 Mei 2000"
  String _tulisTanggal(DateTime t) =>
      '${t.day} ${_namaBulan[t.month - 1]} ${t.year}';

  // "2000-05-17" untuk backend
  String _formatTanggalApi(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
}
