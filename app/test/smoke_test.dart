import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/main.dart';

void main() {
  testWidgets('la app arranca con las 5 pestañas y el FAB de escanear',
      (tester) async {
    await tester.pumpWidget(const ManaForgeApp());

    // Las 5 pestañas del shell
    expect(find.text('Colección'), findsWidgets);
    expect(find.text('Mazos'), findsOneWidget);
    expect(find.text('Forge'), findsOneWidget);
    expect(find.text('Trades'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);

    // La acción principal de la app, con etiqueta (regla del DesignSystem)
    expect(find.text('Escanear'), findsOneWidget);

    // Navegar a Forge muestra su promesa de producto
    await tester.tap(find.text('Forge'));
    await tester.pumpAndSettle();
    expect(find.textContaining('con las cartas que ya tienes'), findsOneWidget);
  });
}
