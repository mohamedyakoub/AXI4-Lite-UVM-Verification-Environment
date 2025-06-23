`uvm_analysis_imp_decl(_w)
`uvm_analysis_imp_decl(_r)
class AXI4_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(AXI4_scoreboard)

    int read_trans,write_trans,correct,incorrect;
    AXI4_seq_item Read_item,Read_queue[$],Write_item,Write_queue[$];
    uvm_analysis_imp_w#(AXI4_seq_item,AXI4_scoreboard) write_ap;
    uvm_analysis_imp_r#(AXI4_seq_item,AXI4_scoreboard) read_ap;
    bit [31:0] ram[int];
    bit [31:0] golden; // golden value for the read transaction

    function new(string name="scoreboard", uvm_component parent=null);
        super.new(name, parent);
        write_ap=new("write_ap",this);
	    read_ap=new("read_ap",this);

    endfunction

    function  void build_phase(uvm_phase phase);
    super.build_phase(phase);
    endfunction

	// caputring the expected from the refrence model
    function void  write_w(AXI4_seq_item item);
        if(item.rst) begin
            `uvm_info("AXI4_Scoreboard", "Resetting scoreboard", UVM_LOW)
            ram.delete(); // clearing the ram
        end
        else begin
            write_trans++;
            Write_queue.push_back(item); // pushing the write item to the queue
            `uvm_info("AXI4_Scoreboard", $sformatf("Write transaction at address %0h with data %0h", item.s_axil_awaddr>>2, item.s_axil_wdata), UVM_HIGH)
        end
        
    endfunction
	// caputring the actual from the monitor
    function void  write_r(AXI4_seq_item item);
        Read_queue.push_back(item); // pushing the read item to the queue
        `uvm_info("AXI4_Scoreboard", $sformatf("Read transaction at address %0h with data %0h", item.s_axil_araddr>>2, item.s_axil_rdata), UVM_HIGH)
    endfunction

    // Run phase
    task  run_phase(uvm_phase phase);
        `uvm_info("AXI4_Scoreboard", "axil_ram Scoreboard is running", UVM_LOW)
        forever begin
            // Wait for the write and read transactions to be captured
            wait(Read_queue.size() > 0 || Write_queue.size() > 0);

            if(Read_queue.size() > 0) begin
                Read_item = Read_queue.pop_front(); // Get the read item from the queue
                if(!Read_item.s_axil_rready)
                    reference_model(Read_item,golden); // Call the golden function to get the expected value
                else begin
                    compare(Read_item,golden); // Call the compare function to process the read item
                    read_trans++;
                end
            end
            
            if(Write_queue.size() > 0) begin
                Write_item = Write_queue.pop_front(); // Get the write item from the queue
                Write_to_ram(Write_item); // Call the write function to process the write item
            end
            end
                
    endtask

    task Write_to_ram(AXI4_seq_item item);
        if(item.s_axil_bresp==2'b00) begin // checking if the write response is OK
            foreach(item.s_axil_wstrb[i]) begin
                if(item.s_axil_wstrb[i]) begin // checking if the write strobe is valid
                    ram[item.s_axil_awaddr>>2][(i*8)+:8] = item.s_axil_wdata[(i*8)+:8]; // writing the data to the ram
                end
            end
            `uvm_info("AXI4_Scoreboard", $sformatf("Write transaction at address %0h with data %0h", item.s_axil_awaddr>>2, item.s_axil_wdata), UVM_HIGH)
        end
        else begin
            `uvm_info("AXI4_Scoreboard", "Write transaction because response wasn't okay", UVM_LOW)
        end
    endtask

    task reference_model(AXI4_seq_item item, output logic [31:0] golden);      
            if(ram.exists(item.s_axil_araddr>>2)) begin // checking if the address exists in the ram
                golden = ram[item.s_axil_araddr>>2]; // getting the data from the ram
            end
            else begin
                `uvm_info("AXI4_Scoreboard", $sformatf("Read transaction at address %0h but address doesn't exist in ram", item.s_axil_araddr>>2), UVM_HIGH)
                golden = 32'b0; // if the address doesn't exist in the ram, set the golden value to 0
            end
    endtask

    task compare(AXI4_seq_item item, logic [31:0] golden);
        if(item.s_axil_rresp==2'b00) begin // checking if the read response is OK
            if(item.s_axil_rdata == golden) begin // getting the data from the ram
                `uvm_info("AXI4_Scoreboard", "Read transaction is correct", UVM_MEDIUM)
                `uvm_info("AXI4_Scoreboard", $sformatf("Read transaction at address %0h with data %0h", item.s_axil_araddr>>2, golden), UVM_HIGH)
                correct++;
            end
            else begin
                `uvm_error("AXI4_Scoreboard", "Read transaction is incorrect")
                `uvm_info("AXI4_Scoreboard", $sformatf("Expected: %0h, Actual: %0h at address: %0h", golden, item.s_axil_rdata, item.s_axil_araddr>>2), UVM_LOW)
                incorrect++;
            end
            end
        else begin
            `uvm_info("AXI4_Scoreboard", "Read transaction because response wasn't okay", UVM_LOW)
        end
    endtask
    function void report_phase(uvm_phase  phase);
        super.report_phase(phase);
        `uvm_info("report_phase","*************AXI4_Scoreboard**************************",UVM_LOW)
        `uvm_info("report_phase", $sformatf("total number of transactions: %0d",read_trans+write_trans),UVM_LOW)
        `uvm_info("report_phase", $sformatf("total number of read transactions: %0d",read_trans),UVM_LOW)
        `uvm_info("report_phase", $sformatf("total number of write transactions: %0d",write_trans),UVM_LOW)

        `uvm_info("report_phase", $sformatf("total succesful transactions: %0d",correct),UVM_LOW)
        `uvm_info("report_phase", $sformatf("total failled transactions: %0d",incorrect),UVM_LOW) 
        `uvm_info("report_phase","******************************************************",UVM_LOW) 
  endfunction
endclass



