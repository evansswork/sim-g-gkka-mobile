import 'package:flutter/material.dart';

import 'features/auth/auth_service.dart';
import 'isian_no_hp.dart';
import 'tema.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final _formKey = GlobalKey<FormState>();
  final _noHpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _pakaiEmail = false; // tab: false = No. HP, true = Email
  String _kodeNegara = '+62';
  bool _obscurePassword = true;
  bool _sedangLogin = false;

  @override
  void dispose() {
    _noHpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.permukaan,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TombolKembali(),
                ),
                const SizedBox(height: 20),
                const Text('Masuk', style: Teks.judulBesar),
                const SizedBox(height: 8),
                Text(
                  'Masuk dengan no. HP atau email yang Anda pakai saat mendaftar.',
                  style: Teks.isi.copyWith(color: Warna.teksKedua),
                ),
                const SizedBox(height: 12),
                TabGaris(
                  label: const ['No. HP', 'Email'],
                  aktif: _pakaiEmail ? 1 : 0,
                  onTap: (i) => setState(() => _pakaiEmail = i == 1),
                ),
                const SizedBox(height: 20),
                if (_pakaiEmail)
                  IsianForm(
                    label: 'Email',
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Email wajib diisi.';
                        }
                        return null;
                      },
                    ),
                  )
                else
                  IsianForm(
                    label: 'No. HP',
                    child: IsianNoHp(
                      kodeNegara: _kodeNegara,
                      onKodeNegara: (kode) =>
                          setState(() => _kodeNegara = kode),
                      controller: _noHpController,
                    ),
                  ),
                const SizedBox(height: 20),
                IsianForm(
                  label: 'Kata sandi',
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    style: Teks.isi,
                    decoration: gayaInput(
                      hint: 'Masukkan kata sandi',
                      ikon: Icons.lock_outline,
                      suffix: IconButton(
                        tooltip: _obscurePassword
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
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
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi wajib diisi.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TautanTeks(
                    'Lupa kata sandi?',
                    onTap: () => tampilkanPesan(
                      context,
                      'Hubungi sekretariat gereja untuk bantuan '
                      'mengatur ulang kata sandi.',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: Teks.isi.copyWith(color: Warna.teksKedua),
                    ),
                    TautanTeks(
                      'Daftar',
                      onTap: () => Navigator.of(context).pushNamed('/daftar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanpa akun Anda tetap bisa melihat jadwal dan mengisi evaluasi.',
                  textAlign: TextAlign.center,
                  style: Teks.sub.copyWith(color: Warna.teksPudar),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BilahBawah(
        child: TombolMobile(
          _sedangLogin ? 'Memproses...' : 'Masuk',
          onPressed: _sedangLogin ? null : _submit,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_sedangLogin) return;
    if (!_formKey.currentState!.validate()) return;

    // no. HP dikirim lengkap dengan kode negara ("+62" + "812..."), backend yang merapikan
    final identifier = _pakaiEmail
        ? _emailController.text.trim()
        : gabungNoHp(_kodeNegara, _noHpController.text);
    final password = _passwordController.text;

    setState(() => _sedangLogin = true);
    try {
      await AuthService.login(identifier, password);
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login-beranda', (_) => false);
    } catch (pesan) {
      if (mounted) tampilkanPesan(context, '$pesan');
    }
    if (mounted) setState(() => _sedangLogin = false);
  }
}
