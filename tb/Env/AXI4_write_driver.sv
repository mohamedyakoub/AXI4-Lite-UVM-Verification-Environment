class AXI4_write_driver extends uvm_driver#(AXI4_seq_item);
    `uvm_component_utils(AXI4_write_driver)
    virtual AXI4_if vif;
    AXI4_seq_item address_item,data_item; // Item to hold the sequence item
    semaphore  rw_sem; // Semaphores for write address and data operations
    // Flags to indicate if write address and data operations are done
    bit write_address_done, write_data_done;
    int address_written;
    function new(string name="AXI4_write_driver", uvm_component parent=null);
        super.new(name, parent);
        rw_sem = new(1); // Semaphore for read/write operation
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AXI4 Write Driver", "Building driver", UVM_MEDIUM)
        if(!(uvm_config_db#(virtual AXI4_if)::get(null, "", "vif", vif)))
            `uvm_fatal("NOVIF", "No virtual interface found");
        `uvm_info("AXI4 Write Driver", "Finished building driver", UVM_MEDIUM)

    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("AXI4 Write Driver", "Running driver", UVM_MEDIUM)
        reset();
        write_operation();

    endtask

    task reset();
        `uvm_info("Driver", "Resetting driver", UVM_MEDIUM)
        vif.s_axil_awvalid <= 1'b0;
        vif.s_axil_wvalid <= 1'b0;
        vif.s_axil_bready <= 1'b0;
        vif.s_axil_awaddr <= '0;
        vif.s_axil_awprot <= '0;
        vif.s_axil_wdata <= '0;
        vif.s_axil_wstrb <= '0;
        @(posedge vif.clk);
        @(posedge vif.clk);

        `uvm_info("Driver", "Finished resetting driver", UVM_MEDIUM)
    endtask


task write_operation();

  fork
        write_address(); // Write address
        
        write_data(); // Write data
       forever begin
           `ifdef IDEAL
                vif.s_axil_bready <= 1'b1; // Set ready for write response in ideal mode
            `else
                vif.s_axil_bready <=  $urandom_range(0, 1); // Set ready for write response
            `endif
           @(posedge vif.clk); // Wait for clock edge
           if(vif.s_axil_bvalid && vif.s_axil_bready) begin
               write_address_done = 0; // Reset write address done flag
               write_data_done = 0; // Reset write data done flag
           end
       end

  join_none

endtask : write_operation

task write_address();
    forever begin
        @(posedge vif.clk); // Wait for clock edge
        if(!write_address_done) begin // Waits till response is received before the next write operation
            address_item = AXI4_seq_item::type_id::create("address_item", this);

            rw_sem.get(); // Acquire semaphore for getting a sequence item
            seq_item_port.get_next_item(address_item);
            seq_item_port.item_done(); // Indicate that the item is done
            rw_sem.put(); // Release semaphore 
            
            repeat(address_item.w_addr_delay) @(posedge vif.clk); // Random delay for address write
            `uvm_info("AXI4 Write Driver", "Writing address ", UVM_MEDIUM)
            vif.s_axil_awaddr <= address_item.s_axil_awaddr;
            vif.s_axil_awprot <= address_item.s_axil_awprot;
            if(address_item.valid_write_address) begin // If the address is valid for write operation
                write_address_done = 1; // Indicate that write address is done
                vif.s_axil_awvalid <= 1'b1;
                @(posedge vif.clk);
                while(!vif.s_axil_awready) // Wait for ready signal to complete the handshake
                    @(posedge vif.clk);
                vif.s_axil_awvalid <= 1'b0;
                address_written++;
                `uvm_info("AXI4 Write Driver", "Finished writing address", UVM_MEDIUM)
            end
        end
    end

endtask : write_address

task write_data();
    forever begin
        @(posedge vif.clk); // Wait for clock edge
        if(!write_data_done) begin // Waits till response is received before the next write operation
            data_item = AXI4_seq_item::type_id::create("data_item", this);

            rw_sem.get(); // Acquire semaphore for getting a sequence item
            seq_item_port.get_next_item(data_item);
            seq_item_port.item_done(); // Indicate that the item is done
            rw_sem.put(); // Release semaphore 

            `uvm_info("AXI4 Write Driver", "Writing data", UVM_MEDIUM)
            vif.s_axil_wdata <= data_item.s_axil_wdata;
            vif.s_axil_wstrb <= data_item.s_axil_wstrb;
            repeat(data_item.w_data_delay) @(posedge vif.clk); // Random delay for data write
            if(data_item.valid_write_data) begin    // If the data is valid for write operation
                write_data_done = 1; // Indicate that write data is done
                vif.s_axil_wvalid <= 1'b1;
                @(posedge vif.clk);
                while(!vif.s_axil_wready) // Wait for ready signal to complete the handshake
                    @(posedge vif.clk);
                vif.s_axil_wvalid <= 1'b0;
                `uvm_info("AXI4 Write Driver", "Finished writing data", UVM_MEDIUM)
            end
        end
    end
   
endtask : write_data

 function void report_phase(uvm_phase  phase);
        super.report_phase(phase);
        `uvm_info("report_phase","*************AXI4_Write_Driver**************************",UVM_LOW)
        `uvm_info("report_phase", $sformatf("total number of Write transactions count : %0d", address_written),UVM_LOW)
        `uvm_info("report_phase","******************************************************",UVM_LOW) 
  endfunction

endclass : AXI4_write_driver

