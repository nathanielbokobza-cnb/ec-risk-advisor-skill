#!/usr/bin/env bash
# Controles de conformite avant packaging.
# 1. Frontmatter YAML valide, champs name et description presents
# 2. description <= 1024 caracteres (limite d'import Claude.ai)
# 3. Aucun renvoi casse depuis SKILL.md, aucun fichier de reference orphelin
set -euo pipefail
cd "$(dirname "$0")/.."
skill_dir="ec-risk-advisor"
status=0

python3 - "$skill_dir/SKILL.md" << 'PY'
import sys, yaml
path = sys.argv[1]
text = open(path, encoding='utf-8').read()
if not text.startswith('---'):
    sys.exit("Frontmatter YAML absent")
fm = text.split('---')[1]
try:
    data = yaml.safe_load(fm)
except Exception as e:
    sys.exit(f"Frontmatter YAML invalide : {e}")
for field in ('name', 'description'):
    if not data.get(field):
        sys.exit(f"Champ '{field}' manquant")
desc = data['description'].strip()
if len(desc) > 1024:
    sys.exit(f"Champ 'description' : {len(desc)} caracteres, limite 1024. Reduire de {len(desc)-1024}.")
print(f"  frontmatter OK - description {len(desc)}/1024 caracteres")
PY

refs=$(grep -o '`\(references\|assets\)/[a-z_]*\.md`' "$skill_dir/SKILL.md" | tr -d '`' | sort -u)
for ref in $refs; do
  if [ ! -f "$skill_dir/$ref" ]; then
    echo "  Renvoi casse dans SKILL.md : $ref"
    status=1
  fi
done
for f in $(find "$skill_dir/references" "$skill_dir/assets" -name '*.md'); do
  rel="${f#$skill_dir/}"
  if ! grep -q "$rel" "$skill_dir/SKILL.md"; then
    echo "  Fichier orphelin, jamais reference depuis SKILL.md : $rel"
    status=1
  fi
done
exit $status
