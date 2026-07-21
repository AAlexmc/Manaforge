/// La curva del valor de la colección a lo largo del tiempo.
///
/// El Mercado enseñaba una línea sacada de `value_history.json`, que solo
/// apunta una foto por día que abres la app: con dos días de uso son dos
/// puntos, y dos puntos siempre dibujan una recta. Aquí la curva se saca del
/// histórico REAL de cada carta (los ~90 días de Cardmarket que trae la base
/// descargable), sumando cada día lo que valía tu colección.
///
/// Qué mide exactamente: **cuánto habría valido en cada fecha la colección que
/// tienes HOY**. No reconstruye cuándo compraste cada carta — eso no se sabe —
/// así que lo que se ve es el movimiento de los precios, no el de tus compras.
///
/// Lógica pura, testeable en CI.
library;

import 'price_history.dart';
import 'value_history.dart';

/// Construye la curva. [qtyByOracle] son las copias que tienes de cada carta y
/// [seriesByOracle] su histórico de precios.
List<ValuePoint> collectionValueSeries({
  required Map<String, int> qtyByOracle,
  required Map<String, List<PricePoint>> seriesByOracle,
}) {
  // solo las cartas que se tienen Y de las que hay histórico
  final relevantes = <String, List<PricePoint>>{};
  var copias = 0;
  qtyByOracle.forEach((oracle, qty) {
    if (qty <= 0) return;
    final serie = seriesByOracle[oracle];
    if (serie == null || serie.isEmpty) return;
    relevantes[oracle] = serie;
    copias += qty;
  });
  if (relevantes.isEmpty) return const [];

  final fechas = <String>{
    for (final serie in relevantes.values)
      for (final punto in serie) punto.date,
  }.toList()
    ..sort(); // 'YYYY-MM-DD' ordena igual como texto que como fecha

  final out = <ValuePoint>[];
  // por carta: su precio por fecha, y cuál fue el primero que se supo
  final porFecha = <String, Map<String, double>>{};
  final primerPrecio = <String, double>{};
  relevantes.forEach((oracle, serie) {
    final ordenada = [...serie]..sort((a, b) => a.date.compareTo(b.date));
    // dos apuntes del mismo día: manda el último
    porFecha[oracle] = {for (final punto in ordenada) punto.date: punto.value};
    primerPrecio[oracle] = ordenada.first.value;
  });

  // último precio conocido de cada carta según avanzamos por las fechas. Se
  // arranca con su PRIMER precio conocido a propósito: si una carta entra en
  // la base a mitad, empezar en cero haría que el total pegara un salto el
  // día que aparece, y ese salto es un alta de datos, no una subida de precio
  final ultimo = <String, double>{...primerPrecio};

  for (final fecha in fechas) {
    var total = 0.0;
    relevantes.forEach((oracle, _) {
      final precio = porFecha[oracle]![fecha];
      if (precio != null) ultimo[oracle] = precio;
      total += ultimo[oracle]! * qtyByOracle[oracle]!;
    });
    out.add(ValuePoint(fecha, total, copias));
  }
  return out;
}
