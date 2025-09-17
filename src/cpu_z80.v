module cpu_z80 (
    input wire clk,
    input wire reset_n,
    output wire [15:0] address_bus, // 16-bit adresbus
    inout wire [7:0] data_bus,      // 8-bit tri-state databus
    input wire halt_n,
    input wire int_n,
    output wire iorq_n,
    output wire mreq_n,
    output wire rd_n,
    output wire wr_n
);

    wire [7:0] cpu_dout;  // data van CPU naar bus
    wire [7:0] cpu_din;   // data van bus naar CPU

    // --- Instantie van TV80 / T80 core ---
    tv80s cpu (
        .clk(clk),
        .reset_n(reset_n),
        .A(address_bus),
        .di(cpu_din),
        .dout(cpu_dout),
        .mreq_n(mreq_n),
        .rd_n(rd_n),
        .wr_n(wr_n),
        .iorq_n(iorq_n),  // voorlopig niet gebruikt
        .rfsh_n(),  // voorlopig niet gebruikt
        .m1_n(),    // voorlopig niet gebruikt
        .halt_n(halt_n),  // voorlopig niet gebruikt
        .busak_n(), // voorlopig niet gebruikt
        .int_n(int_n),
        .nmi_n(1'b1),
        .wait_n(1'b1),
        .cen(1'b1),
        .busrq_n(1'b1)
    );

    // --- Tri-state bus ---
    assign data_bus = (!rd_n && !mreq_n) ? 8'bz : cpu_dout; // bij lezen: high-Z
    assign cpu_din  = data_bus;
endmodule