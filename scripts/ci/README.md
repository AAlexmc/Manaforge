# Workflow pendiente de instalar

`build-price-db.yml` construye la base de histórico de precios (MTGJSON →
SQLite) y la publica como release `price-db-latest`. Está aquí y no en
`.github/workflows/` porque el token de `gh` de la máquina de desarrollo no
tiene el permiso `workflow` y GitHub rechaza el push de ficheros de workflow.

Conviene además añadir `ijson` al `pip install` de `.github/workflows/ci.yml`
(hoy instala `pytest pillow`). Los tests de `build_price_history_db.py`
funcionan sin él —los fixtures son pequeños y caen a `json.load`—, pero con
`ijson` se ejerce el mismo camino de streaming que usa el build real.

Para instalarlo:

```sh
gh auth refresh -s workflow          # una vez, en una terminal propia
git mv scripts/ci/build-price-db.yml .github/workflows/build-price-db.yml
git commit -m "CI: workflow del histórico de precios" && git push
```

Mientras tanto la release se puede publicar a mano:

```sh
curl -sfL https://mtgjson.com/api/v5/AllPrices.json.gz -o AllPrices.json.gz
curl -sfL https://mtgjson.com/api/v5/AllIdentifiers.json.gz -o AllIdentifiers.json.gz
gunzip AllPrices.json.gz AllIdentifiers.json.gz
python3 scripts/build_price_history_db.py AllPrices.json AllIdentifiers.json manaforge_prices.sqlite
gzip -9 manaforge_prices.sqlite
gh release delete price-db-latest --yes || true
gh release create price-db-latest manaforge_prices.sqlite.gz --title "Histórico de precios"
```
