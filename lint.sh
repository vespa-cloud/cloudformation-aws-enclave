#!/bin/bash

# Helper script to lint template files using cfn-lint

set -uo pipefail

BLUE="\033[1;34m"
RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[0m"

TEMPLATE_DIR="templates"
EXIT_CODE=0
FAILED=()

echo "🔍 Running cfn-lint on all YAML templates in '$TEMPLATE_DIR'..."

# Safely iterate over matches (no subshell), supporting spaces/newlines in filenames
while IFS= read -r -d '' file; do
  echo -e "${BLUE}Linting: $file${RESET}"
  if cfn-lint --non-zero-exit-code error -t "$file"; then
    echo -e "✅ ${GREEN}$file passed linting.${RESET}"
    echo
  else
    echo -e "${RED}❌ $file failed linting.${RESET}"
    echo
    FAILED+=("$file")
    EXIT_CODE=1
  fi
done < <(find "$TEMPLATE_DIR" -type f -name "*.yml" -print0)

if [ "$EXIT_CODE" -eq 0 ]; then
  echo -e "🎉${GREEN} All templates linted successfully!${RESET}"
else
  echo -e "${RED}Some templates failed linting:${RESET}"
  for f in "${FAILED[@]}"; do
    echo "   - $f"
  done
fi

exit "$EXIT_CODE"
