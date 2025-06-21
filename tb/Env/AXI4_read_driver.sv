class AXI4_read_driver extends uvm_driver#(AXI4_seq_item);
    `uvm_component_utils(AXI4_read_driver)
    virtual AXI4_if vif;
    AXI4_seq_item read_item;
    semaphore read_sem,read_address_sem, read_data_sem,resp_sem;
    bit  read_address_done;
    function new(string name="AXI4_read_driver", uvm_component parent=null);
        super.new(name, parent);
        read_sem = new(1); // Semaphore for read operation
        read_address_sem = new(1); // Semaphore for read address operation
        read_data_sem = new(1); // Semaphore for read data operation
        resp_sem = new(1); // Semaphore for read response operation
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AXI4 Read Driver", "Building driver", UVM_MEDIUM)
        if(!(uvm_config_db#(virtual AXI4_if)::get(null, "", "vif", vif)))
            `uvm_fatal("NOVIF", "No virtual interface found");
        `uvm_info("AXI4 Read Driver", "Finished building driver", UVM_MEDIUM)
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("AXI4 Read Driver", "Running driver", UVM_MEDIUM)
        reset();
        forever begin
            // Read operation
            fork
                read_operation();
                begin
                    resp_sem.get(); // Acquire semaphore for read response operation
                    @(posedge vif.clk); // Wait for clock edge
                    vif.s_axil_rready <= $urandom_range(0, 1); // Set ready for read response
                    if(vif.s_axil_rvalid ) begin
                        if(vif.s_axil_rready) begin
                            read_address_done = 0; // Reset read address done flag
                        end
                    end
                    resp_sem.put(); // Release semaphore for read response operation
                end
            join_any
            
        end
    endtask

    task reset();
        `uvm_info("AXI4 Read Driver", "Resetting driver", UVM_MEDIUM)
        vif.s_axil_arvalid <= 1'b0; 
        vif.s_axil_rready <= 1'b0;
        vif.rst <= 1'b1; // Assert reset
        @(posedge vif.clk);
        vif.rst <= 1'b0; // Deassert reset
        @(posedge vif.clk);

        `uvm_info("AXI4 Read Driver", "Finished resetting driver", UVM_MEDIUM)
    endtask

   

//////////////////// Read Operation //////////////////////
task read_operation();
    @(posedge vif.clk);
    read_sem.get(); // Acquire semaphore for read operation
        if(!read_address_done) begin
            read_item = AXI4_seq_item::type_id::create("read_item", this);
            seq_item_port.get_next_item(read_item); // Get the next item from the sequencer
            seq_item_port.item_done(); // Indicate that the item is done
            `uvm_info("AXI4 Read Driver", $sformatf("Read item: %s", read_item.convert2string()), UVM_MEDIUM)
            read_address(read_item); // Read address
        end
    
        // begin
        //     vif.s_axil_rready <= read_item.s_axil_rready; // Set ready for read response
        //     if(vif.s_axil_rvalid & read_item.s_axil_rready) begin 
        //         read_address_done = 0; // Reset read address done flag
        //     end
        // end
        
    
    read_sem.put(); // Release semaphore for read operation
endtask : read_operation

task read_address(AXI4_seq_item read_item);
    read_address_sem.get(); // Acquire semaphore for read address operation
    repeat(read_item.r_addr_delay) @(posedge vif.clk); // Random delay for address read
    `uvm_info("AXI4 Read Driver", "Reading address", UVM_MEDIUM)
    vif.s_axil_araddr <= read_item.s_axil_araddr;
    vif.s_axil_arprot <= read_item.s_axil_arprot;
    if(read_item.valid_read_address) begin
        read_address_done = 1; // Indicate that read address is done
        vif.s_axil_arvalid <= 1'b1;
        @(posedge vif.clk);
        while(!vif.s_axil_arready) 
            @(posedge vif.clk);
        vif.s_axil_arvalid <= 1'b0;
        `uvm_info("AXI4 Read Driver", "Finished reading address", UVM_MEDIUM)
    end
    @(posedge vif.clk);
    read_address_sem.put(); // Release semaphore for read address operation
endtask : read_address



endclass : AXI4_read_driver

