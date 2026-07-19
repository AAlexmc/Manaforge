import 'classify.dart';
import 'generator.dart';
import 'models.dart';

/// Generador de Commander (EDH): 100 cartas, singleton, comandante
/// legendario e identidad de color respetada. Cuotas EDH clásicas:
/// ~37 tierras, rampa, robo, removal y barreduras antes que nada.

const int commanderDeckSize = 100;
const int commanderLands = 37;

/// Perfil de curva objetivo para los ~62 hechizos de un mazo de Commander.
const Map<int, double> _commanderCurve = {
  1: .08,
  2: .18,
  3: .22,
  4: .20,
  5: .15,
  6: .17,
};

/// Reglas duras de Commander (validador propio: las de 60 no aplican).
List<String> validateCommanderDeck(
    Deck deck, Map<String, Card> pool, String commanderName) {
  const basics = {
    'Plains', 'Island', 'Swamp', 'Mountain', 'Forest',
    'Snow-Covered Plains', 'Snow-Covered Island', 'Snow-Covered Swamp',
    'Snow-Covered Mountain', 'Snow-Covered Forest',
  };
  final errors = <String>[];
  if (deck.totalCards != commanderDeckSize) {
    errors.add('el mazo tiene ${deck.totalCards} cartas, deben ser 100');
  }
  if ((deck.cards[commanderName] ?? 0) != 1) {
    errors.add('falta el comandante $commanderName');
  }
  final commander = pool[commanderName];
  final identity = (commander?.identity ?? '').split('').toSet();
  final everything = <String, int>{...deck.cards};
  deck.lands.forEach((k, v) => everything[k] = (everything[k] ?? 0) + v);
  everything.forEach((name, qty) {
    if (qty > 1 && !basics.contains(name)) {
      errors.add("'$name': $qty copias en un formato singleton");
    }
    final card = pool[name];
    if (card == null) {
      errors.add("'$name' no está en la colección");
      return;
    }
    if (qty > card.qty) {
      errors.add("'$name': usa $qty, posee ${card.qty}");
    }
    if (card.identity.split('').toSet().difference(identity).isNotEmpty) {
      errors.add(
          "'$name' (${card.identity}) fuera de la identidad del comandante");
    }
  });
  return errors;
}

Map<int, double> _curveNeed(Map<String, int> chosen, Map<String, Card> cands) {
  var total = 0;
  chosen.forEach((_, q) => total += q);
  if (total == 0) total = 1;
  final hist = <int, int>{};
  chosen.forEach((n, q) {
    var cmc = cands[n]!.cmc;
    if (cmc > 6) cmc = 6;
    hist[cmc] = (hist[cmc] ?? 0) + q;
  });
  final need = <int, double>{};
  for (var cmc = 0; cmc <= 6; cmc++) {
    need[cmc] = (_commanderCurve[cmc] ?? 0) - (hist[cmc] ?? 0) / total;
  }
  return need;
}

