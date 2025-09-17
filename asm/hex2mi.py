#!/usr/bin/env python3
import sys

def parse_simple_hex(filename, depth):
    """Lees bestand met 1 byte per regel (hex)"""
    memory = {addr: 0 for addr in range(depth)}
    with open(filename, "r") as f:
        addr = 0
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                byte = int(line, 16)
            except ValueError:
                continue
            if addr < depth:
                memory[addr] = byte
                addr += 1
            else:
                break
    return memory

def write_mi(memory, depth, outfile):
    with open(outfile, "w") as f:
        f.write("WIDTH=8;\n")
        f.write(f"DEPTH={depth};\n")
        f.write("ADDRESS_RADIX=HEX;\n")
        f.write("DATA_RADIX=HEX;\n")
        f.write("CONTENT BEGIN\n")

        for addr in range(depth):
            f.write(f"{addr:04X} : {memory[addr]:02X};\n")

        f.write("END;\n")

def main():
    if len(sys.argv) != 3:
        print("Gebruik: python hex2mi.py input.hex output.mi")
        sys.exit(1)

    infile = sys.argv[1]
    outfile = sys.argv[2]
    depth = 8192  # standaard 8 KB

    memory = parse_simple_hex(infile, depth)
    write_mi(memory, depth, outfile)
    print(f"MI bestand geschreven naar {outfile}")

if __name__ == "__main__":
    main()
