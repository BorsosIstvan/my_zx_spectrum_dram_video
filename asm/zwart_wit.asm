        ORG 0000h
        LD SP,$6000

; --- Bitmap vullen met patroon $3C ---
        LD HL,$4000
        LD DE,$5800
        LD A,$3C
L1:     LD (HL),A
        INC HL
        LD A,H
        CP D
        JR NZ,L1
        LD A,L
        CP E
        JR NZ,L1

; --- Attributen vullen met WIT OP ZWART ($07) ---
        LD HL,$5800
        LD DE,$5B00
        LD A,$07
L2:     LD (HL),A
        INC HL
        LD A,H
        CP D
        JR NZ,L2
        LD A,L
        CP E
        JR NZ,L2

STOP:   JR STOP
