import 'package:bitirme_mobile/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Uygulama açılış smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BitirmeApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(BitirmeApp), findsOneWidget);
  });
}
