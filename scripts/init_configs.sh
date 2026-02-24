#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${BLUE}--- Configuration Check ---${NC}"

REQUIRED_NODE_MAJOR=24
REQUIRED_NODE_MINOR=14
CURRENT_NODE_VERSION=$(node -v | sed 's/v//')
CURRENT_NODE_MAJOR=$(echo "${CURRENT_NODE_VERSION}" | cut -d. -f1)
CURRENT_NODE_MINOR=$(echo "${CURRENT_NODE_VERSION}" | cut -d. -f2)

if [ "${CURRENT_NODE_MAJOR}" -lt "${REQUIRED_NODE_MAJOR}" ] || \
   ([ "${CURRENT_NODE_MAJOR}" -eq "${REQUIRED_NODE_MAJOR}" ] && [ "${CURRENT_NODE_MINOR}" -lt "${REQUIRED_NODE_MINOR}" ]); then
  echo -e "${YELLOW}⚠  Node.js >= ${REQUIRED_NODE_MAJOR}.${REQUIRED_NODE_MINOR}.0 required. Current: v${CURRENT_NODE_VERSION}${NC}"
  echo -e "${YELLOW}   Install via: nvm install 24.14.0${NC}"
  exit 1
fi
echo -e "${GREEN}✔${NC} Node.js v${CURRENT_NODE_VERSION}"

if ! command -v yarn &> /dev/null; then
  echo -e "${YELLOW}⚠  Yarn is not installed. Run: corepack enable${NC}"
  exit 1
fi

YARN_VERSION=$(yarn --version)
YARN_MAJOR=$(echo "${YARN_VERSION}" | cut -d. -f1)
if [ "${YARN_MAJOR}" -lt 4 ]; then
  echo -e "${YELLOW}⚠  Yarn 4.x required. Current: ${YARN_VERSION}${NC}"
  echo -e "${YELLOW}   Run: corepack use yarn@4${NC}"
  exit 1
fi
echo -e "${GREEN}✔${NC} Yarn ${YARN_VERSION}"

if [ ! -f "${ROOT_DIR}/tsconfig.json" ]; then
  echo -e "${YELLOW}⚠  Root tsconfig.json missing.${NC}"
  exit 1
fi
echo -e "${GREEN}✔${NC} tsconfig.json present"

if [ ! -f "${ROOT_DIR}/eslint.config.mjs" ]; then
  echo -e "${YELLOW}⚠  Root eslint.config.mjs missing.${NC}"
  exit 1
fi
echo -e "${GREEN}✔${NC} eslint.config.mjs present"

echo -e "${GREEN}--- All configurations verified ---${NC}"
