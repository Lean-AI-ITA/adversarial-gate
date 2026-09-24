#!/usr/bin/env bash
# Adversarial Gate — installer
#
# Copies the shared gate (core/, templates/, CALIBRATION.md, REFERENCES.md)
# plus the right adapter entry file into the target for your harness.
#
# Usage:
#   ./install.sh                 # detect + ask
#   ./install.sh --harness=NAME  # skip detection: claude-code | cursor | copilot | codex | opencode | aider
#   ./install.sh --list          # print detected candidates and exit
#
# Run this from a clone of the adversarial-gate repo, inside (or pointed at)
# the project you want to gate.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${ADVERSARIAL_GATE_TARGET:-$PWD}"
HARNESS=""

for arg in "$@"; do
  case "$arg" in
    --harness=*) HARNESS="${arg#*=}" ;;
    --list) LIST_ONLY=1 ;;
    *) echo "Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

detect() {
  local found=()
  [[ -d "$HOME/.claude" || -d "$TARGET_DIR/.claude" ]] && found+=("claude-code")
  [[ -d "$TARGET_DIR/.cursor" ]] && found+=("cursor")
  [[ -f "$TARGET_DIR/.github/copilot-instructions.md" || -d "$TARGET_DIR/.github" ]] && found+=("copilot")
  [[ -d "$HOME/.codex" ]] && found+=("codex")
  [[ -d "$TARGET_DIR/.opencode" || -d "$HOME/.config/opencode" ]] && found+=("opencode")
  [[ -f "$TARGET_DIR/.aider.conf.yml" ]] && found+=("aider")
  printf '%s\n' "${found[@]}"
}

echo "Adversarial Gate installer"
echo "Repo:   $REPO_DIR"
echo "Target: $TARGET_DIR"
echo

CANDIDATES=($(detect || true))

if [[ "${LIST_ONLY:-0}" == "1" ]]; then
  if [[ ${#CANDIDATES[@]} -eq 0 ]]; then
    echo "No harness markers detected in $TARGET_DIR or \$HOME."
  else
    echo "Detected: ${CANDIDATES[*]}"
  fi
  exit 0
fi

if [[ -z "$HARNESS" ]]; then
  echo "This is friction on purpose (see README §Is this for you?) — confirm before we copy anything."
  echo
  if [[ ${#CANDIDATES[@]} -gt 0 ]]; then
    echo "Detected possible harness(es): ${CANDIDATES[*]}"
  else
    echo "No harness markers detected — pick one manually."
  fi
  echo
  echo "  1) claude-code   4) codex"
  echo "  2) cursor        5) opencode"
  echo "  3) copilot       6) aider"
  read -rp "Which harness? [1-6]: " choice
  case "$choice" in
    1) HARNESS="claude-code" ;;
    2) HARNESS="cursor" ;;
    3) HARNESS="copilot" ;;
    4) HARNESS="codex" ;;
    5) HARNESS="opencode" ;;
    6) HARNESS="aider" ;;
    *) echo "Not a valid choice." >&2; exit 1 ;;
  esac
fi

copy_shared() {
  local dest="$1"
  mkdir -p "$dest"
  cp -r "$REPO_DIR/core" "$dest/"
  cp -r "$REPO_DIR/templates" "$dest/"
  cp "$REPO_DIR/CALIBRATION.md" "$dest/"
  cp "$REPO_DIR/REFERENCES.md" "$dest/"
}

case "$HARNESS" in
  claude-code)
    read -rp "Global (~/.claude/skills) or project (.claude/skills)? [g/p]: " scope
    if [[ "$scope" == "p" ]]; then
      DEST="$TARGET_DIR/.claude/skills/adversarial-gate"
    else
      DEST="$HOME/.claude/skills/adversarial-gate"
    fi
    copy_shared "$DEST"
    cp -r "$REPO_DIR/docs" "$REPO_DIR/examples" "$DEST/" 2>/dev/null || true
    cp "$REPO_DIR/adapters/claude-code/SKILL.md" "$DEST/SKILL.md"
    echo "Installed to $DEST"
    echo "Open a new Claude Code session — skills load at startup, not mid-session."
    ;;
  cursor)
    copy_shared "$TARGET_DIR"
    mkdir -p "$TARGET_DIR/.cursor/rules"
    cp "$REPO_DIR/adapters/cursor/adversarial-gate.mdc" "$TARGET_DIR/.cursor/rules/adversarial-gate.mdc"
    echo "Installed core files to $TARGET_DIR, rule to .cursor/rules/adversarial-gate.mdc"
    echo "Mode: Agent Requested. @-mention it to force-attach; Cursor has no '/' command for rules."
    ;;
  copilot)
    copy_shared "$TARGET_DIR"
    mkdir -p "$TARGET_DIR/.github/prompts"
    cp "$REPO_DIR/adapters/copilot/adversarial-gate.prompt.md" "$TARGET_DIR/.github/prompts/adversarial-gate.prompt.md"
    echo "Installed core files to $TARGET_DIR, prompt to .github/prompts/adversarial-gate.prompt.md"
    echo "Invoke with /adversarial-gate in Copilot Chat."
    ;;
  codex)
    copy_shared "$TARGET_DIR"
    mkdir -p "$HOME/.codex/prompts"
    cp "$REPO_DIR/adapters/codex/adversarial-gate.md" "$HOME/.codex/prompts/adversarial-gate.md"
    echo "Installed core files to $TARGET_DIR, prompt to ~/.codex/prompts/adversarial-gate.md"
    echo "Invoke with /prompts:adversarial-gate. Consider also pointing this project's AGENTS.md at core/GATE.md."
    ;;
  opencode)
    copy_shared "$TARGET_DIR"
    mkdir -p "$TARGET_DIR/.opencode/commands"
    cp "$REPO_DIR/adapters/opencode/adversarial-gate.md" "$TARGET_DIR/.opencode/commands/adversarial-gate.md"
    echo "Installed core files to $TARGET_DIR, command to .opencode/commands/adversarial-gate.md"
    echo "Invoke with /adversarial-gate."
    ;;
  aider)
    copy_shared "$TARGET_DIR"
    cp "$REPO_DIR/adapters/aider/CONVENTIONS.md" "$TARGET_DIR/adversarial-gate-CONVENTIONS.md"
    echo "Installed core files to $TARGET_DIR"
    echo "Add to .aider.conf.yml:"
    echo "  read:"
    echo "    - core/GATE.md"
    echo "    - adversarial-gate-CONVENTIONS.md"
    ;;
  *)
    echo "Unknown harness: $HARNESS" >&2
    exit 1
    ;;
esac
