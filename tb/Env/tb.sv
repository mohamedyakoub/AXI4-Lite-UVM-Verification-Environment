`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
import AXI4_pkg::*;

module tb;

  parameter CLK_PERIOD = 10ns;  
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 16;
  parameter STRB_WIDTH = (DATA_WIDTH/8);
  parameter PIPELINE_OUTPUT = 0;

  bit clk;

  // Clock generation
  always #(CLK_PERIOD/2) clk=~clk;

  AXI4_if#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT)
  ) AXI4_intf (clk);


  axil_ram#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT)
  ) DUT (
    .clk(clk),
    .rst(AXI4_intf.rst),
    .s_axil_awaddr(AXI4_intf.s_axil_awaddr),
    .s_axil_awprot(AXI4_intf.s_axil_awprot),
    .s_axil_awvalid(AXI4_intf.s_axil_awvalid),
    .s_axil_awready(AXI4_intf.s_axil_awready),
    .s_axil_wdata(AXI4_intf.s_axil_wdata),
    .s_axil_wstrb(AXI4_intf.s_axil_wstrb),
    .s_axil_wvalid(AXI4_intf.s_axil_wvalid),
    .s_axil_wready(AXI4_intf.s_axil_wready),
    .s_axil_bresp(AXI4_intf.s_axil_bresp),
    .s_axil_bvalid(AXI4_intf.s_axil_bvalid),
    .s_axil_bready(AXI4_intf.s_axil_bready),
    .s_axil_araddr(AXI4_intf.s_axil_araddr),
    .s_axil_arprot(AXI4_intf.s_axil_arprot),
    .s_axil_arvalid(AXI4_intf.s_axil_arvalid),
    .s_axil_arready(AXI4_intf.s_axil_arready),
    .s_axil_rdata(AXI4_intf.s_axil_rdata),
    .s_axil_rresp(AXI4_intf.s_axil_rresp),
    .s_axil_rvalid(AXI4_intf.s_axil_rvalid),
    .s_axil_rready(AXI4_intf.s_axil_rready)
    );

    bind axil_ram AXI4_Assertions assertions_inst(.clk(clk),
                                                  .rst(AXI4_intf.rst),
                                                  .s_axil_awaddr(AXI4_intf.s_axil_awaddr),
                                                  .s_axil_awprot(AXI4_intf.s_axil_awprot),
                                                  .s_axil_awvalid(AXI4_intf.s_axil_awvalid),
                                                  .s_axil_awready(AXI4_intf.s_axil_awready),
                                                  .s_axil_wdata(AXI4_intf.s_axil_wdata),
                                                  .s_axil_wstrb(AXI4_intf.s_axil_wstrb),
                                                  .s_axil_wvalid(AXI4_intf.s_axil_wvalid),
                                                  .s_axil_wready(AXI4_intf.s_axil_wready),
                                                  .s_axil_bresp(AXI4_intf.s_axil_bresp),
                                                  .s_axil_bvalid(AXI4_intf.s_axil_bvalid),
                                                  .s_axil_bready(AXI4_intf.s_axil_bready),
                                                  .s_axil_araddr(AXI4_intf.s_axil_araddr),
                                                  .s_axil_arprot(AXI4_intf.s_axil_arprot),
                                                  .s_axil_arvalid(AXI4_intf.s_axil_arvalid),
                                                  .s_axil_arready(AXI4_intf.s_axil_arready),
                                                  .s_axil_rdata(AXI4_intf.s_axil_rdata),
                                                  .s_axil_rresp(AXI4_intf.s_axil_rresp),
                                                  .s_axil_rvalid(AXI4_intf.s_axil_rvalid),
                                                  .s_axil_rready(AXI4_intf.s_axil_rready));

   initial begin
    uvm_config_db#(virtual AXI4_if)::set(null,"*","vif",AXI4_intf);
    run_test("");
  end

endmodule
