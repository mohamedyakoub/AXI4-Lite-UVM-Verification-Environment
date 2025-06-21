class AXI4_read_agent extends uvm_agent;
  `uvm_component_utils(AXI4_read_agent)
  // Declaring agent components
  AXI4_read_driver    driver;
  AXI4_sequencer sequencer;
  AXI4_read_monitor    read_monitor;
  AXI4_read_cov read_cov; // Coverage collector
  AXI4_cfg  cfg;  // Config object
  // Analysis ports to forward transactions from monitors
  uvm_analysis_port #(AXI4_seq_item) read_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Creating analysis ports
    read_port = new("read_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

   // Retrieve Configuration
    if (!uvm_config_db#(AXI4_cfg)::get(this, "", "AXI4_cfg", cfg))
      `uvm_fatal("CONFIG", "Agent configuration not set!")

    read_monitor    = AXI4_read_monitor::type_id::create("read_monitor", this);
    read_cov        = AXI4_read_cov::type_id::create("read_cov", this);
    if (cfg.is_active) begin
      driver    = AXI4_read_driver::type_id::create("driver", this);
      sequencer = AXI4_sequencer::type_id::create("sequencer", this);
    end

  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    read_monitor.mon_ap.connect(read_port);
    read_monitor.mon_ap.connect(read_cov.analysis_export);
    if (cfg.is_active) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass


