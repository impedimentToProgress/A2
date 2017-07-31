
module MAL_TOP(
    dig_out0_tdo_pad_o, 
    dig_in0_tms_pad_i, 
    dig_in1_tck_pad_i, 
    dig_in2_tdi_pad_i, 
    // dig_in3_scan_phi,
    // dig_in4_scan_phi_bar,
    // dig_in5_scan_data_in,
    // dig_out1_scan_data_out,
    // dig_in6_scan_load_chip,
    // dig_in7_scan_load_chain,
    dig_out3_div_clk,
    dig_out4_sr_out
);

// JTAG
output  dig_out0_tdo_pad_o; 

input   dig_in0_tms_pad_i;
input   dig_in1_tck_pad_i; 
input   dig_in2_tdi_pad_i; 

// Scan Chain
// output   dig_out1_scan_data_out;

// input    dig_in3_scan_phi;
// input    dig_in4_scan_phi_bar;
// input    dig_in5_scan_data_in;
// input    dig_in6_scan_load_chip;
// input    dig_in7_scan_load_chain;

// CLK_DIVIDER
output    dig_out3_div_clk;

// Supervisor Mode Bit
output    dig_out4_sr_out;

// Custom Scan Chain IP Block
// wire  [1-1:0]  from_scan_RO_EN;
// wire  [1-1:0]  from_scan_RO_CG_EN;
// wire  [5-1:0]  from_scan_RO_SEL;
// wire  [1-1:0]  scan_mem_sel;
// wire  [1-1:0]  mem_use_scan;
// wire  [1-1:0]  mem_trigger;
// wire  [1-1:0]  mem_scan_reset_n;
// wire  [15-1:0]  scan_addr;
// wire  [32-1:0]  scan_d;
// wire  [32-1:0]  scan_q;
// wire  [1-1:0]  scan_wen_n;
// wire  [1-1:0]  scan_cen_n;
// wire  [3-1:0]  scan_EMA;
wire  [16:0]  sr;
wire  [31:0]  ex_insn;
wire  [31:0]  ex_pc;
// wire  [1-1:0]  scan_reset;
// wire        from_scan_chip_rst_n;
wire TO_PAD_sr_out;
wire TO_PAD_sr_out1;
// reg TO_PAD_test_delay;

// Custom Testing IP Block 1
// wire    test_out0;
// wire    test_out1; 
// wire    test_out2; 
// wire[2:0] from_scan_test_en;
// wire[1:0] from_scan_test_s0;
// wire[1:0] from_scan_test_s1; 
// wire[1:0] from_scan_test_s2; 
// wire    ana_test_bias;
// wire[1:0] from_scan_test_en0;
// wire[1:0] from_scan_test_en1; 
// wire[1:0] from_scan_test_en2; 
// wire      from_scan_test_in0; 
// wire      from_scan_test_in0_metal; 
// wire[1:0] from_scan_test_in1;
// wire[1:0] from_scan_test_in2;

// Custom Testing IP Block 2
// wire[6:0] from_scan_test1_duty;
// wire[6:0] from_scan_test1_total;
// wire[6:0] to_scan_test1_count;
// wire      from_scan_test1_rst_n;
// wire      from_scan_test1_sel;

orpsoc_top orpsoc( 
    TO_PAD_tdo_pad_o, FROM_PAD_tms_pad_i, FROM_PAD_tck_pad_i, FROM_PAD_tdi_pad_i, TO_PAD_jtag_gnd, TO_PAD_jtag_vdd,
  
    sys_clk_in_p, //sys_clk_in_n,

    from_scan_chip_rst_n,

    // scan_mem_sel, mem_use_scan, mem_trigger, mem_scan_reset_n,
    // scan_addr, scan_d, scan_wen_n, scan_cen_n,scan_q, scan_EMA, clk_scan,
    TO_PAD_sr_out, sr, ex_insn, ex_pc);


// scan scan0 (
//     // Inputs & outputs to the testing IP block
//     .from_scan_test_en(from_scan_test_en),
//     .from_scan_test_s0(from_scan_test_s0),
//     .from_scan_test_s1(from_scan_test_s1),
//     .from_scan_test_s2(from_scan_test_s2),

