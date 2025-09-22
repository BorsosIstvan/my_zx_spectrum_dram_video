# ZX Spectrum FPGA Project

## EN

## Overview
This project implements a full **ZX Spectrum** on a **Gowin Tang Nano FPGA**.  
CPU, video, RAM, ROM, and I/O modules are fully functional. The HDMI output supports 1024x768 resolution with 4x pixel scaling to display the original 256x192 Spectrum screen.

---

## Hardware

- **FPGA:** Gowin Tang Nano 9K / 20K (depending on version)
- **CPU:** Z80
- **ROM:**
  - ROM0 and ROM1 contain the original 48K ZX Spectrum ROM (`48.rom`)
- **VRAM:** 8KB dual-port RAM for video (read by HDMI module)
- **RAM modules:**
  - RAM1, RAM2, RAM3: 8KB each (partially implemented, 16KB still needed for full 48KB)
- **I/O module:**
  - Generates `INT_n` for the CPU
  - Simulates the ENTER key

---

## Current Status

- CPU works and generates interrupts
- HDMI output correctly displays the Spectrum screen
- ROM and VRAM are functional
- ENTER key is implemented via a custom I/O module
- Some RAM blocks are operational (8KB each)
- The system can print letters and basic graphics to the screen

---

## To Do

1. Implement full 48KB RAM (additional 2 x 8KB needed)
2. Implement keyboard interface (more keys than just ENTER)
3. Sound (BEEP)
4. SD card support for loading/saving programs
5. Timing and stability optimization

---

## Project Structure

- `cpu/` – Z80 CPU core
- `ram/` – internal RAM modules (BSRAM, SSRAM)
- `rom/` – Spectrum 48K ROM
- `video/` – HDMI output module
- `io/` – input/output module (INT, keyboard)
- `docs/` – documentation, schematics
- `examples/` – example programs and test routines

---

## License
[MIT License](LICENSE)


# ZX Spectrum FPGA Project

## NL

## Overzicht
Dit project implementeert een volledige **ZX Spectrum** op een **Gowin Tang Nano FPGA**.  
De CPU, video, RAM, ROM en I/O modules zijn functioneel. HDMI-uitvoer ondersteunt een resolutie van 1024x768 waarbij elke pixel 4x wordt geschaald om het originele 256x192 Spectrum-scherm weer te geven.

---

## Hardware

- **FPGA:** Gowin Tang Nano 9K / 20K (afhankelijk van de versie)
- **CPU:** Z80
- **ROM:**
  - ROM0, ROM1 bevatten de originele 48K ZX Spectrum ROM (`48.rom`)
- **VRAM:** 8KB dual-port RAM voor video (gelezen door HDMI-module)
- **RAM modules:**
  - RAM1, RAM2, RAM3: elk 8KB (gedeeltelijk aanwezig, extra 16KB nog nodig voor volledige 48KB)
- **I/O module:**
  - Genereert `INT_n` voor CPU
  - Simuleert de ENTER-toets

---

## Huidige status

- CPU werkt en genereert interrupts
- HDMI-uitvoer toont correct het Spectrum-scherm
- ROM en VRAM functioneren
- De ENTER-toets is geïmplementeerd via een custom I/O module
- Sommige RAM-blokken zijn operationeel (8KB elk)
- Het systeem kan letters en basis graphics printen op het scherm

---

## Te doen

1. Volledige 48KB RAM implementeren (extra 2 x 8KB nodig)
2. Toetsenbordinterface implementeren (meer toetsen dan alleen ENTER)
3. Geluid (beep / BEEP)
4. SD-kaart ondersteuning voor laden/opslagen van programma's
5. Optimalisatie van timing en stabiliteit

---

## Project structuur

- `cpu/` – Z80 CPU core
- `ram/` – interne RAM modules (BSRAM, SSRAM)
- `rom/` – Spectrum 48K ROM
- `video/` – HDMI output module
- `io/` – input/output module (INT, toetsenbord)
- `docs/` – documentatie, schema’s
- `examples/` – voorbeeld programma’s en test routines

---

## Licentie
[MIT License](LICENSE)


# ZX Spectrum FPGA Projekt

## HU

## Áttekintés
Ez a projekt egy teljes **ZX Spectrum** implementációt valósít meg egy **Gowin Tang Nano FPGA**-n.  
A CPU, videó, RAM, ROM és I/O modulok működőképesek. Az HDMI kimenet 1024x768 felbontást támogat, minden pixel 4x-es skálázással jelenik meg az eredeti 256x192 Spectrum kijelzőhöz.

---

## Hardver

- **FPGA:** Gowin Tang Nano 9K / 20K (verziótól függően)
- **CPU:** Z80
- **ROM:**
  - ROM0, ROM1 tartalmazza az eredeti 48K ZX Spectrum ROM-ot (`48.rom`)
- **VRAM:** 8KB dual-port RAM a videóhoz (HDMI modul olvassa)
- **RAM modulok:**
  - RAM1, RAM2, RAM3: mindegyik 8KB (részben megvalósítva, további 16KB szükséges a teljes 48KB-hoz)
- **I/O modul:**
  - Generálja az `INT_n` jelet a CPU számára
  - ENTER billentyű szimulálása

---

## Jelenlegi állapot

- A CPU működik, generálja az interruptokat
- HDMI kimenet helyesen jeleníti meg a Spectrum képernyőt
- ROM és VRAM működnek
- ENTER billentyű implementálva van egy egyedi I/O modulon keresztül
- Néhány RAM blokk működik (mindegyik 8KB)
- A rendszer képes karaktereket és alap grafikát megjeleníteni a képernyőn

---

## Teendők

1. Teljes 48KB RAM implementálása (további 2 x 8KB szükséges)
2. Billentyűzet interfész implementálása (ENTER-en kívüli gombok)
3. Hang (BEEP)
4. SD kártya támogatás programok betöltéséhez / mentéséhez
5. Időzítés és stabilitás optimalizálása

---

## Projekt struktúra

- `cpu/` – Z80 CPU core
- `ram/` – belső RAM modulok (BSRAM, SSRAM)
- `rom/` – Spectrum 48K ROM
- `video/` – HDMI kimenet modul
- `io/` – input/output modul (INT, billentyűzet)
- `docs/` – dokumentáció, kapcsolási rajzok
- `examples/` – példa programok és teszt rutinok

---

## Licenc
[MIT License](LICENSE)
