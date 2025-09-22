module rom8k_0 (
    input wire clk,
    input wire reset,
    input wire oce,
    input wire ce,
    input wire iorq,
    input wire [12:0] ad,
    inout wire [7:0] data_bus
);

    wire [7:0] rom_dout;

Gowin_pROM_0 prom_0 (
    .clk(clk),
    .reset(reset),
    .oce(oce),          // active bij read
    .ce(ce),
    .ad(ad),
    .dout(rom_dout)           // tri-state in wrapper
);

    // Drie-staat verbinding
    assign data_bus = (ce && oce && !iorq) ? rom_dout : 8'bz;

endmodule