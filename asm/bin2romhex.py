# bin2romhex.py
import sys

if len(sys.argv) != 3:
    print("Gebruik: python bin2romhex.py input.bin output.hex")
    sys.exit(1)

binfile = sys.argv[1]
hexfile = sys.argv[2]

with open(binfile, "rb") as f:
    data = f.read()

with open(hexfile, "w") as f:
    for byte in data:
        f.write(f"{byte:02X}\n")
