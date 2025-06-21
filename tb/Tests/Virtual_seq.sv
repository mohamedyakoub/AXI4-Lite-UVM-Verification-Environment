// Virtual sequence
class virtual_seq extends uvm_sequence #(AXI4_seq_item);
  AXI4_seq read_seq,
          write_seq;
  AXI4_sequencer write_seqr,
                  read_seqr;
  `uvm_object_utils(virtual_seq)
  `uvm_declare_p_sequencer(AXI4_virtual_sequencer)
  
  function new (string name = "virtual_seq");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(get_type_name(), "virtual_seq: Inside Body", UVM_LOW);
    write_seq = AXI4_seq::type_id::create("write_seq");
    read_seq = AXI4_seq::type_id::create("read_seq");
    //write_read_seq = AXI4_write_read_seq::type_id::create("write_read_seq");
    // fork  
    // write_seq.start(p_sequencer.write_seqr);
    // read_seq.start(p_sequencer.read_seqr);
    // join


  endtask
endclass

