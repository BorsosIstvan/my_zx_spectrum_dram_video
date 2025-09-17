module ram8k (
    input wire clk,
    input wire oce,
    input wire ce,
    input wire reset,
    input wire wre,             // write enable
    input wire [12:0] ad,
    inout wire [7:0] data_bus
);

    wire [7:0] ram_dout;

    // Instantie van de RAM core
    Gowin_SP ram_inst (
        .dout(ram_dout),    // output [7:0]
        .clk(clk),           // input clk
        .oce(oce),           // input oce
        .ce(ce),             // input ce
        .reset(reset),       // input reset
        .wre(wre),           // input wre
        .ad(ad),             // input [12:0] ad
        .din(data_bus)       // input [7:0] din
    );

    // Drie-staat verbinding
    assign data_bus = (ce && oce && !wre) ? ram_dout : 8'bz;

endmodule