#!/usr/bin/env bash
# Vérifie que chaque fichier référencé depuis SKILL.md existe réellement.
# Un renvoi cassé fait échouer silencieusement le chargement à la demande.
set -euo pipefail
cd "$(dirname "$0")/.."
skill_dir="ec-risk-advisor"
status=0
refs=$(grep -o '`\(references\|assets\)/[a-z_]*\.md`' "$skill_dir/SKILL.md" | tr -d '`' | sort -u)
for ref in $refs; do
  if [ ! -f "$skill_dir/$ref" ]; then
    echo "Renvoi cassé dans SKILL.md : $ref"
    status=1
  fi
done
for f in $(find "$skill_dir/references" "$skill_dir/assets" -name '*.md'); do
  rel="${f#$skill_dir/}"
  if ! grep -q "$rel" "$skill_dir/SKILL.md"; then
    echo "Fichier orphelin, jamais référencé depuis SKILL.md : $rel"
    status=1
  fi
done
exit $status
