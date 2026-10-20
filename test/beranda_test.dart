import 'package:flutter_test/flutter_test.dart';
import 'package:gkka_mobile/main.dart';

void main() {
  testWidgets('beranda ditampilkan saat aplikasi dimulai', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Shalom'), findsOneWidget);
    expect(find.text('Hidup yang Berbuah'), findsOneWidget);
    expect(find.text('Kegiatan minggu ini'), findsOneWidget);
  });

  testWidgets('tombol Masuk membuka halaman login', (tester) async {
    await tester.pumpWidget(const MainApp());
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
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk').last);
    await tester.pumpAndSettle();

    expect(find.text('No. HP wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
  });
}