//     .from_scan_test_en0(from_scan_test_en0),
//     .from_scan_test_en1(from_scan_test_en1),
//     .from_scan_test_en2(from_scan_test_en2),

//     .from_scan_test_in0(from_scan_test_in0),
//     .from_scan_test_in1(from_scan_test_in1),
//     .from_scan_test_in2(from_scan_test_in2),

//     .from_scan_test1_duty(from_scan_test1_duty),
//     .from_scan_test1_total(from_scan_test1_total),
//     .from_scan_test1_rst_n(from_scan_test1_rst_n),
//     .from_scan_test1_sel(from_scan_test1_sel),
//     .to_scan_test1_count(to_scan_test1_count),

//     .from_scan_div_sel(from_scan_div_sel),

//     .from_scan_RO_EN(from_scan_RO_EN),
//     .from_scan_RO_CG_EN(from_scan_RO_CG_EN),
//     .from_scan_RO_SEL(from_scan_RO_SEL),
    
//     .from_scan_chip_rst_n(from_scan_chip_rst_n),
    
//     .scan_mem_sel(scan_mem_sel),
//     .mem_use_scan(mem_use_scan),
//     .mem_trigger(mem_trigger),
//     .mem_scan_reset_n(mem_scan_reset_n),
//     .scan_addr(scan_addr),
//     .scan_d(scan_d),
//     .scan_q(scan_q),
//     .scan_wen_n(scan_wen_n),
//     .scan_cen_n(scan_cen_n),
//     .scan_EMA(scan_EMA),
//     .sr(sr),
//     .ex_insn(ex_insn),
//     .ex_pc(ex_pc),
//     .scan_reset(scan_reset),
                    
//     // To the pads
//     .scan_phi(FROM_PAD_scan_phi),
//     .scan_phi_bar(FROM_PAD_scan_phi_bar),
//     .scan_data_in(FROM_PAD_scan_data_in),
//     .scan_data_out(TO_PAD_scan_data_out),
//     .scan_load_chip(FROM_PAD_scan_load_chip),
//     .scan_load_chain(FROM_PAD_scan_load_chain) 
// );


// RO_Whole clk_gen0 (
//     .OUT(clk_scan), 
//     .OUT_CG(sys_clk_in_p),
//     .OUT_DIV(TO_PAD_RO), 
//     .EN(from_scan_RO_EN), 
//     .CGEN(from_scan_RO_CG_EN), 
//     .S(from_scan_RO_SEL));


//Testing_structure test0 ();
// Delay_Meas_ALL test_structure(
// .OUT0(test_out0),
// .OUT1(test_out1), 
// .OUT2(test_out2), 
// .EN(from_scan_test_en),
// .S0(from_scan_test_s0),
// .S1(from_scan_test_s1), 
// .S2(from_scan_test_s2), 
// .Stress_Bias(ana_test_bias), 
// .Stress_EN0(from_scan_test_en0),
// .Stress_EN1(from_scan_test_en1), 
// .Stress_EN2(from_scan_test_en2), 
// .Stress_IN0(from_scan_test_in0), 
// .Stress_IN0_metal(clk_scan), 
// .Stress_IN1(from_scan_test_in1), 
// .Stress_IN2(from_scan_test_in2)
// );


// PG test1( 
// .clk(clk_scan), 
// .rst_n(from_scan_test1_rst_n), 
// .duty(from_scan_test1_duty), 
// .total(from_scan_test1_total), 
// .sel(from_scan_test1_sel), 
// .count_pattern(to_scan_test1_count)
// );


// OUTPUT_BUFFER outbuffer1 (.I(TO_PAD_scan_data_out), .Z(TO_PAD_scan_data_out1));
OUTPUT_BUFFER outbuffer2 (.I(TO_PAD_sr_out), .Z(TO_PAD_sr_out1));
OUTPUT_BUFFER outbuffer3 (.I(TO_PAD_div_clk), .Z(TO_PAD_div_clk1));


// assign TO_PAD_div_clk = from_scan_div_sel ? TO_PAD_test_delay : TO_PAD_RO;
assign TO_PAD_div_clk = 1'b1;

