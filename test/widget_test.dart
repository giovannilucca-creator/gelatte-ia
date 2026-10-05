import 'package:flutter_test/flutter_test.dart';
import 'package:gelatte_ia/main.dart';

void main() {
  testWidgets('exibe tela de login do Gelatte IA', (tester) async {
    await tester.pumpWidget(const GelatteIA());
    expect(find.text('GELATTE IA'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
