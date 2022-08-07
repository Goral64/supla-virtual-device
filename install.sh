#!/usr/bin/env bash

cd "$(dirname "$0")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Getting the sources."

if [ ! -d src ]; then
  git clone https://github.com/Goral64/supla-core.git -q --single-branch --branch supla-virtual-device src >/dev/null || exit 1
fi

(cd src && git pull >/dev/null && cd ..) || exit 1

echo "Building. Be patient."

(cd src/supla-virtual-device/Release && make all >/dev/null 2>&1 && cd ../../..) || exit 1

if [ ! -f supla-virtual-device ]; then
  ln -s src/supla-virtual-device/Release/supla-virtual-device supla-virtual-device
fi

echo -e "${GREEN}OK!${NC}"
./supla-virtual-device -v

if [ ! -f supla-virtual-device.cfg ]; then
  cp supla-virtual-device.cfg.sample supla-virtual-device.cfg
  echo -e "${YELLOW}Sample configuration has been created for you (${NC}supla-virtual-device.cfg${YELLOW})${NC}"
  echo -e "${YELLOW}Adjust it to your needs before launching.${NC}"
fi
