// Virtual sequence
class AXI4_concurrent_seq extends virtual_seq;
  `uvm_object_utils(AXI4_concurrent_seq)

  function new (string name = "AXI4_concurrent_seq");
    super.new(name);
  endfunction
  
  task body();
   super.body();
   fork
    write_seq.start(p_sequencer.write_seqr);
    read_seq.start(p_sequencer.read_seqr);
   join 
  endtask
endclass

