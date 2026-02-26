#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

CHECKER_BIN="${ROOT_DIR}/tools/changelog-checker-linux-amd64"
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ $(uname -m) == "arm64" ]]; then
    CHECKER_BIN="${ROOT_DIR}/tools/changelog-checker-darwin-arm64"
  else
    CHECKER_BIN="${ROOT_DIR}/tools/changelog-checker-darwin-amd64"
  fi
fi

if [ ! -f "${CHECKER_BIN}" ]; then
  echo -e "${RED}✖ Error: Changelog checker binary not found at ${CHECKER_BIN}${NC}"
  echo "Make sure the changelog-checker has been built and deployed."
  exit 1
fi

chmod +x "${CHECKER_BIN}"

FAILED=0

echo "🔍 Checking changelogs for all packages..."

for package_dir in "${ROOT_DIR}"/packages/*/; do
  if [ -d "${package_dir}" ]; then
    package_name=$(basename "${package_dir}")
    pkg_json="${package_dir}package.json"
    changelog="${package_dir}CHANGELOG.md"

    if [ ! -f "${pkg_json}" ]; then
      continue
    fi

    echo "📦 Package: ${package_name}..."

    if [ ! -f "${changelog}" ]; then
      echo -e "  ${YELLOW}⚠ No CHANGELOG.md found. Skipping.${NC}"
      continue
    fi

    if "${CHECKER_BIN}" "${pkg_json}" "${changelog}"; then
      :
    else
      FAILED=1
    fi
  fi
done

if [ "$FAILED" -ne 0 ]; then
  echo -e "\n${RED}✖ Some changelogs are invalid. Please fix them before merging.${NC}"
  exit 1
else
  echo -e "\n${GREEN}✔ All changelogs are valid!${NC}"
  exit 0
fi
