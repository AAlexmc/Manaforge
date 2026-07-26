/// Los microcopys de Forge: cómo se llama el tema de un mazo, su frase corta,
/// su plan de juego por turnos y la explicación de por qué funciona.
///
/// Vivían dentro de `forge_engine`, que es Dart puro y no tiene traducciones,
/// así que estaban en español para todo el mundo. El motor sigue diciendo QUÉ
/// mazo es (tema, arquetipo, números); el texto lo pone aquí quien sabe en qué
/// idioma va la app.
library;

import 'package:forge_engine/forge_engine.dart' as fe;

import '../l10n/app_localizations.dart';

/// Cómo se llama un tema. Un tema que el motor detecte y aquí no esté se
/// enseña con su clave: es preferible a no decir nada. Las tribus
/// ('tribal:<Subtipo>') no tienen entrada fija: el subtipo va EN INGLÉS
/// (como los nombres de carta — decisión previa) interpolado en la frase.
String themeName(AppLocalizations t, String theme) {
  if (theme.startsWith('tribal:')) {
    // Enrutado por tribeName (I1): sin esto, la tarjeta de resultado, el
    // detalle del mazo y Modo Test mostraban el subtipo en inglés crudo
    // ("tribu de Elf") en vez del nombre traducido — solo el selector y el
    // chip pasaban por tribeName.
    return t.fxThemeTribal(tribeName(t, theme.substring('tribal:'.length)));
  }
  return switch (theme) {
    'lifegain' => t.fxThemeLifegain,
    'sacrifice' => t.fxThemeSacrifice,
    'spells' => t.fxThemeSpells,
    'artifacts' => t.fxThemeArtifacts,
    'counters' => t.fxThemeCounters,
    'tokens' => t.fxThemeTokens,
    'graveyard' => t.fxThemeGraveyard,
    'reanimator' => t.fxThemeReanimator,
    'goodstuff' => t.fxThemeGoodstuff,
    _ => theme,
  };
}

/// Nombre visible de una tribu de `fe.kUiTribes` (el subtipo llega en inglés
/// desde el motor — el selector de Estilo enseña el nombre traducido, pero
/// el valor que viaja al motor sigue siendo el subtipo inglés). Si algún día
/// hay una tribu fuera de la lista curada, se enseña el subtipo tal cual.
String tribeName(AppLocalizations t, String tribe) => switch (tribe) {
      'Elf' => t.fgTribeElf,
      'Goblin' => t.fgTribeGoblin,
      'Zombie' => t.fgTribeZombie,
      'Vampire' => t.fgTribeVampire,
      'Dragon' => t.fgTribeDragon,
      'Angel' => t.fgTribeAngel,
      'Demon' => t.fgTribeDemon,
      'Dinosaur' => t.fgTribeDinosaur,
      'Faerie' => t.fgTribeFaerie,
      'Merfolk' => t.fgTribeMerfolk,
      'Human' => t.fgTribeHuman,
      'Spirit' => t.fgTribeSpirit,
      'Sliver' => t.fgTribeSliver,
      'Wizard' => t.fgTribeWizard,
      'Knight' => t.fgTribeKnight,
      'Warrior' => t.fgTribeWarrior,
      'Soldier' => t.fgTribeSoldier,
      'Cat' => t.fgTribeCat,
      'Dog' => t.fgTribeDog,
      'Rat' => t.fgTribeRat,
      'Pirate' => t.fgTribePirate,
      'Elemental' => t.fgTribeElemental,
      'Giant' => t.fgTribeGiant,
      'Rogue' => t.fgTribeRogue,
      _ => tribe,
    };

/// Nombre visible de un estilo forzado ('lifegain', 'tribal:Elf', ...) para
/// el selector de Estilo: reusa [themeName] para lo mecánico y [tribeName]
/// para las tribus, sin el envoltorio "tribu de …" de [themeName] (ahí
/// el nombre solo, tal y como va en la lista del selector).
String styleName(AppLocalizations t, String style) {
  if (style.startsWith('tribal:')) {
    return tribeName(t, style.substring('tribal:'.length));
  }
  return themeName(t, style);
}

/// Frase corta del tema, la que cuenta la historia del mazo. Null si el tema
/// no tiene una propia (entonces habla el arquetipo).
String? _themeTagline(AppLocalizations t, String theme) => switch (theme) {
      'lifegain' => t.fxTagLifegain,
      'sacrifice' => t.fxTagSacrifice,
      'spells' => t.fxTagSpells,
      'artifacts' => t.fxTagArtifacts,
      'counters' => t.fxTagCounters,
      'tokens' => t.fxTagTokens,
      'graveyard' => t.fxTagGraveyard,
      _ => null,
    };

