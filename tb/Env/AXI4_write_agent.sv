class AXI4_write_agent extends uvm_agent;
  `uvm_component_utils(AXI4_write_agent)
  // Declaring agent components
  AXI4_write_driver    driver;
  AXI4_sequencer sequencer;
  AXI4_write_monitor    write_monitor;
  AXI4_write_cov write_cov; // Coverage collector
  AXI4_cfg  cfg;  // Config object
  // Analysis ports to forward transactions from monitors
  uvm_analysis_port #(AXI4_seq_item) write_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Creating analysis ports
    write_port = new("write_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

   // Retrieve Configuration
    if (!uvm_config_db#(AXI4_cfg)::get(this, "", "AXI4_cfg", cfg))
      `uvm_fatal("CONFIG", "Agent configuration not set!")

    write_monitor    = AXI4_write_monitor::type_id::create("write_monitor", this);
    write_cov        = AXI4_write_cov::type_id::create("write_cov", this);
    if (cfg.is_active) begin
      driver    = AXI4_write_driver::type_id::create("driver", this);
      sequencer = AXI4_sequencer::type_id::create("sequencer", this);
    end

  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    write_monitor.mon_ap.connect(write_port);
    write_monitor.mon_ap.connect(write_cov.analysis_export);
    if (cfg.is_active) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass


