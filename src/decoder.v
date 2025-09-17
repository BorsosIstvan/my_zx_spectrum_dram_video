module decoder(
    input  wire       mreq_n,     // actief laag
    input  wire [2:0] addr,  // address_bus[15:13]
    output wire [7:0] cs          // chip select outputs
);

    assign cs[0] = (addr == 3'b000)&mreq_n;
    assign cs[1] = (addr == 3'b001)&mreq_n;
    assign cs[2] = (addr == 3'b010)&mreq_n;
    assign cs[3] = (addr == 3'b011)&mreq_n;
    assign cs[4] = (addr == 3'b100)&mreq_n;
    assign cs[5] = (addr == 3'b101)&mreq_n;
    assign cs[6] = (addr == 3'b110)&mreq_n;
    assign cs[7] = (addr == 3'b111)&mreq_n;

endmodule