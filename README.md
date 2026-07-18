# ManaForge

**La app de Magic: The Gathering hecha por la comunidad, para la comunidad.**
Gratis. Sin anuncios. Sin premium. Sin cuentas. Open source (MIT).

Escanea tu colección, contémplala como una galería visual, y deja que **Forge**
te construya mazos completos y jugables usando SOLO las cartas que ya tienes —
con curva de maná correcta, sinergias detectadas y un plan de juego explicado
turno a turno.

## Estado del proyecto

🎨 Diseño: prototipo aprobado — handoff v2 integrado en `DesignSystem/`.
⚙️ Motor: referencia Python testeada (curva + validador + generador fase 3) + puerto Dart completo.
📱 App: **Flutter** (iOS, Android, Windows, macOS y Linux con un solo código) — esqueleto con tema y navegación.

## Estructura

```
app/                  App Flutter (tema de los tokens, 5 pestañas) + test de humo
scripts/              Pipeline de datos: bulk de Scryfall → SQLite (corre en CI)
DesignSystem/         Handoff de diseño: tokens, iconos de maná SVG, specs
forge_engine/         Paquete Dart: motor completo (curva, validador, generador) + tests
engine-reference/     Referencia canónica en Python + tests de aceptación
docs/
  motor-forge.md            Especificación del algoritmo Forge
  reconocimiento-cartas.md  Cómo funciona el escáner (pipeline completo)
  arquitectura-datos.md     Base de datos, imágenes y modo offline
```

## Correr los tests

```bash
# Referencia Python (canónica)
cd engine-reference && python3 -m pytest tests/ -v

# Motor Dart (requiere Dart SDK 3+; es el que usa la app Flutter)
cd forge_engine && dart test

# App (requiere Flutter estable)
cd app && flutter test        # tests de humo
cd app && flutter run         # ejecutar en tu móvil/escritorio
```

**Regla de oro del motor:** Python y Dart son espejos. Mismos números, mismos
tests. Si divergen, manda Python.

## Datos y agradecimientos

Datos e imágenes de cartas por [Scryfall](https://scryfall.com). Magic: The
Gathering es propiedad de Wizards of the Coast; este es un proyecto de fans
gratuito al amparo de su [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy).
ManaForge no está afiliado ni patrocinado por Wizards of the Coast.

## Licencia

MIT — haz con esto lo que quieras, y si lo mejoras, comparte.
