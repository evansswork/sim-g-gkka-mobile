import 'package:flutter/material.dart';

import 'tema.dart';

class UbahProfilPage extends StatefulWidget {
  const UbahProfilPage({super.key});

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Daniel Susanto');
  final _phoneController = TextEditingController(text: '0812-3301-447');
  final _emailController = TextEditingController(
    text: 'daniel.susanto@gmail.com',
  );
  final _birthDateController = TextEditingController(text: '14 Maret 1999');
  final _addressController = TextEditingController(
    text: 'Jl. Tenggilis Mejoyo AA-12',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
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
                const Row(
                  children: [
                    TombolKembali(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ubah profil',
                        textAlign: TextAlign.center,
                        style: Teks.headline,
                      ),
                    ),
                    SizedBox(width: 52),
                  ],
                ),
                const SizedBox(height: 18),
                _isian(
                  label: 'Nama lengkap',
                  controller: _nameController,
                  validator: (value) => _required(value, 'Nama lengkap'),
                ),
                const SizedBox(height: 18),
                _isian(
                  label: 'No. HP',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => _required(value, 'No. HP'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dipakai untuk masuk dan pengingat tugas.',
                  style: Teks.kecil,
                ),
                const SizedBox(height: 18),
                _isian(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (!value.contains('@')) {
                      return 'Masukkan alamat email yang valid.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _isian(
                  label: 'Tanggal lahir',
                  controller: _birthDateController,
                  readOnly: true,
                  suffix: const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Warna.teksKedua,
                  ),
                  onTap: _selectBirthDate,
                ),
                const SizedBox(height: 18),
                _isian(label: 'Alamat', controller: _addressController),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Warna.halus,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: Warna.teksKedua,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diatur sekretariat',
                              style: Teks.subTebal.copyWith(
                                color: Warna.teksKedua,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Komunitas, keahlian, dan peran tidak bisa '
                              'diubah dari aplikasi.',
                              style: Teks.sub,
                            ),
                          ],
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
        child: TombolMobile('Simpan perubahan', onPressed: _save),
      ),
    );
  }

  Widget _isian({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    Widget? suffix,
    VoidCallback? onTap,
  }) {
    return IsianForm(
      label: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        style: Teks.isi,
        decoration: gayaInput(suffix: suffix),
      ),
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    return null;
  }

  Future<void> _selectBirthDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1999, 3, 14),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (selectedDate == null) return;

    const months = [
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
    _birthDateController.text =
        '${selectedDate.day} ${months[selectedDate.month - 1]} '
        '${selectedDate.year}';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    tampilkanPesan(context, 'Perubahan profil berhasil disimpan.');
    Navigator.of(context).pop();
  }
}
