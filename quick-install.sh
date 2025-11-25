#!/bin/bash

# Farben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Docker Installation wird gestartet   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Prüfen ob als root ausgeführt
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}[ERROR] Dieses Script muss als root ausgeführt werden!${NC}"
    echo -e "${YELLOW}[INFO] Bitte mit 'sudo bash install.sh' ausführen${NC}"
    exit 1
fi

# Script herunterladen
SCRIPT_URL="https://raw.githubusercontent.com/StaksiPingu/Dockerinstaller/refs/heads/main/Dockerinstaller"
TEMP_SCRIPT="/tmp/docker-installer.sh"

echo -e "${GREEN}[INFO] Lade Installationsskript herunter...${NC}"

if command -v curl &> /dev/null; then
    curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT"
elif command -v wget &> /dev/null; then
    wget -q "$SCRIPT_URL" -O "$TEMP_SCRIPT"
else
    echo -e "${RED}[ERROR] Weder curl noch wget gefunden!${NC}"
    echo -e "${YELLOW}[INFO] Installiere curl...${NC}"
    apt-get update
    apt-get install -y curl
    curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT"
fi

# Prüfen ob Download erfolgreich
if [ ! -f "$TEMP_SCRIPT" ]; then
    echo -e "${RED}[ERROR] Download fehlgeschlagen!${NC}"
    echo -e "${YELLOW}[INFO] URL: $SCRIPT_URL${NC}"
    exit 1
fi

# Prüfen ob Datei nicht leer ist
if [ ! -s "$TEMP_SCRIPT" ]; then
    echo -e "${RED}[ERROR] Heruntergeladene Datei ist leer!${NC}"
    rm -f "$TEMP_SCRIPT"
    exit 1
fi

# Ausführbar machen
chmod +x "$TEMP_SCRIPT"

# Ausführen
echo -e "${GREEN}[INFO] Starte Installation...${NC}"
echo ""

bash "$TEMP_SCRIPT"

# Exit-Code des Scripts speichern
EXIT_CODE=$?

# Aufräumen
rm -f "$TEMP_SCRIPT"

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}[INFO] Installation abgeschlossen!${NC}"
else
    echo -e "${RED}[ERROR] Installation mit Fehler beendet (Exit-Code: $EXIT_CODE)${NC}"
fi

exit $EXIT_CODE
