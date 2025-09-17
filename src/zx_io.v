
// Minimal ZX Spectrum IO module with ENTER key support
module zx_io_enter (
    input  wire clk,
    input  wire reset,
    input  wire ce,         // I/O chip select: when CPU does IN/OUT on port FE
    input  wire rd_n,       // CPU read
    input  wire wr_n,
    input  wire [15:0] ad, // full address bus
    inout  wire [7:0] data_bus,
    output wire int,

    input  wire btn_enter   // hardware button (active low: pressed=0)
);

    reg [7:0] dout;

    always @(*) begin
        dout = 8'hFF;  // default = no key
        if (!ce && !rd_n && (ad[7:0] == 8'hFE)) begin
            // Check row 6 (A13 == 0)
            if (ad[14] == 1'b0) begin
                // ENTER is bit 0 van deze rij
                if (!btn_enter)  // knop actief laag
                    dout[0] = 1'b0;
            end
        end
    end

    // Tri-state output
    assign data_bus = (!ce && !rd_n && (ad[7:0] == 8'hFE)) ? dout : 8'bz;

    // simple 50Hz int generator (example)
    reg [18:0] cnt = 0;
    always @(posedge clk) begin
        cnt <= cnt + 1;
    end
    assign int = !(cnt < 3);

endmodule