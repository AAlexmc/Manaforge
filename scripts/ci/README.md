# (vacío por ahora)

Aquí vivía `build-price-db.yml` mientras el token de la máquina de desarrollo
no tenía el permiso `workflow` y GitHub rechazaba el push de ficheros de
workflow. Desde el 22-07-2026 el permiso está puesto y el workflow vive donde
tiene que vivir: `.github/workflows/build-price-db.yml`.

Si algún día vuelve a pasar (token nuevo sin el permiso):

```sh
gh auth refresh -h github.com -s workflow   # en una terminal de verdad, pide navegador
```

Y mientras tanto, la release del histórico se puede publicar a mano:

```sh
curl -sfL https://mtgjson.com/api/v5/AllPrices.json.gz -o AllPrices.json.gz
curl -sfL https://mtgjson.com/api/v5/AllIdentifiers.json.gz -o AllIdentifiers.json.gz
gunzip AllPrices.json.gz AllIdentifiers.json.gz
python3 scripts/build_price_history_db.py AllPrices.json AllIdentifiers.json manaforge_prices.sqlite
gzip -9 manaforge_prices.sqlite
sha256sum manaforge_prices.sqlite.gz | tee SHA256SUMS.txt
gh release delete price-db-latest --yes || true
gh release create price-db-latest manaforge_prices.sqlite.gz SHA256SUMS.txt \
  --title "Histórico de precios"
```
