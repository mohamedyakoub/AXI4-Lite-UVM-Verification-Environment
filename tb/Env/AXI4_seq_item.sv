class AXI4_seq_item extends uvm_sequence_item;
 
 //---------------------------------------
 //data and control fields
 //---------------------------------------
    // Width of data bus in bits
    parameter DATA_WIDTH = 32;
    // Width of address bus in bits
    parameter ADDR_WIDTH = 16;
    // Width of strb bus in bits
    parameter STRB_WIDTH = (DATA_WIDTH/8);

    rand logic                   rst;
    rand bit                     valid_write_address; // Indicates if the address is valid
    rand logic [ADDR_WIDTH-1:0]  s_axil_awaddr;
    rand logic [2:0]             s_axil_awprot;

    rand bit                     valid_write_data; // Indicates if the data is valid
    rand logic [DATA_WIDTH-1:0]  s_axil_wdata;
    rand logic [STRB_WIDTH-1:0]  s_axil_wstrb;

    logic [1:0]             s_axil_bresp;
    rand logic                   s_axil_bready;

    rand bit                     valid_read_address; // Indicates if the address is valid
    rand logic [ADDR_WIDTH-1:0]  s_axil_araddr;
    rand logic [2:0]             s_axil_arprot;
   
    rand bit                     s_axil_rready; // Indicates if the read response is ready
    logic [DATA_WIDTH-1:0]  s_axil_rdata;
    logic [1:0]             s_axil_rresp;

    rand int r_addr_delay,
              r_data_delay,
              r_resp_delay; // Random delays for address, data, and response
    rand int w_addr_delay,
              w_data_delay,
              w_resp_delay; // Random delays for address, data, and response

//---------------------------------------
  //Constructor
//---------------------------------------
  function new(string name = "AXI4_seq_item");
    super.new(name);
  endfunction
  
//---------------------------------------
  //Utility and Field macros
//---------------------------------------
  `uvm_object_utils_begin(AXI4_seq_item)

  `uvm_field_int(rst, UVM_DEFAULT)

  `uvm_field_int(valid_write_address, UVM_DEFAULT)
  `uvm_field_int(s_axil_awaddr, UVM_DEFAULT)  
  `uvm_field_int(s_axil_awprot, UVM_DEFAULT)

  `uvm_field_int(valid_write_data, UVM_DEFAULT)
  `uvm_field_int(s_axil_wdata, UVM_DEFAULT)
  `uvm_field_int(s_axil_wstrb, UVM_DEFAULT)

  `uvm_field_int(s_axil_bresp, UVM_DEFAULT)
  `uvm_field_int(s_axil_bready, UVM_DEFAULT)

  `uvm_field_int(valid_read_address, UVM_DEFAULT)
  `uvm_field_int(s_axil_araddr, UVM_DEFAULT)
  `uvm_field_int(s_axil_arprot, UVM_DEFAULT)

  `uvm_field_int(s_axil_rready, UVM_DEFAULT)
  `uvm_field_int(s_axil_rdata, UVM_DEFAULT)
  `uvm_field_int(s_axil_rresp, UVM_DEFAULT)

  `uvm_object_utils_end

      
//---------------------------------------
//Constraints
//---------------------------------------
parameter ones={DATA_WIDTH{1'b1}}, zeros={DATA_WIDTH{1'b0}}, special1={DATA_WIDTH/2{{1'b0},{1'b1}}}, special2={DATA_WIDTH/2{{1'b1},{1'b0}}}; 


constraint addr_c {
    s_axil_awaddr dist { 16'b0 := 30, [16'h1:16'hFFFE] := 15, 16'hFFFF := 30 }; // Example distribution for address
    s_axil_araddr dist { 16'b0 := 30, [16'h1:16'hFFFE] := 15, 16'hFFFF := 30 }; // Example distribution for address
}
constraint data_c {
    s_axil_wdata dist { zeros := 20, [32'h1:special1-1] :/ 90, special1 := 20 , [special1+1:special2-1] :/ 90, special2 := 20 , [special2+1:ones-1] :/ 90, ones:=20 }; // Example distribution for data
}
constraint prot_c {
    s_axil_awprot dist { 3'b000 :/ 50, 3'b001 :/ 25, 3'b010 :/ 25 }; // Example distribution for protection
    s_axil_arprot dist { 3'b000 :/ 50, 3'b001 :/ 25, 3'b010 :/ 25 }; // Example distribution for protection
}
constraint wstrb_c {
    s_axil_wstrb dist { 4'b1111 :/ 50, [4'b0000:4'b1110] :/ 50 }; // Example distribution for write strobe
}
constraint valid_signals_c {
    valid_write_address dist { 0 :/ 10, 1 :/ 90 }; // 50% chance of valid address
    valid_write_data dist { 0 :/ 10, 1 :/ 90 }; // 50% chance of valid data
    valid_read_address dist { 0 :/ 10, 1 :/ 90 }; // 50% chance of valid read address
}
constraint ready_signals_c {
    s_axil_bready dist { 0 :/ 30, 1 :/ 50 }; // 50% chance of ready for write response
    s_axil_rready dist { 0 :/ 50, 1 :/ 50 }; // 50% chance of ready for read response
}

constraint delay_c {
    r_addr_delay dist { 0 :/ 10, [1:10] :/ 20 }; // Random delays for read address
    r_data_delay dist { 0 :/ 10, [1:10] :/ 20 }; // Random delays for read data
    w_addr_delay dist { 0 :/ 10, [1:10] :/ 20 }; // Random delays for write address
    w_data_delay dist { 0 :/ 10, [1:10] :/ 20 }; // Random delays for write data
    w_resp_delay dist { 0 :/ 10, [1:10] :/ 20 }; // Random delays for write response
}
//---------------------------------------

endclass :AXI4_seq_item




   


  



            





