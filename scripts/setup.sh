#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== npm-packages Monorepo Setup ===${NC}\n"

echo -e "${BLUE}[1/2]${NC} Initializing configurations..."
bash "${SCRIPT_DIR}/init_configs.sh"

echo -e "${BLUE}[2/2]${NC} Installing dependencies..."
bash "${SCRIPT_DIR}/install_deps.sh"

echo -e "\n${GREEN}✅ Setup complete!${NC}"
echo -e "${BLUE}Run 'yarn create-package' to scaffold a new package.${NC}"
