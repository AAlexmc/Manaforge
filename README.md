# ManaForge

**La app de Magic: The Gathering hecha por la comunidad, para la comunidad.**
Gratis. Sin anuncios. Sin premium. Sin cuentas. Open source (MIT).

Escanea tu colección, contémplala como una galería visual, y deja que **Forge**
te construya mazos completos y jugables usando SOLO las cartas que ya tienes —
con curva de maná correcta, sinergias detectadas y un plan de juego explicado
turno a turno.

## Estado del proyecto

🎨 Diseño: prototipo navegable completo (Claude Design) — tokens y specs en el handoff.
⚙️ Motor: referencia Python testeada + puerto Swift iniciado.
📱 App iOS: pendiente de arranque (SwiftUI, iOS 17+).

## Estructura

```
ForgeEngine/          Paquete Swift: motor de mazos (curva, validador) + tests
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

# Motor Swift (requiere Xcode 15+ / Swift 5.9)
cd ForgeEngine && swift test
```

**Regla de oro del motor:** Python y Swift son espejos. Mismos números, mismos
tests. Si divergen, manda Python.

## Datos y agradecimientos

Datos e imágenes de cartas por [Scryfall](https://scryfall.com). Magic: The
Gathering es propiedad de Wizards of the Coast; este es un proyecto de fans
gratuito al amparo de su [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy).
ManaForge no está afiliado ni patrocinado por Wizards of the Coast.

## Licencia

MIT — haz con esto lo que quieras, y si lo mejoras, comparte.
