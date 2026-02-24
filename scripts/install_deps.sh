#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}--- Installing Dependencies (Yarn) ---${NC}"
(cd "${ROOT_DIR}" && yarn install)
echo -e "${GREEN}✔${NC} All workspace dependencies installed"

echo -e "${GREEN}--- Done ---${NC}"
