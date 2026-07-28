#!/usr/bin/env bash
# uso: tool/refactor/move.sh <ruta-vieja-bajo-lib> <ruta-nueva-bajo-lib>
set -euo pipefail
cd "$(dirname "$0")/../.."  # app/
old="$1"; new="$2"
mkdir -p "lib/$(dirname "$new")"
git mv "lib/$old" "lib/$new"
grep -rl --include='*.dart' "package:manaforge_app/$old" lib test \
  | xargs -r sed -i "s|package:manaforge_app/$old|package:manaforge_app/$new|g"
