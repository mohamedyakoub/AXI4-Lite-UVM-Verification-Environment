// Virtual sequence
class AXI4_write_read_seq extends virtual_seq;
  `uvm_object_utils(AXI4_write_read_seq)
  
  function new (string name = "AXI4_write_read_seq");
    super.new(name);
  endfunction
  
  task body();
   super.body();
    write_seq.start(p_sequencer.write_seqr);
    read_seq.start(p_sequencer.read_seqr);

  endtask
endclass

