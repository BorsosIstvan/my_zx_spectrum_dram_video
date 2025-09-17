module ssram8k (
    input  wire        clk,
    input  wire        ce,       // top-level chip enable
    input  wire        oce,
    input  wire        reset,
    input  wire        wre,      // top-level write enable
    input  wire [12:0] ad,       // 13-bit adres (0..8191)
    inout  wire [7:0]  data_bus
);

    wire [7:0] ram0_dout;
    wire [7:0] ram1_dout;
    wire [7:0] ram2_dout;
    wire [7:0] ram3_dout;

    wire [1:0] bank_sel  = ad[12:11];
    wire [10:0] local_ad = ad[10:0];

    // Tri-state bus: alleen lezen als CE actief en write niet actief
    assign data_bus = (ce && !wre) ?
                      (bank_sel == 2'b00 ? ram0_dout :
                       bank_sel == 2'b01 ? ram1_dout :
                       bank_sel == 2'b10 ? ram2_dout :
                       ram3_dout)
                      : 8'bz;

    // RAM-instanties: wre enkel voor actief blok
    Gowin_RAM16S ram0_inst (
        .dout(ram0_dout),
        .clk(clk),
        .wre(wre && ce && (bank_sel == 2'b00)),
        .ad(local_ad),
        .di(data_bus)
    );

    Gowin_RAM16S ram1_inst (
        .dout(ram1_dout),
        .clk(clk),
        .wre(wre && ce && (bank_sel == 2'b01)),
        .ad(local_ad),
        .di(data_bus)
    );

    Gowin_RAM16S ram2_inst (
        .dout(ram2_dout),
        .clk(clk),
        .wre(wre && ce && (bank_sel == 2'b10)),
        .ad(local_ad),
        .di(data_bus)
    );

    Gowin_RAM16S ram3_inst (
        .dout(ram3_dout),
        .clk(clk),
        .wre(wre && ce && (bank_sel == 2'b11)),
        .ad(local_ad),
        .di(data_bus)
    );

endmodule
