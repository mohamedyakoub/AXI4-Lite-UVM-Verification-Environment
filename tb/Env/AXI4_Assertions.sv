module AXI4_Assertions#(parameter ADDR_WIDTH = 32, parameter DATA_WIDTH = 32, parameter STRB_WIDTH = 4) (
    input bit clk,
    input logic                   rst,
    // Instruction interface signals
    input logic [ADDR_WIDTH-1:0]  s_axil_awaddr,
    input logic [2:0]             s_axil_awprot,
    input logic                   s_axil_awvalid,
    input logic                   s_axil_awready,
    input logic [DATA_WIDTH-1:0]  s_axil_wdata,
    input logic [STRB_WIDTH-1:0]  s_axil_wstrb,
    input logic                   s_axil_wvalid,
    input logic                   s_axil_wready,
    input logic [1:0]             s_axil_bresp,
    input logic                   s_axil_bvalid,
    input logic                   s_axil_bready,
    input logic [ADDR_WIDTH-1:0]  s_axil_araddr,
    input logic [2:0]             s_axil_arprot,
    input logic                   s_axil_arvalid,
    input logic                   s_axil_arready,
    input logic [DATA_WIDTH-1:0]  s_axil_rdata,
    input logic [1:0]             s_axil_rresp,
    input logic                   s_axil_rvalid,
    input logic                   s_axil_rready
  
);
    property stable_awaddr;
         @(posedge clk) disable iff (rst) $rose(s_axil_awvalid)  |=> $stable(s_axil_awaddr) throughout !s_axil_awvalid[->1]  ;
    endproperty
    
    stable_awaddr_assertion : assert property (stable_awaddr);
    stable_awaddr_cover : cover property (stable_awaddr);

    property axil_awvalid;
        @(posedge clk) disable iff (rst) $rose(s_axil_awvalid)  |-> (s_axil_awvalid throughout s_axil_awready[->1] ) |=> !s_axil_awvalid;
    endproperty

    awvalid_assertion : assert property (axil_awvalid);
    awvalid_cover : cover property (axil_awvalid);

    property stable_wdata;
         @(posedge clk) disable iff (rst) $rose(s_axil_wvalid)  |=> $stable(s_axil_wdata) throughout !s_axil_wvalid[->1] ;
    endproperty

    stable_wdata_assertion : assert property (stable_wdata);
    stable_wdata_cover : cover property (stable_wdata);

    property axil_wvalid;
        @(posedge clk) disable iff (rst) $rose(s_axil_wvalid)  |-> (s_axil_wvalid throughout s_axil_wready[->1] ) |=> !s_axil_wvalid;
    endproperty

    wvalid_assertion : assert property (axil_wvalid);
    wvalid_cover : cover property (axil_wvalid);

    property axil_bvalid;
        @(posedge clk) disable iff (rst) $rose(s_axil_bvalid)  |-> (s_axil_bvalid throughout s_axil_bready[->1] ) |=> !s_axil_bvalid;
    endproperty

    bvalid_assertion : assert property (axil_bvalid);
    bvalid_cover : cover property (axil_bvalid);

    property stable_araddr;
         @(posedge clk) disable iff (rst) $rose(s_axil_arvalid)  |=> $stable(s_axil_araddr) throughout !s_axil_arvalid[->1] ;
    endproperty

    stable_araddr_assertion : assert property (stable_araddr);
    stable_araddr_cover : cover property (stable_araddr);

    property axil_arvalid;
        @(posedge clk) disable iff (rst) $rose(s_axil_arvalid)  |-> (s_axil_arvalid throughout s_axil_arready[->1] ) |=> !s_axil_arvalid;
    endproperty

    arvalid_assertion : assert property (axil_arvalid);
    arvalid_cover : cover property (axil_arvalid);

    property stable_rdata;
         @(posedge clk) disable iff (rst) $rose(s_axil_rvalid)  |=> $stable(s_axil_rdata) throughout !s_axil_rvalid[->1] ;
    endproperty

    stable_rdata_assertion : assert property (stable_rdata);
    stable_rdata_cover : cover property (stable_rdata);

    property axil_rvalid;
        @(posedge clk) disable iff (rst) $rose(s_axil_rvalid)  |-> (s_axil_rvalid throughout s_axil_rready[->1] ) |=> !s_axil_rvalid;
    endproperty

    rvalid_assertion : assert property (axil_rvalid);
    rvalid_cover : cover property (axil_rvalid);


endmodule 