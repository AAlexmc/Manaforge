<p align="center">
  <img src="docs/assets/banner.svg" alt="ManaForge — Escanea tu colección. Forja mazos con las cartas que ya tienes." width="100%">
</p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="Base de datos"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/licencia-MIT-4FB878" alt="Licencia MIT"></a>
  <img src="https://img.shields.io/badge/Flutter-iOS%20·%20Android%20·%20Windows%20·%20macOS%20·%20Linux-5A9BD8" alt="Multiplataforma">
  <img src="https://img.shields.io/badge/precio-0%20%E2%82%AC%20para%20siempre-E06A50" alt="Gratis para siempre">
</p>

---

Todos hemos pasado por esto: una caja llena de cartas de sobres, mazos de inicio y cajones heredados… y ninguna idea de qué construir con ellas. Las apps que existen te ayudan a *catalogar*, pero a la hora de la verdad te dejan solo delante de 800 cartas.

**ManaForge es la app de Magic: The Gathering que responde a la pregunta de verdad: _"¿qué mazos puedo montar con lo que YA tengo?"_**

Y lo hace gratis, sin anuncios, sin suscripción premium, sin cuentas y con el código abierto — porque está hecha por jugadores, para jugadores.

## ⚒️ Forge: el generador de mazos

El corazón de ManaForge. Le das tu colección y te devuelve **mazos completos de 60 cartas, listos para barajar**, construidos como lo haría un jugador veterano:

- **Curva de maná correcta** — número de tierras según el arquetipo (matemática de Frank Karsten), reparto de fuentes por símbolos de color, y curva validada. Nada de mazos con 15 tierras.
- **Sinergias detectadas** — Forge lee las reglas de cada carta y encuentra tus temas: drenaje de vida, sacrificio, artefactos, enjambre, hechizos, contadores…
- **Plan de juego explicado** — cada mazo llega con su plan turno a turno y un *"¿Por qué este mazo funciona?"* plegable, para quien quiera aprender la teoría sin que estorbe a quien solo quiere jugar.
- **Reglas de honor** — Forge **nunca** usa cartas que no tienes, nunca pasa del límite de copias, y si tu colección no da para un mazo sano, te lo explica y te propone alternativa antes que generarte un mazo defectuoso.
- **Exportación en un toque** — copia la lista y pégala en Moxfield, MTG Arena o el Discord de tu grupo.

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="132" alt="Gray Merchant of Asphodel">
  <img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="132" alt="The Mindskinner">
  <img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="132" alt="Tezzeret, Master of Metal">
  <img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="132" alt="Fiend Artisan">
  <img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="132" alt="Serra Angel">
</p>
<p align="center"><sub><i>Algunas de las cartas de la colección real con la que nació ManaForge — el generador las convirtió en cinco mazos jugables.</i></sub></p>

## ✨ Qué hace hoy (v0.2)

| | |
|---|---|
| 🗃️ **Base de datos completa** | Todas las cartas de la historia de Magic en tu dispositivo (bulk de Scryfall → SQLite). Se descarga una vez y todo funciona offline. |
| 🔍 **Búsqueda en español e inglés** | "Elfos de Llanowar" y "Llanowar Elves" llevan a la misma carta, con su imagen. |
| 📦 **Tu colección, visual y tuya** | Añade cartas con cantidades, o **importa tu CSV de ManaBox** en segundos. Todo se guarda en local: sin cuentas, sin nube obligatoria. |
| ⚒️ **Forge** | Genera varias propuestas de mazo, compáralas en un carrusel (arquetipo, colores, mini-curva) y abre el detalle con su plan de juego. |
| 🌗 **Diseño cuidado** | Tema oscuro por defecto, iconografía de maná propia accesible para daltónicos, y microcopys de jugador a jugador. |

**En el horno:** escáner de cartas con la cámara (100 % en tu dispositivo — [así funcionará](docs/reconocimiento-cartas.md)), guardar mazos, precios y valor de colección, trades, legalidades por formato e inglés.

## 🚀 Pruébala

```bash
# 1. Instala Flutter (canal stable): https://docs.flutter.dev/get-started/install
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run   # elige tu móvil o tu escritorio
```

Dentro de la app: descarga la base de datos de cartas (una vez), importa tu CSV de ManaBox o busca cartas a mano, y pulsa **Forjar mis mazos**. Eso es todo.

## 🔧 Cómo está hecho

```
app/               La app Flutter (iOS · Android · Windows · macOS · Linux)
forge_engine/      El motor de mazos en Dart: curva, validador, clasificador y generador
engine-reference/  El mismo motor en Python: referencia canónica y testeada del algoritmo
scripts/           Pipeline de datos: bulk de Scryfall → SQLite (corre solo, en GitHub Actions)
DesignSystem/      Tokens de diseño, iconos de maná y especificaciones de componentes
docs/              Arquitectura de datos, algoritmo de Forge y diseño del escáner
```

Dos decisiones definen el proyecto: el **motor existe por duplicado** (Python como especificación ejecutable con tests, Dart como implementación que corre en la app — si divergen, manda Python), y la **base de datos se construye sola**: un workflow descarga el bulk de Scryfall cada mes y publica la SQLite como [release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest), que la app baja en el primer arranque.

```bash
cd engine-reference && python3 -m pytest tests/   # tests del algoritmo
cd forge_engine && dart test                       # tests del motor de la app
cd app && flutter test                             # tests de la app
```

## 🤝 Contribuir

Este proyecto quiere ser de la comunidad. Si sabes de Flutter, de visión por computador (¡el escáner te espera!), de teoría de construcción de mazos o simplemente juegas y tienes ideas: los issues y PRs están abiertos. El código está comentado en español y la CI te dirá si algo se rompe antes de que nadie se enfade.

## 🙏 Créditos y legal

Los datos y las imágenes de cartas son de [Scryfall](https://scryfall.com), a quienes debemos una eterna gratitud (y el respeto a sus [límites de API](https://scryfall.com/docs/api)). Magic: The Gathering, sus cartas e ilustraciones son propiedad de **Wizards of the Coast**. ManaForge es un proyecto de fans **no oficial**, gratuito, al amparo de la [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy); no está producido, avalado ni patrocinado por Wizards.

## 📄 Licencia

[MIT](LICENSE) — haz con esto lo que quieras, y si lo mejoras, comparte. ⚒️
