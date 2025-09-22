
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

    always @(posedge clk) begin
        dout = 8'hFF;  // default = no key
        if (!ce && !rd_n && wr_n) begin
    case(ad)
        16'h7FFE: dout <= (!btn_enter)? 8'b11100000 : 8'b11111111;  // ad 15     B, N, M, SS, SP
        16'hBFFE: dout <= (!btn_enter)? 8'b11100000 : 8'b11111111;  // ad 14     H, J, K, L, ENTR
        16'hDFFE: dout <= (!btn_enter)? 8'b11100000 : 8'b11111111;  // ad 13     Y, U, I, O, P
        16'hEFFE: dout <= (!btn_enter)? 8'b11111111 : 8'b11111111;  // ad 12     6, 7, 8, 9, 0
        16'hF7FE: dout <= (!btn_enter)? 8'b11111111 : 8'b11111111;  // ad 11     5, 4, 3, 2, 1
        16'hFBFE: dout <= (!btn_enter)? 8'b11100000 : 8'b11111111;  // ad 10     T, R, E, W, Q
        16'hFDFE: dout <= (!btn_enter)? 8'b11111111 : 8'b11111111;  // ad 9      G, F, D, S, A
        16'hFEFE: dout <= (!btn_enter)? 8'b11111111 : 8'b11111111;  // ad 8      V, C, X, Z, CS
        default:  dout <= 8'hFF;
    endcase
end
    end

/*
    always @(*) begin
        dout = 8'hFF;
        if (ad == 16'hFDFE) begin
            if (!btn_enter) dout <= 8'hF0; 
        end
    end

/*
always @(*) begin
    dout = 8'hFF; // default geen toets
    if (!ce && !rd_n && wr_n && (ad[7:0] == 8'hFE)) begin
        // bovenste bits altijd hoog
        dout[7:5] = 3'b111;

        // standaard geen toets
        dout[4:0] = 5'b11111;

        // test: alleen rij met "1-2-3-4-5" actief
        if (~ad[12]) begin
            // hier kiezen we toets "3" → dat is D2 = 0
            if (!btn_enter) dout[7:0] = 8'b00000000;
        end
    end
end
*/

    // Tri-state output
    assign data_bus = (!ce && !rd_n && wr_n && (ad[7:0] == 8'hFE)) ? dout : 8'bz;

    // simple 50Hz int generator (example)
    reg [15:0] cnt = 0;
    always @(posedge clk) begin
        cnt <= cnt + 1;
    end
    assign int = !(cnt < 5);

endmodule