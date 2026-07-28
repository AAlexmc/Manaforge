/// Importar un CSV grande tiene que ENSEÑAR que está trabajando.
///
/// La importación pregunta a la base de cartas fila a fila, y sqlite responde
/// en el mismo hilo: sin ceder el turno, la ventana no repinta ni un frame y
/// parece colgada justo cuando más tarda.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/scan/import_csv_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';

String _csv(int filas) {
  final b = StringBuffer('Name,Quantity\n');
  for (var i = 0; i < filas; i++) {
    b.writeln('Carta inventada $i,1');
  }
  return b.toString();
}

void main() {
  testWidgets('mientras importa se ve una barra que avanza, no una ventana '
      'congelada', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ImportCsvScreen(
        db: CardDatabase(),
        collection: CollectionStore(),
        // en CI no hay base descargada: cada fila se resuelve a una carta de
        // mentira, pero con un await de por medio como el de sqlite
        resolver: (name, id) async => (
          CardHit(
              oracleId: name,
              name: name,
              colors: 'W',
              typeLine: 'Creature',
              manaCost: '{W}',
              cmc: 1,
              setCode: 'tst',
              collectorNumber: '1'),
          false
        ),
      ),
    ));

    // pegar el CSV a mano, que es la vía que no necesita selector de ficheros
    await tester.enterText(find.byType(TextField), _csv(120));
    await tester.pump();

    await tester.tap(find.text('Importar'));
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.textContaining('de 120 cartas'), findsOneWidget);

    // OJO: nada de pumpAndSettle con una barra de progreso viva — no termina
    // nunca. Se avanza a mano hasta que la importación acaba.
    for (var i = 0; i < 40 && find.text('Importar').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('Importar'), findsOneWidget,
        reason: 'al acabar, el botón vuelve a estar disponible');
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
}
