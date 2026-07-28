/// Historial de cartas vistas: una copia restaurada de otra persona no debe
/// poder colar una URL de imagen cualquiera.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/recents_store.dart';

void main() {
  group('RecentCard.fromJson filtra la imagen', () {
    test('URL fuera de Scryfall se queda sin imagen, no la pide', () {
      final card = RecentCard.fromJson(const {
        'o': 'x',
        'n': 'Carta rara',
        'i': 'http://evil/x.png',
        'c': 'U',
      });

      expect(card.imageNormal, isNull);
    });

    test('URL legítima de Scryfall se conserva', () {
      const url = 'https://cards.scryfall.io/normal/front/a/b/abc.jpg';
      final card = RecentCard.fromJson(const {
        'o': 'x',
        'n': 'Carta legítima',
        'i': url,
        'c': 'U',
      });

      expect(card.imageNormal, url);
    });
  });
}
