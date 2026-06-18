#!/usr/bin/env bash
# Authority Surface Ops Skill — standard installer
# Installs skill files into ~/.claude/skills/ (or ./.claude/skills/ with --project)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skill"
SKILL_NAME="authority-surface-ops"
TARGET_BASE="${HOME}/.claude/skills"
SKIP_CONFIRM=false
PROJECT=false

usage() {
  cat <<EOF
Usage: ./install.sh [OPTIONS]

Install Authority Surface Ops Skill for Claude Code / Cursor agents.

Options:
  -y, --yes       Skip confirmation
  --project       Install to ./.claude/skills/ (project-local)
  -h, --help      Show this help

Also copies agents/ and commands/ when present.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes) SKIP_CONFIRM=true; shift ;;
    --project) PROJECT=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
done

if [[ "$PROJECT" == true ]]; then
  TARGET_BASE="$(pwd)/.claude/skills"
fi

TARGET_SKILL="${TARGET_BASE}/${SKILL_NAME}"
TARGET_AGENTS="${TARGET_BASE}/../agents"
TARGET_COMMANDS="${TARGET_BASE}/../commands"

if [[ "$PROJECT" == true ]]; then
  TARGET_AGENTS="$(pwd)/.claude/agents"
  TARGET_COMMANDS="$(pwd)/.claude/commands"
fi

echo "Authority Surface Ops Skill installer"
echo "  Skill  → ${TARGET_SKILL}"
echo "  Agents → ${TARGET_AGENTS} (if bundled)"
echo "  Commands → ${TARGET_COMMANDS} (if bundled)"
echo ""

if [[ "$SKIP_CONFIRM" == false ]]; then
  read -r -p "Proceed? [Y/n] " reply
  if [[ "${reply}" =~ ^[Nn]$ ]]; then
    echo "Cancelled."
    exit 0
  fi
fi

mkdir -p "${TARGET_BASE}" "${TARGET_AGENTS}" "${TARGET_COMMANDS}"

if [[ -d "${TARGET_SKILL}" ]]; then
  rm -rf "${TARGET_SKILL}"
fi
cp -R "${SOURCE_DIR}" "${TARGET_SKILL}"
echo "✓ Installed skill → ${TARGET_SKILL}"

if [[ -d "${SCRIPT_DIR}/agents" ]]; then
  for f in "${SCRIPT_DIR}"/agents/*.md; do
    [[ -f "$f" ]] || continue
    cp "$f" "${TARGET_AGENTS}/"
    echo "✓ Installed agent → ${TARGET_AGENTS}/$(basename "$f")"
  done
fi

if [[ -d "${SCRIPT_DIR}/commands" ]]; then
  for f in "${SCRIPT_DIR}"/commands/*.md; do
    [[ -f "$f" ]] || continue
    cp "$f" "${TARGET_COMMANDS}/"
    echo "✓ Installed command → ${TARGET_COMMANDS}/$(basename "$f")"
  done
fi

echo ""
echo "Installation complete."
echo "Example: \"Run launch-week authority surface audit for mint <ADDRESS>\""
echo "See README.md for usage. Recommended dependency: solana-dev-skill."
