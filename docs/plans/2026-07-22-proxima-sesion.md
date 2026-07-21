# ManaForge · dónde retomar (nota del 2026-07-21 noche)

## Estado ahora mismo

- `main` = `c48fc28`. Rama viva: **`feat/carpetas-y-logros`** → **PR #4 abierto,
  CI verde**, 334 tests, `flutter analyze` limpio.
- La app corre en Linux (tmux `manaforge`) con las bases NUEVAS instaladas y sin
  excepciones, con la colección real de Ale (283 cartas).
- **Nada de la UI nueva está validado a mano.** Es lo primero: abrir la app,
  probar carpetas, logros, certificado, PNG y el selector de mercado, y decir qué
  chirría. Después, mergear el PR.

## Lo que entró en el PR #4

1. **Carpetas en Colección** — portada de carpetas con su valor (misma fórmula que
   Inicio y Mercado), lista completa tras "Todas las cartas", selector de cartas
   con los filtros de siempre. `folders.json`.
   Cuatro decisiones tomadas sin Ale, **pendientes de confirmar**: una carta puede
   estar en varias carpetas · carpeta ≠ mazo · solo pertenencia (la cantidad la
   manda la colección) · borrar una carta de la colección NO la quita de las
   carpetas.
2. **Logros y niveles** — 104 logros en 11 categorías, XP por rareza, rangos
   Aprendiz → Planeswalker, pantalla propia, tarjeta en Inicio, avisos.
   Con la colección de Ale: 40/104, nivel 6.
3. **Certificados** — por expansión completa, con nombre, fecha y código, y
   descarga en PNG.
4. **Mercado multi-proveedor** — Cardmarket · TCGplayer · Card Kingdom · Mana Pool
   · Cardhoarder. Cambia el precio de la carta, **el de cada edición**, el de la
   expansión y las gráficas. No se convierten divisas.
5. **Arreglos de datos** (de dos pasadas de review): guardado en cola + atómico en
   los cinco almacenes, `load()` que no se come la colección ante un JSON raro,
   vender una carta baja también sus printings y foils, foils del CSV de ManaBox.

## Bases publicadas (releases)

- `price-db-latest`: 167.308 series = 5 mercados × ~33k cartas × 91 días, 13 MB gz.
- `card-db-latest`: schema 4, con `price_usd`, `price_usd_foil` y `price_tix`.
- Regenerar en local (tarda ~2 min cada una, hace falta `ijson`):
  ```bash
  # histórico (MTGJSON, 1,8 GB descomprimido)
  curl -sfL https://mtgjson.com/api/v5/AllPrices.json.gz -o AllPrices.json.gz
  curl -sfL https://mtgjson.com/api/v5/AllIdentifiers.json.gz -o AllIdentifiers.json.gz
  gunzip AllPrices.json.gz AllIdentifiers.json.gz
  python3 scripts/build_price_history_db.py AllPrices.json AllIdentifiers.json manaforge_prices.sqlite
  # cartas (bulk default-cards de Scryfall, 532 MB)
  python3 scripts/build_card_db.py bulk.json manaforge_cards.sqlite 2026-07-21
  ```
  Publicar: `gh release delete <tag> --yes && gh release create <tag> <fichero>.gz`.
  El workflow de CI para el histórico sigue en `scripts/ci/build-price-db.yml`
  (sin instalar) porque el token de esta máquina no tiene scope `workflow`:
  `gh auth refresh -s workflow` lo desbloquea.

## Siguiente tanda (en orden)

1. **Validar la UI y mergear el PR #4.**
2. **Pestaña "Escanear"** propia en la barra de abajo (bloque D): foto de carta,
   página de álbum, escáner en vivo e importar CSV. Hoy escanear está escondido
   dentro de Colección.
3. **Precio de compra y P&L** — el CSV de ManaBox trae `Purchase price` y ahora
   mismo se tira. Guardarlo permitiría "te costó X, vale Y" por carta y para toda
   la colección, que es lo que ningún competidor enseña bien.
4. **Copia de seguridad / restaurar** — exportar los JSON (colección, carpetas,
   mazos, logros, wishlist) a un fichero y volver a importarlo. Hoy todo vive solo
   en `~/.local/share/com.example.manaforge/`.
5. **Divisas (bloque B)** — decidido NO convertir por ahora. Si se hace: tipos del
   BCE (frankfurter.app), marcado como aproximado y los tix fuera.

## Trampas que ya nos han costado tiempo

- `flutter test` de un fichero NUEVO puede tardar >2 min compilando: lanzarlo en
  segundo plano y **no** pipear a `tail` (no escribe nada hasta terminar).
- En `testWidgets`, `await` sobre algo que toca path_provider/sqlite **se cuelga**
  con el reloj falso: envolver en `tester.runAsync(...)`.
- Nada de `pumpAndSettle` en pantallas con `LinearProgressIndicator`: animan
  siempre.
- Las listas son perezosas: en un test, una fila 20 posiciones abajo no existe
  hasta hacer `drag`.
- Los pantallazos de Ale pueden venir recortados de una ventana más ancha: medir
  antes de "arreglar" una barra de progreso que no está rota.
