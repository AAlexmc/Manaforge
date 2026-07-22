# Más fuentes de meta para el Modo Test: qué dicen sus términos

Nota del 22-07-2026 (noche). Pedido por Ale: "Modo Test con más fuentes de
meta; hoy solo MTGGoldfish; añadir untapped.gg y mtgdecks.net, semanal o a
petición. **Aviso: antes hay que mirar los términos de uso de cada sitio — las
listas de cartas son datos, pero raspar su web es otra cosa.**"

Esto es lo que se ha mirado. **No se ha escrito ni una línea de raspador.**

## Cómo funciona HOY (importa para entender el resto)

No hay ningún raspador. `data/meta_decks.json` es un fichero **curado a mano**
en el repo, con `source: "MTGGoldfish · listas reales de torneo"`, y la app se
lo baja de `raw.githubusercontent.com` y lo cachea 24 h
(`app/lib/services/meta_decks.dart`). O sea: una persona lee el meta, escribe
las listas y las atribuye.

Eso cambia la pregunta. No es "¿puedo seguir haciendo lo que hago?" sino
"¿puedo automatizar lo que hoy hago a mano?".

## Lo que dicen los sitios

### mtgdecks.net — **no**

Su `robots.txt` (leído el 22-07-2026):

```
User-agent: *
Disallow: /cards/csv/
Disallow: */txt
...
User-agent: MTGMeta-Scraper
Disallow: /
User-agent: ClaudeBot
Disallow: /
User-agent: anthropic-ai
Disallow: /
User-agent: GPTBot
Disallow: /
```

Dos cosas, y las dos apuntan igual:

1. `Disallow: */txt` y `/cards/csv/` cierran **para todo el mundo** justo los
   sitios de donde saldrían las listas (el export en texto plano y el CSV de
   cartas). Lo que queda permitido es el HTML de lectura, no la exportación.
2. Tienen una línea con nombre y apellidos para un `MTGMeta-Scraper`, y banean
   a los bots de IA. Han tenido el problema y han contestado que no.

Además, su página de términos devuelve **403 a una petición automática**
(protección antibot), lo cual es en sí mismo una respuesta.

**Veredicto: no se raspa.** Ni con retardo, ni "solo una vez a la semana".

### untapped.gg (HearthSim, LLC) — **no sin permiso por escrito**

- Su `robots.txt` es permisivo (`User-agent: * / Allow: /`), pero eso NO es una
  licencia: es la puerta, no el contrato. Los términos mandan.
- Los términos (`untapped.gg/legal/terms-of-service`) están detrás de un
  render de JavaScript y no se han podido leer de forma automática. **Hay que
  leerlos a mano en el navegador antes de nada.**
- Y hay un motivo de fondo más fuerte: los datos de untapped.gg salen del
  `Player.log` de **sus usuarios** (la Companion lee el log de MTG Arena en
  local y lo sube). Eso no es un boletín público de torneos: es telemetría de
  personas. Reutilizarla en otra app pide permiso explícito, no interpretación
  favorable de una cláusula.

**Veredicto: no, salvo que Ale escriba a support@untapped.gg y le digan que sí
por escrito** (y aun así, atribuyendo).

### MTGGoldfish (la de ahora) — se puede leer, no descargar

Su `robots.txt` deja pasar a los bots genéricos (`Allow: /`) pero corta en
seco justo lo interesante:

```
Disallow: /deck/download*
Disallow: /embed/decklist
```

Y encabeza el fichero con un `Content-Signal: search=yes,ai-train=no,use=reference`,
que es una reserva de derechos expresa (art. 4 de la Directiva UE 2019/790).

Traducido: **lo que se hace hoy —una persona mira, escribe la lista a mano y
cita la fuente— encaja. Un descargador automático apuntando a `/deck/download`
no.** Su página de términos también responde 403 a peticiones automáticas.

### magic.gg / Wizards — la única puerta abierta de par en par

`magic.gg/robots.txt` es `User-agent: * / Disallow:` (sin restricciones), y las
listas de los torneos oficiales las publica el dueño del juego. Si algún día
se quiere automatizar de verdad, **este es el sitio por donde empezar**: es
quien tiene los derechos sobre las cartas y quien publica los resultados.

## Recomendación

1. **No hacer raspador de mtgdecks.net ni de untapped.gg.** El primero dice que
   no en su `robots.txt`; el segundo no ha dejado leer sus términos y encima
   sus datos son de sus usuarios.
2. **Más fuentes, sí; automáticas, no (todavía).** `meta_decks.json` admite un
   campo `source` por mazo: se pueden meter listas de MTGGoldfish, de
   mtgdecks.net y de untapped.gg **leídas y escritas a mano**, cada una con su
   atribución. Copiar una lista de cartas que ya salió en un torneo público y
   decir de dónde viene es lo que hace todo el mundo en este mundillo; lo que
   no se puede es montarse un grifo automático sobre la web de otro.
3. **Si Ale quiere refresco automático semanal**, el camino es magic.gg /
   resultados oficiales de Wizards, no las webs de terceros. Es más trabajo
   (el formato es HTML de artículo, no un JSON) pero es el único que no vive de
   la buena voluntad de nadie.
4. **Lo que da más valor por menos riesgo**: un importador de "pega aquí tu
   lista" en el Modo Test. El usuario copia de donde quiera —es él quien
   accede a esa web, con su navegador, como cualquier lector— y la app la
   entiende. Cero raspado, cero términos ajenos, y funciona con CUALQUIER
   fuente, presente o futura.

## Qué queda por hacer (para la próxima sesión)

- [ ] Ale lee `untapped.gg/legal/terms-of-service` en el navegador (no se pudo
      leer automáticamente) y decide.
- [ ] Decidir entre (3) magic.gg automático y (4) pegar lista a mano. La
      recomendación es (4) primero: es una tarde de trabajo y no depende de
      nadie.
- [ ] Mientras tanto, ampliar `data/meta_decks.json` a mano con más formatos y
      poner `source` **por mazo** en vez de uno global.

Fuentes consultadas el 22-07-2026: `mtgdecks.net/robots.txt`,
`untapped.gg/robots.txt`, `www.mtggoldfish.com/robots.txt`,
`magic.gg/robots.txt`, footer de `mtga.untapped.gg` (operador: HearthSim, LLC).
