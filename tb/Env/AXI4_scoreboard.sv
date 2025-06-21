`uvm_analysis_imp_decl(_w)
`uvm_analysis_imp_decl(_r)
class AXI4_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(AXI4_scoreboard)

    int read_trans,write_trans,correct,incorrect;
    uvm_analysis_imp_w#(AXI4_seq_item,AXI4_scoreboard) write_ap;
    uvm_analysis_imp_r#(AXI4_seq_item,AXI4_scoreboard) read_ap;
    bit [31:0] ram[int];

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
        end
        
    endfunction
	// caputring the actual from the monitor
    function void  write_r(AXI4_seq_item item);
        read_trans++;
        if(item.s_axil_rresp==2'b00) begin // checking if the read response is OK
            if(ram.exists(item.s_axil_araddr>>2)) begin // checking if the address exists in the ram
                if(item.s_axil_rdata == ram[item.s_axil_araddr>>2]) begin // getting the data from the ram
                    `uvm_info("AXI4_Scoreboard", "Read transaction is correct", UVM_MEDIUM)
                    `uvm_info("AXI4_Scoreboard", $sformatf("Read transaction at address %0h with data %0h", item.s_axil_araddr>>2, ram[item.s_axil_araddr>>2]), UVM_HIGH)
                    correct++;
                end
                else begin
                    `uvm_error("AXI4_Scoreboard", "Read transaction is incorrect")
                    `uvm_info("AXI4_Scoreboard", $sformatf("Expected: %0h, Actual: %0h at address: %0h", ram[item.s_axil_araddr>>2], item.s_axil_rdata, item.s_axil_araddr>>2), UVM_HIGH)
                    incorrect++;
                end
            end
            else begin
                `uvm_info("AXI4_Scoreboard", $sformatf("Read transaction at address %0h but address doesn't exist in ram", item.s_axil_araddr>>2), UVM_HIGH)
                if(item.s_axil_rdata == 32'b0) begin // getting the data from the ram
                    `uvm_info("AXI4_Scoreboard", "Read transaction is correct", UVM_MEDIUM)
                    `uvm_info("AXI4_Scoreboard", $sformatf("Read transaction at address %0h with data 0", item.s_axil_araddr>>2), UVM_HIGH)
                    correct++;
                end
                else begin
                    `uvm_error("AXI4_Scoreboard", "Read transaction is incorrect")
                    `uvm_info("AXI4_Scoreboard", $sformatf("Expected: 0, Actual: %0h", item.s_axil_rdata), UVM_HIGH)
                    incorrect++;
                end
            end
        end
        else begin
            `uvm_info("AXI4_Scoreboard", "Read transaction because response wasn't okay", UVM_LOW)
        end
        
    endfunction

   
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



