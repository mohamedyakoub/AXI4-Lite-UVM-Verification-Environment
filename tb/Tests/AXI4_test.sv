import AXI4_pkg::*;
class AXI4_test extends uvm_test;
	`uvm_component_utils(AXI4_test)
	int write_num=20000,
		read_num=10000;

	AXI4_enviroment env;
	virtual_seq vseq;

	AXI4_cfg	write_cfg,read_cfg;

	function new(string name = "AXI4_test", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		`ifdef IDEAL
			AXI4_seq::type_id::set_type_override(AXI4_ideal_seq::get_type()); // Override the base sequence type with the ideal sequence type, If you want non ideal just comment this line
		`endif

		super.build_phase(phase);
		write_cfg = AXI4_cfg::type_id::create("write_cfg", this);
		read_cfg = AXI4_cfg::type_id::create("read_cfg", this);
		vseq = virtual_seq::type_id::create("vseq", this);
		env  = AXI4_enviroment::type_id::create("env", this);

		/////////////////////////////////////

		write_cfg.trans_num=write_num;
		read_cfg.trans_num=read_num;
		uvm_config_db#(AXI4_cfg)::set(this, "*.write_agent*", "AXI4_cfg", write_cfg);
		uvm_config_db#(AXI4_cfg)::set(this, "*.read_agent*", "AXI4_cfg", read_cfg);
		/////////////////////////////////////
	endfunction: build_phase


	  task run_phase (uvm_phase phase);
		super.run_phase(phase);
		
		
		phase.raise_objection(this);
			vseq.start(env.virt_seqr);
		phase.drop_objection(this);
		//set drain time
		
	  endtask: run_phase

endclass: AXI4_test



