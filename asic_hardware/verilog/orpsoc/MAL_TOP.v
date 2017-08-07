
module MAL_TOP(
    dig_in0_clk,
    dig_in1_tms_pad_i, 
    dig_in2_tck_pad_i, 
    dig_in3_tdi_pad_i,
    dig_out0_tdo_pad_o,
    dig_out1_sr_out
);

// JTAG
output dig_out0_tdo_pad_o; 
input  dig_in1_tms_pad_i;
input  dig_in2_tck_pad_i; 
input  dig_in3_tdi_pad_i; 

// CLK Input
input  dig_in0_clk;

// Supervisor Mode Bit
output dig_out1_sr_out;

// Pad Connection Wires
wire TO_PAD_sr_out;
wire TO_PAD_sr_out_buffed;
wire TO_PAD_tdo_pad_o;
wire FROM_PAD_sys_clk_in_p;
wire FROM_PAD_tms_pad_i;
wire FROM_PAD_tck_pad_i;
wire FROM_PAD_tdi_pad_i;

// ORPSOC Instantiation
orpsoc_top orpsoc(
    .tdo_pad_o(TO_PAD_tdo_pad_o), 
    .tms_pad_i(FROM_PAD_tms_pad_i), 
    .tck_pad_i(FROM_PAD_tck_pad_i), 
    .tdi_pad_i(FROM_PAD_tdi_pad_i), 
    .jtag_gnd(TO_PAD_jtag_gnd), 
    .jtag_vdd(TO_PAD_jtag_vdd),
    .sys_clk_in_p(FROM_PAD_sys_clk_in_p),
    .sr_out(TO_PAD_sr_out),
    .rst_n_pad_i(),
    .sr(),
    .ex_insn(),
    .ex_pc()
);

OUTPUT_BUFFER outbuffer1 (.I(TO_PAD_sr_out), .Z(TO_PAD_sr_out_buffed));

// INPUT Pads
PBIDIR_18_PL_H PAD_u0_digin (.Y(FROM_PAD_sys_clk_in_p), .PAD(dig_in0_clk),       .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVDD(), .DVSS());
PBIDIR_18_PL_H PAD_u1_digin (.Y(FROM_PAD_tms_pad_i),    .PAD(dig_in1_tms_pad_i), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVDD(), .DVSS());
PBIDIR_18_PL_H PAD_u2_digin (.Y(FROM_PAD_tck_pad_i),    .PAD(dig_in2_tck_pad_i), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVDD(), .DVSS());
PBIDIR_18_PL_H PAD_u3_digin (.Y(FROM_PAD_tdi_pad_i),    .PAD(dig_in3_tdi_pad_i), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVDD(), .DVSS());

// OUTPUT Pads
PBIDIR_18_PL_H PAD_u0_digout (.A(TO_PAD_tdo_pad_o),     .PAD(dig_out0_tdo_pad_o), .RTO(1'b1), .SNS(1'b1), .OE(1'b1), .DS0(1'b1), .DS1(1'b1), .SR(1'b0), .PE(1'b1), .PS(1'b0), .IE(), .IS(), .POE(), .PO(), .TRIGGER(), .Y(), .VDD(), .VSS(), .DVDD(), .DVSS());
PBIDIR_18_PL_H PAD_u1_digout (.A(TO_PAD_sr_out_buffed), .PAD(dig_out1_sr_out),    .RTO(1'b1), .SNS(1'b1), .OE(1'b1), .DS0(1'b1), .DS1(1'b1), .SR(1'b0), .PE(1'b1), .PS(1'b0), .IE(), .IS(), .POE(), .PO(), .TRIGGER(), .Y(), .VDD(), .VSS(), .DVDD(), .DVSS());

// Power/Ground Pads
PVDD_18_PL_H  PAD_POWER_VDD1  ();
PVSS_18_PL_H  PAD_POWER_VSS1  ();
PDVDD_18_PL_H PAD_POWER_DVDD1 ();
PDVSS_18_PL_H PAD_POWER_DVSS1 ();

endmodule


module OUTPUT_BUFFER (I, Z);
    input  I;
    output Z;

    wire   out_buf_1;

    INV_X4B_A12TR   XOBSB1 (.A(I), .Y(out_buf_1) );
    INV_X9B_A12TR   XOBSB4 (.A(out_buf_1), .Y(Z) );
endmodule



