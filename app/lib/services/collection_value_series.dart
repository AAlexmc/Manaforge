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

import 'package:manaforge_app/services/price_history.dart';
import 'package:manaforge_app/services/value_history.dart';

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

/// Pega la cola de fotos locales detrás de la serie histórica. Devuelve la
/// curva y la fecha de la COSTURA (el último punto histórico) si de verdad
/// quedó mezcla de fuentes: el histórico va por carta (mínimo por oracle) y
/// las fotos locales por edición exacta, así que el tramo que las une puede
/// dar un salto que es cambio de fuente, no mercado — quien pinte deltas no
/// debe calcularlos a caballo de esa fecha.
(List<ValuePoint>, String?) stitchValueCurve(
    List<ValuePoint> real, List<ValuePoint> local) {
  if (real.length < 2) return (local, null);
  final ultimo = real.last.date;
  final cola =
      local.where((p) => p.date.compareTo(ultimo) > 0).toList();
  return ([...real, ...cola], cola.isEmpty ? null : ultimo);
}

/// ¿El tramo [prevDate]→[lastDate] cruza la costura? (ver [stitchValueCurve])
bool cruzaCostura(String? costura, String prevDate, String lastDate) =>
    costura != null &&
    lastDate.compareTo(costura) > 0 &&
    prevDate.compareTo(costura) <= 0;
