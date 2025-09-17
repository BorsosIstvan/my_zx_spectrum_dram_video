module vram8k (
    input  wire        clk,       // klok voor CPU-poort (A)
    input  wire        reset,     // reset voor CPU-poort (A)
    input  wire        oce,       // output enable CPU
    input  wire        ce,        // chip select CPU
    input  wire        wre,       // write enable CPU
    input  wire [12:0] ad,        // adres CPU
    inout  wire [7:0]  data_bus,  // tri-state data bus CPU
    // Video poort B
    input  wire        vclk,      // klok voor video
    input  wire        vce,       // chip select video
    output wire [7:0]  vdata,     // video output
    input  wire [12:0] vad        // video adres
);

    wire [7:0] ram_dout;

    // Instantie van de dual-port RAM
    Gowin_DPB dpb_inst (
        .douta(ram_dout),    // CPU read data
        .doutb(vdata),    // Video read data
        .clka(clk),
        .ocea(oce),
        .cea(ce),
        .reseta(reset),
        .wrea(wre),
        .clkb(vclk),
        .oceb(1'b1),      // video poort altijd lezen
        .ceb(vce),
        .resetb(reset),
        .wreb(1'b0),      // video poort nooit schrijven
        .ada(ad),
        .dina(data_bus),
        .adb(vad),
        .dinb(8'b0)
    );

    // Tri-state verbinding voor CPU
    assign data_bus = (ce && oce && !wre) ? ram_dout : 8'bz;

endmodule
