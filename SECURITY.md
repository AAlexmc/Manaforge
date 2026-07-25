# Seguridad

ManaForge es una app de escritorio sin cuentas, sin anuncios y sin telemetría. Tu colección vive **solo en tu máquina**. Este documento cuenta qué promete la app, qué no, y cómo avisar si encuentras un fallo de seguridad.

## Reportar una vulnerabilidad

**No abras un issue público.** Usa el canal privado del repo:

**[Security → Report a vulnerability](https://github.com/AAlexmc/Manaforge/security/advisories/new)**

Llega solo al mantenedor. Cuéntame qué encontraste, cómo reproducirlo y qué impacto tiene; respondo en cuanto pueda y el arreglo sale antes de hacer público el detalle. Para fallos normales (la app se cuelga, un número sale mal) los issues públicos van perfectos.

## Versiones con soporte

Solo la **última release publicada** recibe arreglos de seguridad. Si encuentras algo en una versión vieja, comprueba primero si la última lo tiene también.

## Modelo de seguridad

Lo que la app hace (y no hace) por diseño, verificado en una auditoría de todo el código (julio 2026):

### Tus datos no salen de tu máquina
- **Cero telemetría**: nada de analytics, crash reporters ni rastreadores. No existe ni la opción.
- Colección, mazos, logros y ajustes se guardan en tu carpeta de datos local. Las copias de seguridad (`.mfbak`) las haces y las llevas tú.
- No hay cuentas ni servidores propios: no guardamos nada tuyo porque no hay dónde.

### La red es una lista cerrada
La app solo hace peticiones **HTTPS de lectura** a estos sitios:

| Para qué | Dónde |
|---|---|
| Bases de datos (cartas, precios, huellas del escáner) | Releases de este repo en GitHub |
| Aviso de nueva versión y novedades | `api.github.com` (este repo) |
| Mazos del meta | `raw.githubusercontent.com` (este repo) |
| Imágenes de cartas | CDN de Scryfall (`cards.scryfall.io` y espejos) |

Cualquier otra URL que llegue en datos (un backup ajeno, un JSON manipulado) se descarta: las URLs de imagen solo pueden apuntar a los hosts de Scryfall, y las descargas rechazan `http://` incluso por redirección.

### Lo que entra de fuera se trata como hostil
- Todo lo descargado tiene **tope de tamaño** antes de tocar memoria o disco, y las bombas de descompresión en backups se cortan.
- Restaurar una copia de seguridad está fuera del flujo normal y exige escribir `CONFIRMAR`; los archivos dentro del backup no pueden escribir fuera de su carpeta (sin path traversal).
- SQL 100 % parametrizado y en modo solo-lectura sobre las bases descargadas.
- Los JSON locales se escriben de forma atómica (tmp + rename) y un archivo corrupto se aparta como `.roto` en vez de pisarse.

### La cadena de release también
- Los workflows de CI corren con **permisos mínimos** (solo el job de release puede escribir) y las acciones de terceros van fijadas por SHA.
- Cada release publica `SHA256SUMS.txt` con la huella de los tres binarios. Cómo comprobarla viene en las notas de cada release.

## Límites conocidos (honestidad ante todo)

- **Los binarios no van firmados** (la firma de código cuesta dinero y esto es gratis). Windows y macOS avisarán la primera vez. La huella SHA-256 publicada es tu forma de verificar la descarga.
- **Scryfall puede inferir qué cartas miras.** Los artes se piden a su CDN en vivo (tu IP + la carta pedida), sin cuentas ni cookies. Es inherente a enseñar imágenes que no distribuimos nosotros. Todo lo demás de la app funciona offline una vez descargadas las bases.
- **La comprobación de huella de las bases descargadas es best-effort**: si una release no publica `SHA256SUMS.txt`, la app descarga sin comparar (mitigado por host fijo de GitHub + TLS estricto).

## Alcance

Cuenta como vulnerabilidad todo lo que rompa las promesas de arriba: exfiltración de datos, ejecución de código vía datos descargados o backups, escritura fuera de las carpetas de la app, peticiones a hosts fuera de la lista. No cuenta: ataques que requieren acceso físico o root en tu propia máquina, o vulnerabilidades en las dependencias sin camino explotable desde la app (avísalas igual, pero como issue normal).
