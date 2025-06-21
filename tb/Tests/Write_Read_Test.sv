class AXI4_write_read_test extends AXI4_test;

	`uvm_component_utils(AXI4_write_read_test)

	function new(string name = "AXI4_write_read_test", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);

		virtual_seq::type_id::set_type_override(AXI4_write_read_seq::get_type());

		super.build_phase(phase);
		
	endfunction: build_phase


endclass: AXI4_write_read_test
