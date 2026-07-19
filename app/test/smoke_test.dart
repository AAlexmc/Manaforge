import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/main.dart';

void main() {
  testWidgets('la app arranca con las 7 pestañas', (tester) async {
    await tester.pumpWidget(const ManaForgeApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Colección'), findsWidgets);
    expect(find.text('Álbum'), findsWidgets);
    expect(find.text('Mazos'), findsOneWidget);
    expect(find.text('Forge'), findsOneWidget);
    expect(find.text('Mercado'), findsWidgets);
    expect(find.text('Ajustes'), findsOneWidget);

    // Forge muestra el teaser con contador (colección vacía, sin plugins)
    await tester.tap(find.text('Forge'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('con las cartas que ya tienes'), findsOneWidget);
    expect(find.text('cartas para tu primer mazo'), findsOneWidget);
  });
}
