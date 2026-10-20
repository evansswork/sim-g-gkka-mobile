import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gkka_mobile/main.dart';

Future<void> _openTab(WidgetTester tester, String label) async {
  await tester.pumpWidget(const MainApp());
  tester
      .state<NavigatorState>(find.byType(Navigator).first)
      .pushNamed('/beranda');
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _openGuestHome(WidgetTester tester) async {
  await tester.pumpWidget(const MainApp());
  tester
      .state<NavigatorState>(find.byType(Navigator).first)
      .pushNamed('/beranda');
  await tester.pumpAndSettle();
}

Future<void> _expectLoginOpens(WidgetTester tester) async {
  await tester.tap(find.text('Masuk').last);
  await tester.pumpAndSettle();
  expect(
    find.text('Gunakan no. HP yang terdaftar di sekretariat gereja.'),
    findsOneWidget,
  );
}

void main() {
  testWidgets('beranda ditampilkan saat aplikasi dimulai', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Shalom, Daniel'), findsOneWidget);
    expect(find.text('Hidup yang Berbuah'), findsOneWidget);
    expect(find.text('Buka mode usher'), findsOneWidget);
  });

  testWidgets('tombol Masuk membuka halaman login', (tester) async {
    await _openGuestHome(tester);
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(
      find.text('Gunakan no. HP yang terdaftar di sekretariat gereja.'),
      findsOneWidget,
    );
    expect(find.text('No. HP'), findsOneWidget);
    expect(find.text('Kata sandi'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Shalom'), findsOneWidget);
  });

  testWidgets('login mewajibkan nomor HP dan kata sandi', (tester) async {
    await _openGuestHome(tester);
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk').last);
    await tester.pumpAndSettle();

    expect(find.text('No. HP wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
  });

  testWidgets('jadwal tamu memiliki tombol masuk', (tester) async {
    await _openTab(tester, 'Jadwal');
    expect(find.text('Belum ada tugas pelayanan'), findsOneWidget);
    await _expectLoginOpens(tester);
  });

  testWidgets('semua kegiatan juga menyediakan tombol masuk', (tester) async {
    await _openTab(tester, 'Jadwal');
    await tester.tap(find.text('Semua kegiatan'));
    await tester.pumpAndSettle();

    expect(find.text('Ibadah Raya'), findsOneWidget);
    await _expectLoginOpens(tester);
  });

  testWidgets('riwayat tamu memiliki tombol masuk', (tester) async {
    await _openTab(tester, 'Riwayat');
    expect(find.text('Riwayat masih kosong'), findsOneWidget);
    await _expectLoginOpens(tester);
  });

  testWidgets('profil tamu memiliki tombol masuk', (tester) async {
    await _openTab(tester, 'Profil');
    expect(find.text('Tamu'), findsOneWidget);
    await _expectLoginOpens(tester);
  });

  testWidgets('beranda jemaat menampilkan nama dan menu akun', (tester) async {
    await tester.pumpWidget(const MainApp());
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .pushNamed('/login-beranda');
    await tester.pumpAndSettle();

    expect(find.text('Shalom, Daniel'), findsOneWidget);
    expect(find.text('Anda: Usher'), findsOneWidget);
    expect(find.text('Buka mode usher'), findsOneWidget);
    expect(find.text('Isi evaluasi'), findsOneWidget);
    expect(find.byTooltip('Masuk'), findsNothing);

    await tester.tap(find.byIcon(Icons.notifications_none));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada notifikasi baru.'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();
    expect(find.text('Daniel Susanto'), findsOneWidget);
  });

  testWidgets('tab jadwal membuka jadwal jemaat', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Jadwal').last);
    await tester.pumpAndSettle();

    expect(find.text('Jadwal tugas'), findsOneWidget);
    expect(find.text('Usher, Ibadah Umum 1'), findsWidgets);
    expect(find.textContaining('Berhalangan?'), findsOneWidget);
  });

  testWidgets('jadwal jemaat dapat melihat semua kegiatan', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Jadwal').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Semua kegiatan'));
    await tester.pumpAndSettle();

    expect(find.text('Ibadah Raya'), findsOneWidget);
    expect(find.text('Ibadah Pemuda'), findsOneWidget);
  });

  testWidgets('tab riwayat menampilkan kehadiran dan daftar kegiatan', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Riwayat').last);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Bulan ini Anda hadir 1 kali dan bertugas 3 kali. '
        'Terima kasih sudah melayani.',
      ),
      findsOneWidget,
    );
    expect(find.text('Semua riwayat'), findsOneWidget);
    expect(find.text('Ibadah Umum 1'), findsWidgets);
  });

  testWidgets('filter riwayat menyaring daftar kegiatan', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Riwayat').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Semua kegiatan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pelayanan'));
    await tester.pumpAndSettle();

    expect(find.text('Tugas: Usher'), findsOneWidget);
    expect(find.text('Tugas: Multimedia'), findsWidgets);
    expect(find.text('Kasih Mula-mula'), findsNothing);
  });

  testWidgets('tab profil menampilkan informasi jemaat dan tombol keluar', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    expect(find.text('Daniel Susanto'), findsOneWidget);
    expect(find.text('Komunitas Anda'), findsOneWidget);
    expect(find.text('Pelayanan yang dapat diikuti'), findsOneWidget);
    expect(find.text('Ganti kata sandi'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('tombol pengaturan di profil membuka halaman pengaturan', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();

    expect(find.text('Pengingat tugas pelayanan'), findsOneWidget);
    expect(find.text('Pengingat ibadah Minggu'), findsOneWidget);
    expect(find.text('Ukuran teks'), findsOneWidget);
    expect(find.text('Ubah profil'), findsOneWidget);
  });

  testWidgets('tombol ubah profil di pengaturan membuka formulir', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ubah profil'));
    await tester.pumpAndSettle();

    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('No. HP'), findsOneWidget);
    expect(find.text('Tanggal lahir'), findsOneWidget);
    expect(find.text('Simpan perubahan'), findsOneWidget);
  });

  testWidgets('form ubah profil memvalidasi nama dan nomor HP', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ubah profil'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();

    expect(find.text('Nama lengkap wajib diisi.'), findsOneWidget);
    expect(find.text('No. HP wajib diisi.'), findsOneWidget);
  });

  testWidgets('mode usher terbuka dari beranda dan menampilkan kegiatan', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Buka mode usher'));
    await tester.pumpAndSettle();

    expect(find.text('Mode usher'), findsOneWidget);
    expect(find.text('Anda bertugas hari ini'), findsOneWidget);
    expect(find.text('Ibadah Umum 1'), findsOneWidget);
    expect(find.text('Ibadah Umum 2'), findsOneWidget);
    expect(find.text('Sekolah Minggu'), findsOneWidget);
  });

  testWidgets('memilih ibadah umum membuka absensi kegiatan yang dipilih', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Buka mode usher'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ibadah Umum 2'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Ketuk baris untuk mencatat. HP bergerak sebagai tanda tercatat.',
      ),
      findsOneWidget,
    );
    expect(find.text('Ibadah Umum 2'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Belum hadir'), findsOneWidget);
    expect(find.text('Hadir'), findsOneWidget);
    expect(find.text('Agnes Natalia'), findsOneWidget);
  });

  testWidgets('usher dapat mencatat dan membatalkan kehadiran', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Buka mode usher'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ibadah Umum 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Agnes Natalia'));
    await tester.pumpAndSettle();

    expect(find.text('Agnes Natalia tercatat hadir'), findsOneWidget);
    expect(find.text('288'), findsOneWidget);

    await tester.tap(find.text('Batalkan'));
    await tester.pumpAndSettle();

    expect(find.text('Agnes Natalia tercatat hadir'), findsNothing);
    expect(find.text('287'), findsOneWidget);
  });

  testWidgets('usher dapat mencari jemaat', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Buka mode usher'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ibadah Umum 1'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'caroline');
    await tester.pumpAndSettle();

    expect(find.text('Caroline Putri'), findsOneWidget);
    expect(find.text('Agnes Natalia'), findsNothing);
  });
}
