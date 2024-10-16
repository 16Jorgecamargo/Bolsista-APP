import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bolsista_app/main.dart';

void main() {
  testWidgets('Verifica se a tela inicial carrega com título e botão',
      (WidgetTester tester) async {
    // Carrega o app no teste
    await tester.pumpWidget(const MyApp());

    // Verifica se o título "Lista de Bolsistas" está presente
    expect(find.text('Lista de Bolsistas'), findsOneWidget);

    // Verifica se o botão de adicionar um novo bolsista está presente
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verifica se o CircularProgressIndicator está presente enquanto carrega os bolsistas
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
