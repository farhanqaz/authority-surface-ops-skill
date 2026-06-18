#!/usr/bin/env bash
# Validate skill structure, links, and agent/command frontmatter
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
  [[ "$link" == http* ]] && continue
  target="${ROOT}/skill/${link}"
  if [[ ! -f "$target" ]]; then
    echo "FAIL: broken link in SKILL.md -> $link"
    FAIL=$((FAIL + 1))
    broken=$((broken + 1))
  fi
done < <(grep -oE '\]\([^)]+\)' "$SKILL" | sed 's/\](//;s/)//' | grep '\.md$')

[[ "$broken" -eq 0 ]] && check "SKILL.md local links resolve" 0 || true

module_fail=0
for f in "${ROOT}"/skill/*.md; do
  [[ -f "$f" ]] || continue
  [[ "$(basename "$f")" == "SKILL.md" ]] && continue
  lines=$(wc -l < "$f")
  if [[ "$lines" -lt 20 ]]; then
    echo "FAIL: $(basename "$f") too short ($lines lines)"
    module_fail=$((module_fail + 1))
  fi
done
[[ "$module_fail" -eq 0 ]]; check "skill modules meet minimum depth" $?

AGENT="${ROOT}/agents/authority-ops-engineer.md"
if [[ -f "$AGENT" ]] && head -1 "$AGENT" | grep -q '^---'; then
  fm=$(awk '/^---$/{c++;next} c==1{print; if(NR>30)exit}' "$AGENT")
  echo "$fm" | grep -q '^name:' && check "agent has name" 0 || check "agent has name" 1
  echo "$fm" | grep -q '^description:' && check "agent has description" 0 || check "agent has description" 1
  echo "$fm" | grep -q '^model:' && check "agent has model" 0 || check "agent has model" 1
  grep -q '../skills/authority-surface-ops/' "$AGENT" && check "agent uses installed skill paths" 0 || check "agent uses installed skill paths" 1
else
  check "agent frontmatter" 1
fi

CMD="${ROOT}/commands/authority-surface-audit.md"
if [[ -f "$CMD" ]] && head -1 "$CMD" | grep -q '^---'; then
  fm=$(awk '/^---$/{c++;next} c==1{print; if(NR>15)exit}' "$CMD")
  echo "$fm" | grep -q '^description:' && check "command has description" 0 || check "command has description" 1
else
  check "command frontmatter" 1
fi

[[ -x "${ROOT}/install.sh" ]]; check "install.sh executable" $?
[[ -x "${ROOT}/scripts/check-mint-authorities.sh" ]]; check "check-mint-authorities.sh executable" $?
[[ -f "${ROOT}/LICENSE" ]]; check "LICENSE exists" $?
[[ -f "${ROOT}/docs/KIT_INTEGRATION.md" ]]; check "KIT_INTEGRATION.md exists" $?

for report in launch-go-ray.yaml launch-no-go-active-authorities.yaml drift-critical-mint.yaml upgrade-immutable-program.yaml weekly-review-clean.yaml; do
  [[ -f "${ROOT}/examples/reports/${report}" ]] && check "example report ${report}" 0 || check "example report ${report}" 1
done

[[ -f "${ROOT}/examples/output/ray-mainnet-report.txt" ]]; check "live output ray-mainnet" $?

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]]
