class AXI4_agent extends uvm_agent;
  `uvm_component_utils(AXI4_agent)
  // Declaring agent components
  AXI4_read_agent read_agent;
  AXI4_write_agent write_agent;
  // Analysis ports to forward transactions from monitors
  uvm_analysis_port #(AXI4_seq_item) write_port, read_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Creating analysis ports
    write_port = new("write_port", this);
    read_port = new("read_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Creating the read and write agents
    read_agent = AXI4_read_agent::type_id::create("read_agent", this);
    write_agent = AXI4_write_agent::type_id::create("write_agent", this);
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    // Connecting each agent with its corresponding port
    write_agent.write_port.connect(write_port);
    read_agent.read_port.connect(read_port);
  endfunction : connect_phase

endclass


