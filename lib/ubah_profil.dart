import 'package:flutter/material.dart';

const _ink = Color(0xFF102D2F);
const _teal = Color(0xFF008080);
const _muted = Color(0xFF708384);
const _page = Color(0xFFF3F7F7);

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
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 3, 10, 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 10),
                      _buildField(
                        label: 'Nama lengkap',
                        controller: _nameController,
                        validator: (value) => _required(value, 'Nama lengkap'),
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        label: 'No. HP',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => _required(value, 'No. HP'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Dipakai untuk masuk dan pengingat tugas.',
                          style: TextStyle(color: _muted, fontSize: 7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (!value.contains('@')) {
                            return 'Masukkan alamat email yang valid.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        label: 'Tanggal lahir',
                        controller: _birthDateController,
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.calendar_month_outlined,
                          color: _muted,
                          size: 15,
                        ),
                        onTap: _selectBirthDate,
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        label: 'Alamat',
                        controller: _addressController,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: _page,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lock_outline, color: _muted, size: 13),
                            SizedBox(width: 7),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Diatur sekretariat',
                                    style: TextStyle(
                                      color: _ink,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Komunitas, keahlian, dan peran tidak bisa diubah dari aplikasi.',
                                    style: TextStyle(
                                      color: _muted,
                                      fontSize: 7,
                                      height: 1.35,
                                    ),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 9),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE8EEEE))),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 34,
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _teal,
                      textStyle: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Simpan perubahan'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Ubah profil',
            style: TextStyle(
              color: _ink,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Kembali',
              icon: const Icon(Icons.arrow_back, size: 17),
              color: _ink,
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    int maxLines = 1,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(9)),
      borderSide: BorderSide(color: Color(0xFFD8E1E2)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _ink,
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: onTap,
          validator: validator,
          style: const TextStyle(color: _ink, fontSize: 9),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 10,
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 34,
              minHeight: 34,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: _teal, width: 1.2),
            ),
            errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Color(0xFFB3261E)),
            ),
            focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(
                color: Color(0xFFB3261E),
                width: 1.2,
              ),
            ),
            errorStyle: const TextStyle(fontSize: 7),
          ),
        ),
      ],
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

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Perubahan profil berhasil disimpan.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    Navigator.of(context).pop();
  }
}
