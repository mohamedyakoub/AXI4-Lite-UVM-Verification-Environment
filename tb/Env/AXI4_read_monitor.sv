class AXI4_read_monitor extends uvm_monitor;
  `uvm_component_utils(AXI4_read_monitor)
  virtual AXI4_if vif;  // Connect this via uvm_config_db
  uvm_analysis_port #(AXI4_seq_item) mon_ap;

   AXI4_seq_item read_item, addr_item, addr_queue[$];
  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!(uvm_config_db#(virtual AXI4_if)::get(this, "", "vif", vif)))
      `uvm_fatal("NOVIF", "Virtual interface not set for AXI4_monitor");
  endfunction

  task run_phase(uvm_phase phase);

    forever begin
      @(posedge vif.clk or posedge vif.rst);
      if (vif.rst) begin
        addr_queue.delete();  // Clear the address queue on reset
       
      end
      else begin
        address_phase();
        response_phase();
      end
    end
    
  endtask
  
 //////////////////// read opertion ////////////////
  // Address phase
  task address_phase;
      // Check if reset is not asserted
      if(vif.rst == 1'b0) begin
        if(vif.s_axil_arvalid && vif.s_axil_arready)
        begin
            addr_item = AXI4_seq_item::type_id::create("addr_item");
            addr_item.s_axil_araddr = vif.s_axil_araddr;
            addr_item.s_axil_arprot = vif.s_axil_arprot;
            addr_item.s_axil_rready = 0;
            mon_ap.write(addr_item);  // the read address is sent first to prepare the data that will be compared in the scoreboard before the data is received
            addr_queue.push_back(addr_item);
        end
      end
      else addr_queue.delete();
     
    
  endtask : address_phase
  // Data phase
  task response_phase;
    
      if(vif.rst == 1'b0) begin
        if(vif.s_axil_rvalid && vif.s_axil_rready)
            if(addr_queue.size() > 0) begin
                read_item = AXI4_seq_item::type_id::create("read_item");
                read_item.s_axil_araddr = addr_queue[0].s_axil_araddr;
                read_item.s_axil_arprot = addr_queue[0].s_axil_arprot;
                read_item.s_axil_rdata = vif.s_axil_rdata;
                read_item.s_axil_rresp = vif.s_axil_rresp;
                read_item.s_axil_rready = vif.s_axil_rready;
                addr_queue.delete(0); // Remove the address item after processing
                mon_ap.write(read_item);  // Send to scoreboard or coverage collector
            end
            else begin
                `uvm_error("AXI4_read_monitor", "read response received without corresponding address ");
            end
      end
      
  endtask : response_phase


endclass