/// Frase corta para la tarjeta del carrusel.
String tagline(AppLocalizations t, fe.GeneratedDeck gen) {
  final themed = _themeTagline(t, gen.theme);
  return switch (gen.deck.archetype) {
    fe.Archetype.aggro => themed ?? t.fxTagAggro,
    fe.Archetype.tempo => themed ?? t.fxTagTempo,
    fe.Archetype.midrange =>
      themed ?? t.fxTagMidrange(themeName(t, gen.theme)),
    // el control cuenta siempre lo mismo: aguantar y rematar
    fe.Archetype.control => t.fxTagControl,
  };
}

/// Paso central del plan (T3-T4), el turno en el que manda el tema.
String? _themeMidgame(AppLocalizations t, String theme) => switch (theme) {
      'lifegain' => t.fxMidLifegain,
      'sacrifice' => t.fxMidSacrifice,
      'spells' => t.fxMidSpells,
      'artifacts' => t.fxMidArtifacts,
      'counters' => t.fxMidCounters,
      'tokens' => t.fxMidTokens,
      'graveyard' => t.fxMidGraveyard,
      _ => null,
    };

/// Remate del plan (T5+), específico del tema.
String? _themeEndgame(AppLocalizations t, String theme) => switch (theme) {
      'lifegain' => t.fxEndLifegain,
      'sacrifice' => t.fxEndSacrifice,
      'spells' => t.fxEndSpells,
      'artifacts' => t.fxEndArtifacts,
      'counters' => t.fxEndCounters,
      'tokens' => t.fxEndTokens,
      'graveyard' => t.fxEndGraveyard,
      _ => null,
    };

/// Plan de juego por tramos de turnos, con el tema del mazo como hilo.
List<(String, String)> gamePlan(AppLocalizations t, fe.GeneratedDeck gen) {
  final tema = themeName(t, gen.theme);
  final mid = _themeMidgame(t, gen.theme);
  final end = _themeEndgame(t, gen.theme);
  return switch (gen.deck.archetype) {
    fe.Archetype.aggro => [
        (t.fxTurns12, t.fxAggroEarly),
        (t.fxTurns34, mid ?? t.fxAggroMid),
        (t.fxTurns5, end ?? t.fxAggroLate),
      ],
    fe.Archetype.tempo => [
        (t.fxTurns12, t.fxTempoEarly),
        (t.fxTurns34, mid ?? t.fxTempoMid),
        (t.fxTurns5, end ?? t.fxTempoLate),
      ],
    fe.Archetype.midrange => [
        (t.fxTurns12, t.fxMidrangeEarly),
        (t.fxTurns34, mid ?? t.fxMidrangeMid(tema)),
        (t.fxTurns5, end ?? t.fxMidrangeLate),
      ],
    fe.Archetype.control => [
        (t.fxTurns12, t.fxControlEarly),
        // el control no cambia de plan por tema en el medio juego
        (t.fxTurns34, t.fxControlMid),
        (t.fxTurns5, end ?? t.fxControlLate),
      ],
  };
}

/// Cómo se llama cada arquetipo.
String archetypeName(AppLocalizations t, fe.Archetype a) => switch (a) {
      fe.Archetype.aggro => t.fxArchetypeAggro,
      fe.Archetype.tempo => t.fxArchetypeTempo,
      fe.Archetype.midrange => t.fxArchetypeMidrange,
      fe.Archetype.control => t.fxArchetypeControl,
    };

/// Explicación plegable "¿Por qué este mazo funciona?", con los números
/// reales que cuenta el motor.
String whyItWorks(
    AppLocalizations t, fe.GeneratedDeck gen, Map<String, fe.Card> pool) {
  final f = fe.whyItWorksFacts(gen, pool);
  return t.fxWhyItWorks(
    f.avgCmc.toStringAsFixed(2),
    '${f.lands}',
    archetypeName(t, gen.deck.archetype),
    f.creatures,
    f.interaction,
    themeName(t, gen.theme),
  );
}

/// Por qué no se ha podido reforjar con la curva pedida.
String reforgeRefusalText(AppLocalizations t, fe.ReforgeResult result) {
  String arg(int i) => i < result.args.length ? result.args[i] : '';
  return switch (result.refusal) {
    fe.ReforgeRefusal.landsOutOfRange =>
      t.fxNoLandsRange(arg(0), arg(1), arg(2)),
    fe.ReforgeRefusal.notEnoughCards => t.fxNoCards,
    fe.ReforgeRefusal.curveHasNoProfile => t.fxNoProfile(arg(0), arg(1)),
    fe.ReforgeRefusal.notEnoughBasics => t.fxNoBasics,
    fe.ReforgeRefusal.hardRule => t.fxHardRule(arg(0)),
    // un rechazo sin motivo no debería existir; si pasa, al menos se cuenta
    null => result.reason ?? '',
  };
}
