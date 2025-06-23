class AXI4_ideal_seq extends AXI4_seq;
    `uvm_object_utils(AXI4_ideal_seq)    
    
    function new(string name="AXI4_ideal_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("Seq", "Starting sequence", UVM_MEDIUM)
        item = AXI4_seq_item::type_id::create("item");

        repeat(trans_num)begin
            start_item(item);
            assert(item.randomize with {
                valid_read_address ==1;
                valid_write_address ==1;
                valid_write_data ==1;
                r_addr_delay==0;
                w_addr_delay==0;
                w_data_delay==0;
                s_axil_arprot == 3'b000; // Set default protection
                s_axil_awprot == 3'b000; // Set default protection
                s_axil_araddr[1:0] == 2'b00; // Set default address alignment
                s_axil_awaddr[1:0] == 2'b00; // Set default address alignment


            }); 
            finish_item(item);
        end
        `uvm_info("Seq", "Finishing sequence", UVM_MEDIUM)

    endtask
endclass


