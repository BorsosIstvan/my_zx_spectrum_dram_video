import sys
import os

def write_mi(filename, data, depth=8192):
    with open(filename, "w") as f:
        f.write("WIDTH=8;\n")
        f.write(f"DEPTH={depth};\n")
        f.write("ADDRESS_RADIX=HEX;\n")
        f.write("DATA_RADIX=HEX;\n")
        f.write("CONTENT BEGIN\n")
        for addr in range(depth):
            val = data[addr] if addr < len(data) else 0
            f.write(f"{addr:04X} : {val:02X};\n")
        f.write("END;\n")

def main():
    if len(sys.argv) < 2:
        print("Gebruik: python bin2mi.py 48.rom")
        sys.exit(1)

    infile = sys.argv[1]

    with open(infile, "rb") as f:
        romdata = f.read()

    if len(romdata) < 16384:
        print(f"Bestand {infile} is te klein ({len(romdata)} bytes). Verwacht 16384.")
        sys.exit(1)

    # eerste 8K
    rom0 = romdata[:8192]
    write_mi("48rom0.mi", rom0)

    # tweede 8K
    rom1 = romdata[8192:16384]
    write_mi("48rom1.mi", rom1)

    print("Klaar! Bestanden 48rom0.mi en 48rom1.mi zijn aangemaakt.")

if __name__ == "__main__":
    main()
