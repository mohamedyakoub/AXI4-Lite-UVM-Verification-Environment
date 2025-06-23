class AXI4_enviroment extends uvm_env;
  `uvm_component_utils(AXI4_enviroment)

   AXI4_agent         agent;
   AXI4_virtual_sequencer  virt_seqr;
   AXI4_scoreboard   scb;


  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction:new

  //////////////////BUILD PHASE////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = AXI4_agent::type_id::create("agent",this);
    virt_seqr    = AXI4_virtual_sequencer::type_id::create("virt_seqr",this);
    scb          = AXI4_scoreboard::type_id::create("scb",this);

  endfunction: build_phase

  //////////////CONNECT PHASE///////////////////////
  function void connect_phase(uvm_phase phase);
  
    agent.write_port.connect(scb.write_ap);  // Connect agent's write port to scoreboard's write analysis port
    agent.read_port.connect(scb.read_ap);    // Connect agent's read port to scoreboard's read analysis port
    virt_seqr.read_seqr = agent.read_agent.sequencer; // Connect the virtual sequencer to the agent's sequencer
    virt_seqr.write_seqr = agent.write_agent.sequencer; // Connect the virtual sequencer to the agent's sequencer

  endfunction: connect_phase

 endclass:AXI4_enviroment
