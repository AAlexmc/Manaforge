<p align="center">
  <img src="docs/assets/banner.svg" alt="ManaForge — Escanea tu colección. Forja mazos con las cartas que ya tienes." width="100%">
</p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="Base de datos"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/licencia-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="Licencia PolyForm Noncommercial 1.0.0"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="Escritorio multiplataforma">
  <img src="https://img.shields.io/badge/precio-0%20%E2%82%AC%20para%20siempre-E06A50?style=flat-square" alt="Gratis para siempre">
</p>

<p align="center">
  <b><a href="#-forge-el-generador-de-mazos">Forge</a></b> ·
  <b><a href="#-qué-hace-hoy-v02">Funciones</a></b> ·
  <b><a href="#-pruébala-en-2-minutos">Pruébala</a></b> ·
  <b><a href="#-cómo-está-hecho">Arquitectura</a></b> ·
  <b><a href="#-hoja-de-ruta">Hoja de ruta</a></b> ·
  <b><a href="#-contribuir">Contribuir</a></b>
</p>

> [!TIP]
> **¿Qué mazos puedo montar con lo que YA tengo?** Esa es la pregunta que ninguna app de Magic responde bien — y la única razón de existir de ManaForge. Las demás te ayudan a *catalogar* tu caja de cartas; esta te la convierte en mazos listos para barajar.

Todos hemos pasado por esto: una caja llena de cartas de sobres, mazos de inicio y cajones heredados… y ninguna idea de qué construir con ellas. ManaForge está hecha por jugadores, para jugadores: **gratis, sin anuncios, sin premium, sin cuentas, y con todo el código abierto.**

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

## ⚒️ Forge: el generador de mazos

Le das tu colección y te devuelve **mazos completos de 60 cartas**, construidos como lo haría un jugador veterano. Así piensa por dentro:

<p align="center">
  <img src="docs/assets/forge-flow.svg" alt="Colección → Sinergias → Curva de maná → Validador → Mazos con plan de juego" width="100%">
</p>

- 🏔️ **Curva de maná correcta** — tierras según arquetipo, fuentes repartidas por símbolos de color, curva validada. Nada de mazos con 15 tierras.
- 🧬 **Sinergias detectadas** — Forge lee las reglas de cada carta y encuentra tus temas: drenaje de vida, sacrificio, artefactos, enjambre, hechizos, contadores…
- 🗺️ **Plan de juego explicado** — turno a turno, más un *"¿Por qué este mazo funciona?"* plegable para quien quiera la teoría.
- 🤝 **Reglas de honor** — nunca usa cartas que no tienes, nunca pasa del límite de copias, y antes que generar un mazo defectuoso, te explica el porqué y te propone alternativa.
- 📤 **Exportación en un toque** — copia la lista y pégala en Moxfield, MTG Arena o el Discord de tu grupo.

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>La colección real con la que nació ManaForge — el generador convirtió estas cartas (y 280 más) en cinco mazos jugables.</i></sub></p>

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

## ✨ Qué hace hoy (v0.2)

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>Toda la historia de Magic<br/>en tu bolsillo</b><br/><br/>
      <sub>Base de datos completa (bulk de Scryfall → SQLite) que se construye sola cada mes en CI. Se descarga una vez y todo funciona <b>offline</b>.</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>Búsqueda en<br/>español e inglés</b><br/><br/>
      <sub>"Elfos de Llanowar" y "Llanowar Elves" llevan a la misma carta, con su imagen y sus reglas al día.</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>Tu colección,<br/>visual y tuya</b><br/><br/>
      <sub>Añade cartas con cantidades o <b>importa tu colección en CSV</b> desde cualquier otra app en segundos. Todo en local: sin cuentas, sin nube obligatoria.</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>Varias propuestas de mazo en un carrusel comparable (arquetipo, colores, mini-curva) y detalle con plan de juego turno a turno.</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>Diseño cuidado</b><br/><br/>
      <sub>Tema oscuro por defecto, iconografía de maná propia accesible para daltónicos, microcopys de jugador a jugador.</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>Privacidad de serie</b><br/><br/>
      <sub>Ni analytics, ni tracking, ni "crea tu cuenta". El futuro escáner reconocerá cartas 100 % en tu dispositivo.</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **En el horno:** escáner de cartas con la cámara ([así funcionará por dentro](docs/reconocimiento-cartas.md)), guardar mazos, precios y valor de colección, trades, legalidades por formato e inglés.

## 🚀 Pruébala en 2 minutos

```bash
# 1. Instala Flutter (canal stable): https://docs.flutter.dev/get-started/install
#    (en Windows necesitas además Visual Studio con "Desarrollo para el escritorio con C++")
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter create . --platforms=windows --project-name manaforge_app   # 1ª vez (en Mac: --platforms=macos)
flutter run -d windows                                              # en Mac: -d macos
```

