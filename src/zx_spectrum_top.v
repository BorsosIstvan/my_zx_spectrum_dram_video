module top (
    input resetn,
    input clk,
    input knop,
    output wire [5:0] led,

    output wire tmds_clk_p,
    output wire tmds_clk_n,
    output wire [2:0] tmds_d_p,
    output wire [2:0] tmds_d_n
);

// HDMI VIDEO
hdmi_tmds_top hdmi (
    .clk(clk),
    .resetn(resetn),

    .clk_pixel(clk_pixel),
    .ad_video(ad_video),
    .dout_video(dout_video),

    .tmds_clk_p(tmds_clk_p),
    .tmds_clk_n(tmds_clk_n),
    .tmds_d_p(tmds_d_p),
    .tmds_d_n(tmds_d_n)
);
// CLK SPECTRUM : CPU RAM ROM
wire clk_spectrum;
Gowin_OSC osc(
    .oscout(clk_spectrum)   // ~7 MHz
);

// ================= CPU bus =================
wire [15:0] address_bus;
wire [7:0]  data_bus;

wire cpu_halt_n, cpu_mreq_n, cpu_iorq_n, cpu_rd_n, cpu_wr_n, cpu_int_n;

// ================= Z80 =================
cpu_z80 Z80 (
    .clk(~clk),
    .reset_n(resetn),
    .address_bus(address_bus),
    .data_bus(data_bus),
    .halt_n(cpu_halt_n),
    .mreq_n(cpu_mreq_n),
    .iorq_n(cpu_iorq_n),
    .int_n(cpu_int_n),
    .rd_n(cpu_rd_n),
    .wr_n(cpu_wr_n)
);

// DECODER input: address_bus[15:13], mreq_n, output: cs[7:0]
wire [7:0] cs;
decoder decoder (
    .addr(address_bus[15:13]),
    .mreq_n(~cpu_mreq_n),
    .cs(cs)
);

// ================= ROM =================
// 0x0000 - 0x1FFF  (8 KB)
rom8k_0 rom0 (
    .clk(clk),
    .reset(~resetn),
    .oce(~cpu_rd_n),          // active bij read
    .ce(cs[0]),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)           // tri-state in wrapper
);

rom8k_1 rom1 (
    .clk(clk),
    .reset(~resetn),
    .oce(~cpu_rd_n),          // active bij read
    .ce(cs[1]),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)           // tri-state in wrapper
);

// ================= Video RAM ============
// 0x4000 - 0x5FFF
wire [7:0] dout_video;
wire [12:0] ad_video;
//wire v_ce;

vram8k vram (
    .clk(clk),
    .oce(~cpu_rd_n),
    .wre(~cpu_wr_n),
    .ce(cs[2]),
    .reset(~resetn),
    .ad(address_bus[12:0]),
    .data_bus(data_bus),

    .vclk(clk_pixel),
    .vce(1'b1),
    .vdata(dout_video),
    .vad(ad_video)
);

// ================= RAM ================
// 0x6000 - 0x7FFF
ram8k ram1 (
    .clk(clk),
    .oce(~cpu_rd_n),
    .wre(~cpu_wr_n),
    .ce(cs[3]),
    .reset(~resetn),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)       // tri-state
);
// 0x8000 - 0x9FFF
ram8k ram2 (
    .clk(clk),
    .oce(~cpu_rd_n),
    .wre(~cpu_wr_n),
    .ce(cs[4]),
    .reset(~resetn),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)       // tri-state
);
// 0xA000 - 0xBFFF
ram8k ram3 (
    .clk(clk),
    .oce(~cpu_rd_n),
    .wre(~cpu_wr_n),
    .ce(cs[5]),
    .reset(~resetn),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)       // tri-state
);


// KEYBOARD

zx_io_enter io (
    .clk(clk),
    .reset(~resetn),
    .btn_enter(knop),
    .ad(address_bus),
    .ce(cpu_iorq_n),
    .rd_n(cpu_rd_n),
    .wr_n(cpu_wr_n),
    .data_bus(data_bus),
    .int(cpu_int_n)
);

assign led[0] = cpu_int_n;
assign led[5] = 0;

endmodule