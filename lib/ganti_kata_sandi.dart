import 'package:flutter/material.dart';

import 'tema.dart';

class GantiKataSandiPage extends StatefulWidget {
  const GantiKataSandiPage({super.key});

  @override
  State<GantiKataSandiPage> createState() => _GantiKataSandiPageState();
}

class _GantiKataSandiPageState extends State<GantiKataSandiPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _sembunyikanKataSandi = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmationController.dispose();
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
                const HeaderKembali('Ganti kata sandi'),
                const SizedBox(height: 12),
                const Text(
                  'Buat kata sandi baru minimal 8 karakter.',
                  style: Teks.sub,
                ),
                const SizedBox(height: 20),
                _field(
                  label: 'Kata sandi baru',
                  controller: _passwordController,
                  hint: 'Minimal 8 karakter',
                  textInputAction: TextInputAction.next,
                  validator: _validasiKataSandi,
                ),
                const SizedBox(height: 18),
                _field(
                  label: 'Ulangi kata sandi baru',
                  controller: _confirmationController,
                  hint: 'Ketik ulang kata sandi',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ulangi kata sandi baru.';
                    }
                    if (value != _passwordController.text) {
                      return 'Kata sandi tidak sama.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Warna.halus,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Warna.teksKedua,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Form ini memeriksa kecocokan kata sandi. '
                          'Perubahan belum dapat disimpan karena endpoint '
                          'ganti kata sandi untuk pengguna belum tersedia.',
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
        child: TombolMobile('Periksa kata sandi', onPressed: _periksaKataSandi),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    required TextInputAction textInputAction,
    required String? Function(String?) validator,
  }) {
    return IsianForm(
      label: label,
      child: TextFormField(
        controller: controller,
        obscureText: _sembunyikanKataSandi,
        textInputAction: textInputAction,
        autofillHints: const [AutofillHints.newPassword],
        style: Teks.isi,
        decoration: gayaInput(
          hint: hint,
          ikon: Icons.lock_outline,
          suffix: IconButton(
            tooltip: _sembunyikanKataSandi
                ? 'Tampilkan kata sandi'
                : 'Sembunyikan kata sandi',
            onPressed: () =>
                setState(() => _sembunyikanKataSandi = !_sembunyikanKataSandi),
            icon: Icon(
              _sembunyikanKataSandi
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: Warna.teksKedua,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }

  String? _validasiKataSandi(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Kata sandi baru wajib diisi.';
    if (password.length < 8) return 'Minimal 8 karakter.';
    if (password.length > 72) return 'Maksimal 72 karakter.';
    return null;
  }

  void _periksaKataSandi() {
    if (!_formKey.currentState!.validate()) return;

    tampilkanPesan(
      context,
      'Kata sandi cocok, tetapi belum disimpan karena API belum tersedia.',
    );
  }
}