¿Sin ganas de compilar? Pronto habrá **descargas directas** para Windows, macOS y Linux en [Releases](https://github.com/AAlexmc/Manaforge/releases) — sin instalar nada más.

Dentro de la app: **descarga la base de datos** de cartas (una vez) → **importa tu colección** en CSV o busca cartas a mano → pulsa **⚒️ Forjar mis mazos**. Eso es todo.

## 🔧 Cómo está hecho

| Carpeta | Qué vive ahí |
|---|---|
| [`app/`](app) | La app Flutter — un solo código para Windows, macOS y Linux (y móviles el día de mañana) |
| [`forge_engine/`](forge_engine) | El motor de mazos en Dart: curva, validador, clasificador y generador |
| [`engine-reference/`](engine-reference) | El mismo motor en Python: **referencia canónica** y testeada del algoritmo |
| [`scripts/`](scripts) | Pipeline de datos: bulk de Scryfall → SQLite, ejecutado solo en GitHub Actions |
| [`DesignSystem/`](DesignSystem) | Tokens de diseño, iconos de maná SVG y especificaciones de componentes |
| [`docs/`](docs) | Arquitectura de datos, algoritmo de Forge y diseño del escáner |

Dos decisiones definen el proyecto. Una: **el motor existe por duplicado** — Python como especificación ejecutable con tests, Dart como implementación que corre en la app; si divergen, manda Python. Y dos: **la base de datos se construye sola** — un workflow descarga el bulk de Scryfall cada mes y publica la SQLite como [release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest), que la app baja en el primer arranque.

```bash
cd engine-reference && python3 -m pytest tests/   # tests del algoritmo (canónico)
cd forge_engine && dart test                      # tests del motor de la app
cd app && flutter test                            # tests de la app
```

## 🗺️ Hoja de ruta

- [x] **Fase 1 — Cimientos**: motor de curva y validador (Python + Dart), sistema de diseño, CI
- [x] **Fase 2 — Datos**: pipeline bulk Scryfall → SQLite con release automática mensual
- [x] **Fase 3 — Generador**: clasificación funcional, temas, puntuación y construcción greedy
- [x] **Fase 4 — App v0.2**: colección con búsqueda ES/EN, importador CSV, Forge con carrusel y plan de juego
- [ ] **Fase 5 — Escritorio de primera**: builds automáticas de Windows/macOS/Linux en Releases (workflow listo), guardar mazos, atajos de teclado y ventanas a medida
- [ ] **Fase 6 — Redondear**: precios y valor de colección, trades, legalidades por formato, inglés
- [ ] **Fase 7 — Escáner**: huellas perceptuales generadas en CI + webcam/cámara ([diseño listo](docs/reconocimiento-cartas.md))
- [ ] **Fase 8 — Móviles (si la comunidad los pide)**: Android y iOS/TestFlight — el código ya está listo; solo faltan las cuentas de las tiendas

## 🤝 Contribuir

Este proyecto quiere ser de la comunidad. Si sabes de Flutter, de visión por computador (¡el escáner te espera!), de teoría de construcción de mazos — o simplemente juegas y tienes ideas — los issues y PRs están abiertos. El código está comentado en español y la CI te avisará si algo se rompe antes de que nadie se enfade.

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

## 🙏 Créditos y legal

Los datos y las imágenes de cartas son de [Scryfall](https://scryfall.com), a quienes debemos eterna gratitud (y el respeto a sus [límites de API](https://scryfall.com/docs/api)). Magic: The Gathering, sus cartas e ilustraciones son propiedad de **Wizards of the Coast**. ManaForge es un proyecto de fans **no oficial** y gratuito al amparo de la [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy); no está producido, avalado ni patrocinado por Wizards.

## 📄 Licencia

[PolyForm Noncommercial 1.0.0](LICENSE). En cristiano:

- **Puedes** usarla, copiarla, modificarla, compartirla y publicar tus versiones, con la única condición de pasar la licencia junto al código.
- **No puedes** venderla ni usarla para ganar dinero: ni cobrar por la app o por una versión modificada, ni meterla en un producto o servicio de pago, ni usarla dentro de un negocio para su actividad comercial.
- **Sí puedes** usarla en casa, en tu tienda de barrio para tus propias cartas… siempre que no sea para vender la app ni cobrar por ella.

Uso personal, estudio, cacharreo, proyectos de aficionado y organizaciones sin ánimo de lucro: adelante, sin pedir permiso.

> Antes era MIT. Las versiones publicadas bajo MIT siguen siendo MIT para siempre —eso no se puede revocar—; el cambio vale de aquí en adelante. Si necesitas un uso comercial, escribe y hablamos.

Ojo: una licencia con restricción no comercial **no** es "código abierto" en el sentido de la OSI. Es *código a la vista*: puedes leerlo, tocarlo y compartirlo, pero no venderlo.

<p align="center">
  <sub>Hecho con ❤️ y mucho maná por jugadores de mesa de cocina</sub><br/><br/>
  <img src="DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