/// Construye el mejor mazo de Commander para un comandante concreto.
/// Null si la colección no da (pocas cartas en su identidad o sin tierras).
GeneratedDeck? generateCommanderDeck(
    Map<String, Card> pool, String commanderName) {
  final commander = pool[commanderName];
  if (commander == null || !commander.isLegendaryCreature) return null;
  final identity = commander.identity.split('').toSet();

  // candidatos: dentro de la identidad, sin tierras, sin el comandante
  final cands = <String, Card>{};
  pool.forEach((name, card) {
    if (card.isLand || name == commanderName) return;
    if (card.identity.split('').toSet().difference(identity).isEmpty) {
      cands[name] = card;
    }
  });
  if (cands.length < 55) return null; // singleton: hacen falta distintas

  final (theme, rolesByCard) = detectTheme(cands);

  // cuotas funcionales EDH (mínimos sobre los ~62 hechizos)
  final quota = <String, int>{
    'ramp': 8,
    'draw': 8,
    'interaction': 8,
    'sweeper': 2,
  };
  final counts = {'ramp': 0, 'draw': 0, 'interaction': 0, 'sweeper': 0};

  List<String> buckets(Card card) {
    final tags = classify(card);
    final out = <String>[];
    if (tags.contains('ramp')) out.add('ramp');
    if (tags.contains('draw')) out.add('draw');
    if (tags.contains('removal') ||
        tags.contains('counterspell') ||
        tags.contains('burn')) {
      out.add('interaction');
    }
    if (tags.contains('sweeper')) out.add('sweeper');
    return out;
  }

  final nSpells = commanderDeckSize - commanderLands - 1; // 62
  final chosen = <String, int>{};
  var totalChosen = 0;
  while (totalChosen < nSpells) {
    final need = _curveNeed(chosen, cands);
    final pending = <String>{};
    quota.forEach((b, minimum) {
      if (counts[b]! < minimum) pending.add(b);
    });
    String? bestName;
    var bestScore = -1e9;
    cands.forEach((n, card) {
      if (chosen.containsKey(n)) return; // singleton
      var s = efficiency(card);
      final role = rolesByCard[n]![theme];
      if (role == 'payoff') s += 3.0;
      if (role == 'enabler') s += 1.5;
      final cmc = card.cmc > 6 ? 6 : card.cmc;
      s += (need[cmc] ?? 0) * 4.0;
      final bs = buckets(card);
      if (pending.isNotEmpty && !pending.any(bs.contains)) {
        s -= 3.0;
      }
      if (s > bestScore) {
        bestName = n;
        bestScore = s;
      }
    });
    if (bestName == null) break;
    chosen[bestName!] = 1;
    totalChosen++;
    for (final b in buckets(cands[bestName!]!)) {
      counts[b] = counts[b]! + 1;
    }
  }
  if (totalChosen < nSpells) return null; // no llegamos a 62 distintas

  // base de maná: básicas repartidas por símbolos (mínimo 6 por color usado)
  final syms = <String, int>{};
  void addSyms(String cost, int qty) {
    final symbol = RegExp(r'\{([^}]+)\}');
    for (final m in symbol.allMatches(cost)) {
      final sym = m.group(1)!.toUpperCase();
      for (final ch in ['W', 'U', 'B', 'R', 'G']) {
        if (sym.contains(ch)) syms[ch] = (syms[ch] ?? 0) + qty;
      }
    }
  }

  chosen.forEach((n, q) => addSyms(cands[n]!.manaCost, q));
  addSyms(commander.manaCost, 2); // el comandante pesa: se lanza varias veces

  final used =
      identity.where((c) => (syms[c] ?? 0) > 0).toList();
  if (used.isEmpty && identity.isNotEmpty) {
    used.addAll(identity);
  }
  final lands = <String, int>{};
  if (used.isEmpty) {
    return null; // comandante incoloro con pool incoloro: fuera de alcance
  }
  var totalSyms = 0;
  for (final c in used) {
    totalSyms += syms[c] ?? 1;
  }
  var remaining = commanderLands;
  for (var i = 0; i < used.length; i++) {
    final c = used[i];
    final basic = basicForColor[c]!;
    final owned = pool[basic]?.qty ?? 0;
    if (owned <= 0) return null;
    int n;
    if (i == used.length - 1) {
      n = remaining;
    } else {
      n = (commanderLands * (syms[c] ?? 1) / totalSyms).round();
      if (n < 6) n = 6;
      final reserve = 6 * (used.length - 1 - i);
      if (n > remaining - reserve) n = remaining - reserve;
    }
    if (n > owned) n = owned;
    lands[basic] = n;
    remaining -= n;
  }
  if (remaining > 0) return null; // sin básicas suficientes

  final deck = Deck(
    name: 'Commander · ${commander.name}',
    colors: commander.identity,
    archetype: Archetype.midrange,
    cards: {commanderName: 1, ...chosen},
    lands: lands,
  );
  if (validateCommanderDeck(deck, pool, commanderName).isNotEmpty) {
    return null;
  }

  var effSum = 0.0;
  chosen.forEach((n, q) => effSum += efficiency(cands[n]!) * q);
  return GeneratedDeck(deck, theme, effSum / totalChosen);
}

/// Las mejores propuestas de Commander: prueba los comandantes legendarios
/// de la colección más prometedores (por cartas disponibles en su identidad).
List<GeneratedDeck> generateCommanderProposals(Map<String, Card> pool,
    {int maxProposals = 3}) {
  final candidates = pool.values
      .where((c) => c.isLegendaryCreature && c.qty > 0)
      .toList();
  // prometedor = cuántas copias de la colección caben en su identidad
  int reach(Card commander) {
    final identity = commander.identity.split('').toSet();
    var total = 0;
    pool.forEach((_, card) {
      if (card.isLand) return;
      if (card.identity.split('').toSet().difference(identity).isEmpty) {
        total += card.qty;
      }
    });
    return total;
  }

  candidates.sort((a, b) => reach(b).compareTo(reach(a)));
  final proposals = <GeneratedDeck>[];
  final seenIdentities = <String>{};
  for (final commander in candidates) {
    if (proposals.length >= maxProposals) break;
    final idKey = (commander.identity.split('')..sort()).join();
    if (seenIdentities.contains(idKey)) continue;
    final gen = generateCommanderDeck(pool, commander.name);
    if (gen != null) {
      proposals.add(gen);
      seenIdentities.add(idKey);
    }
  }
  return proposals;
}
