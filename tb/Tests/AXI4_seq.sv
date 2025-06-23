class AXI4_seq extends uvm_sequence #(AXI4_seq_item);
    `uvm_object_utils(AXI4_seq)    
    AXI4_seq_item item;
   
   
    int i,trans_num;
    AXI4_cfg cfg;

    function new(string name="AXI4_seq");
        super.new(name);
    endfunction

    virtual task pre_body();
        `uvm_info("Seq", "Starting pre body ", UVM_MEDIUM)
        cfg=AXI4_cfg::type_id::create("cfg");

        if(!uvm_config_db#(AXI4_cfg)::get(m_sequencer, "", "AXI4_cfg", cfg))
            `uvm_fatal("NOCFG", "No configuration object found");
        
        trans_num = cfg.trans_num;
        `uvm_info("Seq", "Finished pre body ", UVM_MEDIUM)

    endtask

    virtual task body();
        `uvm_info("Seq", "Starting sequence", UVM_MEDIUM)
        item = AXI4_seq_item::type_id::create("item");

        repeat(trans_num)begin
            start_item(item);
            assert(item.randomize with {
  

            }); 
            finish_item(item);
        end
        `uvm_info("Seq", "Finishing sequence", UVM_MEDIUM)

    endtask
endclass


