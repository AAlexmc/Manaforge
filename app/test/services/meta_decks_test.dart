/// Mazos del meta para Modo Test: si el feed no trae ninguno, es tan inútil
/// como no tener red — hay que caer a los presets locales igual.
library;

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manaforge_app/services/meta_decks.dart';

http.Client Function() _clienteQueDevuelve(String body, {int status = 200}) =>
    () => MockClient((_) async => http.Response(body, status));

void main() {
  group('MetaDeckService.load()', () {
    test('un feed con decks vacío cae a los presets, no a lista vacía',
        () async {
      final service = MetaDeckService(
        clientFactory: _clienteQueDevuelve(jsonEncode({
          'source': 'Meta Standard',
          'updated': '2026-07-24',
          'decks': [],
        })),
      );

      final result = await service.load();

      expect(result.decks, metaDecks);
      expect(result.online, isFalse);
    });

    test('un feed con mazos de verdad se usa tal cual', () async {
      final service = MetaDeckService(
        clientFactory: _clienteQueDevuelve(jsonEncode({
          'source': 'Meta Standard',
          'updated': '2026-07-24',
          'decks': [
            {
              'id': 'x',
              'name': 'Mazo de prueba',
              'archetype': 'aggro',
              'cards': {'Bolt': 4},
              'lands': {'Mountain': 20},
            }
          ],
        })),
      );

      final result = await service.load();

      expect(result.decks.map((d) => d.id), ['x']);
      expect(result.online, isTrue);
    });
  });
}
