import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:studylog/main.dart';
import 'package:studylog/providers/catatan_store.dart';

void main() {
  testWidgets('Aplikasi StudyLog dapat dimuat tanpa error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CatatanStore(),
        child: const StudyLogApp(),
      ),
    );

    expect(find.byType(StudyLogApp), findsOneWidget);
  });
}
