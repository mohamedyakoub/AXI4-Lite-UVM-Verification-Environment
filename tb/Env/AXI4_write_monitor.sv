class AXI4_write_monitor extends uvm_monitor;
  `uvm_component_utils(AXI4_write_monitor)

  virtual AXI4_if vif;  // Connect this via uvm_config_db
  uvm_analysis_port #(AXI4_seq_item) mon_ap;

   AXI4_seq_item write_item, data_item, addr_item, addr_queue[$], data_queue[$];
  function new(string name, uvm_component parent);
    super.new(name, parent);
    //txn = AXI4_seq_item::type_id::create("txn");
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual AXI4_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for AXI4_monitor");
  endfunction

  task run_phase(uvm_phase phase);

    fork
      address_phase;
      data_phase;
      response_phase;
    join_none
    
  endtask
  
 //////////////////// Write opertion ////////////////
  // Address phase
  task address_phase;
    forever begin
      @(posedge vif.clk or posedge vif.rst);
      if (vif.rst) begin
        addr_queue.delete();  // Clear the address queue on reset
      end
      else begin
        if(vif.s_axil_awvalid && vif.s_axil_awready)
        begin
          addr_item = AXI4_seq_item::type_id::create("addr_item");
          addr_item.s_axil_awaddr = vif.s_axil_awaddr;
          addr_item.s_axil_awprot = vif.s_axil_awprot;
          addr_queue.push_back(addr_item);
        end
      end
    end
  endtask : address_phase
  // Data phase
  task data_phase;
    forever begin
      @(posedge vif.clk or posedge vif.rst);
      if (vif.rst) begin
        data_queue.delete();  // Clear the data queue on reset
      end
      else  // Check if reset is not asserted
      begin
        if(vif.s_axil_wvalid && vif.s_axil_wready )
        begin
          data_item = AXI4_seq_item::type_id::create("data_item");
          data_item.s_axil_wdata = vif.s_axil_wdata;
          data_item.s_axil_wstrb = vif.s_axil_wstrb;
          data_queue.push_back(data_item);
        end
      end
    end
  endtask : data_phase
  //Write response
  task response_phase;
    forever begin
      @(posedge vif.clk or posedge vif.rst);
      if (vif.rst) begin
        write_item = AXI4_seq_item::type_id::create("write_item");
        write_item.rst=vif.rst;
        mon_ap.write(write_item);  // Send reset item to scoreboard or coverage collector
      end
      else begin
        if(vif.s_axil_bvalid && vif.s_axil_bready)
        begin
            #1;
            if(addr_queue.size() > 0 && data_queue.size() > 0)
            begin
              write_item = AXI4_seq_item::type_id::create("write_item");
              write_item.s_axil_awaddr = addr_queue[0].s_axil_awaddr;
              write_item.s_axil_awprot = addr_queue[0].s_axil_awprot;
              write_item.s_axil_wdata = data_queue[0].s_axil_wdata;
              write_item.s_axil_wstrb = data_queue[0].s_axil_wstrb;
              write_item.s_axil_bresp = vif.s_axil_bresp;
              // write_queue.push_back(write_item);
              addr_queue.pop_front();
              data_queue.pop_front();
              mon_ap.write(write_item);  // Send to scoreboard or coverage collector
            end
            else
            begin
              `uvm_error("AXI4_write_monitor", "Write response received without corresponding address and data");
            end
        end
      end
    end
  endtask : response_phase


endclass

