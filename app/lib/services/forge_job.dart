/// Generar los mazos, FUERA del hilo de la ventana.
///
/// Con la colección de uno esto tarda milisegundos, pero el modo "incluir
/// cartas que no tengo" cambia la escala: medido en esta máquina, 874 cartas
/// (3 expansiones) tardan ~6 s y 2.805 cartas (10 expansiones) ~21 s. En el
/// hilo de la ventana eso no es "un poco lento": es la app colgada, sin
/// repintar ni un frame, con el sistema preguntando si la cierras.
///
/// Por eso el trabajo va en un isolate (`compute`). El pool son objetos de
/// datos planos (nombres, costes, tipos), así que viaja sin problema.
library;

import 'package:forge_engine/forge_engine.dart' as fe;

class ForgeJob {
  final Map<String, fe.Card> pool;

  /// Colores a los que ceñirse, o null para probar todas las combinaciones.
  final String? allowedColors;

  /// Arquetipo forzado, o null para que lo decida el motor.
  final String? archetype;

  /// Tema/tribu forzado ('lifegain', 'tribal:Elf', ...), o null para que lo
  /// decida el motor (selector de Estilo). Se ignora en Commander: el
  /// generador de Commander no tiene override de tema todavía.
  final String? theme;

  /// Commander tiene su propio generador (singleton + identidad de color).
  final bool commander;

  /// Forja profunda: reordena las propuestas por cómo rinden jugando entre
  /// sí de verdad (round-robin simulado), no solo por su score estático. ON
  /// por defecto: es la mejora, no la excepción.
  final bool deepForge;

  const ForgeJob({
    required this.pool,
    this.allowedColors,
    this.archetype,
    this.commander = false,
    this.deepForge = true,
    this.theme,
  });
}

/// Función de nivel superior a propósito: `compute` no admite closures.
List<fe.GeneratedDeck> runForgeJob(ForgeJob job) {
  if (job.commander) return fe.generateCommanderProposals(job.pool);
  final proposals = fe.generateProposals(job.pool,
      allowedColors: job.allowedColors,
      archetypeOverride: job.archetype,
      themeOverride: job.theme);
  return job.deepForge ? fe.rankBySimulation(proposals, job.pool) : proposals;
}