// INPUT Pads
PBIDIR_18_PL_H PAD_u0_digin (.Y(FROM_PAD_tms_pad_i), .PAD(dig_in0_tms_pad_i), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());
PBIDIR_18_PL_H PAD_u1_digin (.Y(FROM_PAD_tck_pad_i), .PAD(dig_in1_tck_pad_i), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());
PBIDIR_18_PL_H PAD_u2_digin (.Y(FROM_PAD_tdi_pad_i), .PAD(dig_in2_tdi_pad_i), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());
// PBIDIR_18_PL_H PAD_u3_digin (.Y(),                   .PAD(dig_in3_scan_phi), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());
// PBIDIR_18_PL_H PAD_u4_digin (.Y(),                   .PAD(dig_in4_scan_phi_bar), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());
// PBIDIR_18_PL_H PAD_u5_digin (.Y(),                   .PAD(dig_in5_scan_data_in), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());
// PBIDIR_18_PL_H PAD_u6_digin (.Y(),                   .PAD(dig_in6_scan_load_chip), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());
// PBIDIR_18_PL_H PAD_u7_digin (.Y(),                   .PAD(dig_in7_scan_load_chain), .DVDD(1'b1), .RTO(1'b1), .SNS(1'b1), .IE(1'b1), .IS(1'b0), .PE(1'b0), .PS(1'b0), .POE(1'b0), .SR(), .DS0(), .DS1(), .OE(), .PO(), .TRIGGER(), .A(), .VDD(), .VSS(), .DVSS());

// OUTPUT Pads
PBIDIR_18_PL_H PAD_u0_digout (.A(TO_PAD_tdo_pad_o),      .PAD(dig_out0_tdo_pad_o), .RTO(1'b1), .SNS(1'b1), .OE(1'b1), .DS0(1'b1), .DS1(1'b1), .SR(1'b0), .PE(1'b1), .PS(1'b0), .IE(), .IS(), .POE(), .PO(), .TRIGGER(), .Y(), .VDD(), .VSS(), .DVDD(), .DVSS());
// PBIDIR_18_PL_H PAD_u1_digout (.A(TO_PAD_scan_data_out1), .PAD(dig_out1_scan_data_out), .RTO(1'b1), .SNS(1'b1), .OE(1'b1), .DS0(1'b1), .DS1(1'b1), .SR(1'b0), .PE(1'b1), .PS(1'b0), .IE(), .IS(), .POE(), .PO(), .TRIGGER(), .Y(), .VDD(), .VSS(), .DVDD(), .DVSS());
PBIDIR_18_PL_H PAD_u3_digout (.A(TO_PAD_div_clk1),       .PAD(dig_out3_div_clk), .RTO(1'b1), .SNS(1'b1), .OE(1'b1), .DS0(1'b1), .DS1(1'b1), .SR(1'b0), .PE(1'b1), .PS(1'b0), .IE(), .IS(), .POE(), .PO(), .TRIGGER(), .Y(), .VDD(), .VSS(), .DVDD(), .DVSS());
PBIDIR_18_PL_H PAD_u4_digout (.A(TO_PAD_sr_out1),        .PAD(dig_out4_sr_out), .RTO(1'b1), .SNS(1'b1), .OE(1'b1), .DS0(1'b1), .DS1(1'b1), .SR(1'b0), .PE(1'b1), .PS(1'b0), .IE(), .IS(), .POE(), .PO(), .TRIGGER(), .Y(), .VDD(), .VSS(), .DVDD(), .DVSS());

// Power/Ground Pads
PVDD_18_PL_H  PAD_POWER_VDD1  ();
PVSS_18_PL_H  PAD_POWER_VSS1  ();
// PAVDD_18_PL_H PAD_POWER_VDD2  ();
// PAVSS_18_PL_H PAD_POWER_AVSS  ();
// PAVDD_18_PL_H PAD_POWER_AVDD  ();
// PAVDD_18_PL_H PAD_ANA1        ();
PDVDD_18_PL_H PAD_POWER_DVDD1 ();
PDVSS_18_PL_H PAD_POWER_DVSS1 ();

endmodule


module OUTPUT_BUFFER (I, Z);
    input I;
    output Z;

    INV_X4B_A12TR   XOBSB1 (.A(I), .Y(out_buf_1) );
    INV_X9B_A12TR   XOBSB4 (.A(out_buf_1), .Y(Z) );
endmodule



