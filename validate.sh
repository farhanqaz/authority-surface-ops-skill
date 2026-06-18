#!/usr/bin/env bash
# Validate skill structure and internal links
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILL="${ROOT}/skill/SKILL.md"
PASS=0
FAIL=0

check() {
  if [[ "$2" -eq 0 ]]; then
    echo "PASS: $1"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
  fi
}

echo "Validating Authority Surface Ops Skill..."
echo ""

[[ -f "$SKILL" ]]; check "SKILL.md exists" $?

broken=0
while IFS= read -r link; do
  link="$(echo "$link" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  [[ -z "$link" ]] && continue
  target="${ROOT}/skill/${link}"
  if [[ ! -f "$target" ]]; then
    echo "FAIL: broken link -> $link"
    FAIL=$((FAIL + 1))
    broken=$((broken + 1))
  fi
done < <(grep -oE '\]\([^)]+\)' "$SKILL" | sed 's/\](//;s/)//' | grep -v '^http' | grep '\.md$')

[[ "$broken" -eq 0 ]] && check "SKILL.md local links resolve" 0 || true

[[ -x "${ROOT}/install.sh" ]]; check "install.sh executable" $?
[[ -f "${ROOT}/agents/authority-ops-engineer.md" ]]; check "agent exists" $?
[[ -f "${ROOT}/commands/authority-surface-audit.md" ]]; check "command exists" $?
[[ -f "${ROOT}/LICENSE" ]]; check "LICENSE exists" $?

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]]
