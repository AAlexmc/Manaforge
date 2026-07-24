# Diez idiomas de verdad (2026-07-24, tanda de noche)

Lo que pidió Ale al cerrar la tanda anterior: **que la app se lea entera en
los diez idiomas**. Hasta el PR #73 las claves nuevas se metían solo en
español e inglés y los otros ocho caían al español.

## De dónde se salía

- `app_es.arb` / `app_en.arb` = 601 claves · de·fr·it·pt·ru·zh·ja·ko = 140.
- Y **seguía habiendo texto a pelo en los `.dart`**, más del que decía la
  cuenta anterior: no solo `whats_new`, `backup` y los logros.

## Orden de trabajo (a propósito)

Primero **terminar la extracción**, luego traducir. Al revés se traduce dos
veces: cada cadena que salga después de la traducción hay que volver a
repartirla entre diez idiomas.

## Lo que se ha extraído

| PR | Qué |
|----|-----|
| #74 | Novedades de versión, copias de seguridad y **los fallos de los servicios** (`BackupErrorCode`, `InputRejectedCode`, `CameraErrorCode`) |
| #75 | Lo que quedaba en pantallas y widgets (Forge, Modo Test, filtros de la colección, bandeja del escáner, carpetas, visor de cartas…) |
| #76 | El **catálogo de logros** (120), los **textos de Forge** que vivían dentro del motor y los fallos de descarga de las bases |

### El patrón que se ha repetido

Una excepción no puede llevar el texto de la persona dentro: nace en un
servicio, donde no hay `BuildContext` ni idioma. Todas las que se enseñan
llevan ahora **código + argumentos**, y el texto lo pone quien la pinta:

```dart
throw const BackupError('mensaje en español para el registro',
    code: BackupErrorCode.notABackup);
...
setState(() => _status = backupErrorText(t, e));
```

Lo mismo con `InputRejected`, `CameraUnavailable`, `DatabaseDownloadError` y
`ReforgeResult`. El mensaje en español se queda dentro como registro y red de
seguridad, y hay un test que comprueba que **ningún código se queda sin
traducir**.

### Sorpresas del camino

- Varias pantallas **tenían las claves puestas desde tandas anteriores pero
  seguían pintando el texto a pelo**: Forge entero, la tarjeta de copias, el
  selector de cartas de una carpeta, la wishlist. Añadir la clave y no
  cablearla no lo caza nada: el ARB crece y la pantalla sigue igual.
- `forge_engine` (Dart puro, sin traducciones) escribía **los microcopys de
  Forge**: nombres de tema, la frase de cada mazo, el plan por turnos y el
  "por qué funciona". Ahora el motor da los NÚMEROS (`whyItWorksFacts`) y el
  texto lo pone `app/lib/services/forge_texts.dart`.
- La palabra que hay que escribir para restaurar era `CONFIRMAR` **en los diez
  idiomas**. Pedirle eso a alguien que no habla español no es una traba de
  tres segundos, es un muro.
- Bug de los de verdad: la lista que copia el detalle de mazo decía
  `· 60 cartas` siempre, también en un Commander de 100.

## Lo que se queda en español a propósito

- El `message` en español que llevan las excepciones dentro (registro).
- `kShortcutHelp`: es la chuleta de teclas para los tests, no la que se pinta.
- Los alias de cabecera del CSV (`edición`, `cantidad`…): son lo que puede
  traer un CSV español, no texto de interfaz.
- Los meses cortos del painter de la gráfica (`_shortDate`): CustomPainter sin
  `context`.
- Los errores internos de `DeckValidator`: salen anidados dentro de
  `fxHardRule` y son diagnóstico, no interfaz.
- Nombres propios: ManaForge, Scryfall, Cardmarket, los formatos de Magic y los
  arquetipos (Aggro/Tempo/Midrange/Control).

## Cómo se han traducido los ocho idiomas

Un agente por idioma, con el español como original y el inglés al lado. Cada
uno escribe su JSON y **no toca el repositorio**; el JSON pasa por
`check_lang.py` (todas las claves, los huecos `{n}` `{carpeta}` uno a uno, los
plurales ICU sobre la misma variable, y nada que se haya quedado en español) y
solo entonces se vuelca al `.arb` con `merge_lang.py`.

Instrucciones que valió la pena dar: terminología **oficial de Wizards** por
idioma (Kreatur/Créature/Creatura…), registro informal, y que los nombres de
logro son chistes — se traducen como chistes, no palabra por palabra.

## Al terminar

Cuando los diez estén completos: quitar el aviso `languagePartial` de Ajustes
("la app se está traduciendo por partes…") y su uso en `language_settings.dart`
y `language_picker_dialog.dart`.
