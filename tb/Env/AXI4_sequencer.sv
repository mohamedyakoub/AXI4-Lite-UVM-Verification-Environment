class AXI4_sequencer extends uvm_sequencer#(AXI4_seq_item);
  `uvm_component_utils(AXI4_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass


