// Virtual p_sequencer
class AXI4_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(AXI4_virtual_sequencer)
  AXI4_sequencer write_seqr,
              read_seqr;

  function new(string name = "AXI4_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass 
