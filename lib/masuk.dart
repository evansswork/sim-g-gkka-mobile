import 'package:flutter/material.dart';

import 'features/auth/auth_service.dart';
import 'tema.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _sedangLogin = false;

  @override
  void dispose() {
    _phoneController.dispose();
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
                  'Gunakan no. HP yang terdaftar di sekretariat gereja.',
                  style: Teks.isi.copyWith(color: Warna.teksKedua),
                ),
                const SizedBox(height: 20),
                IsianForm(
                  label: 'No. HP',
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    style: Teks.isi,
                    decoration: gayaInput(
                      hint: '08xx-xxxx-xxxx',
                      ikon: Icons.chat_bubble_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'No. HP wajib diisi.';
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Warna.halus,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Warna.teksPudar,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Akun dibuat oleh sekretariat. Tanpa akun Anda '
                          'tetap bisa melihat jadwal dan mengisi evaluasi.',
                          style: Teks.sub,
                        ),
                      ),
                    ],
                  ),
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

    // buang spasi & strip: "0812-3456 7890" -> "081234567890"
    final noHp = _phoneController.text.replaceAll(RegExp(r'[\s-]'), '');
    final password = _passwordController.text;

    setState(() => _sedangLogin = true);
    try {
      await AuthService.login(noHp, password);
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login-beranda', (_) => false);
    } catch (pesan) {
      if (mounted) tampilkanPesan(context, '$pesan');
    }
    if (mounted) setState(() => _sedangLogin = false);
  }
}
