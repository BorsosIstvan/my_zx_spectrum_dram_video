//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.03 Education
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9
//Device Version: C
//Created Time: Wed Sep 17 11:36:40 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_RAM16S your_instance_name(
        .dout(dout), //output [7:0] dout
        .wre(wre), //input wre
        .ad(ad), //input [10:0] ad
        .di(di), //input [7:0] di
        .clk(clk) //input clk
    );

//--------Copy end-------------------
