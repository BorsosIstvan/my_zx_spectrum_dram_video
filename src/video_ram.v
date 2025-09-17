module video_ram_datapijp (
    input clk,
    input resetn,
    input de,               // flow control
    output reg [23:0] rgb,      // 24-bit RGB

    input [7:0] dout_video,
    output reg [12:0] ad_video
);

    localparam HOR_PIXELS = 1024;
    localparam VER_PIXELS = 768;

    // Pixel counters
    reg [11:0] hcount = 0;
    reg [11:0] vcount = 0;

//------------------------------------------------//
    // Pixel & attribute berekeningen

    wire [7:0] h = hcount[9:2];
    wire [7:0] v = vcount[9:2];
    wire [13:0] pix_addr  = { v[7:6], v[2:0], v[5:3], h[7:3] };
    wire [13:0] attr_addr = 6144 + {v[7:3], h[7:3]};  
    wire [2:0] bitpos = 8 - h[2:0];



    // Pipelined registers
    reg [7:0] pixel_byte, pixel_byte_d;
    reg [7:0] attr_byte, attr_byte_d;
    reg [1:0] read_phase;

    always @(posedge clk) begin
        if (!resetn) begin
            hcount <= 0;
            vcount <= 0;
            ad_video <= 0;
        end else if (de) begin
            // Start-of-frame

            case (read_phase)
            0: begin
            // Leescyclus pixel & attribuut
            ad_video <= pix_addr;
            pixel_byte <= dout_video;
            read_phase <= 1;
            end
            1: begin
            ad_video <= attr_addr;
            attr_byte <= dout_video;
            read_phase <= 0;
            end
            endcase

            // Pipeline registers
            pixel_byte_d <= pixel_byte;
            attr_byte_d <= attr_byte;

            // RGB-output gebaseerd op pixel-bit en attribuut
            rgb <= pixel_byte_d[bitpos] ? {
                attr_byte[2] ? 8'hC0 : 8'h00, 
                attr_byte[1] ? 8'hC0 : 8'h00, 
                attr_byte[0] ? 8'hC0 : 8'h00} : {
                attr_byte[5] ? 8'hC0 : 8'h00, 
                attr_byte[4] ? 8'hC0 : 8'h00, 
                attr_byte[3] ? 8'hC0 : 8'h00} ;

            // Pixel counters
            if (hcount == HOR_PIXELS-1) begin
                hcount <= 0;
                vcount <= (vcount == VER_PIXELS-1) ? 0 : vcount + 1;
            end else begin
                hcount <= hcount + 1;
            end
        end
    end
endmodule