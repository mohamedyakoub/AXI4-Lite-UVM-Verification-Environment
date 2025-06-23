class AXI4_cfg  extends uvm_object;
   `uvm_object_utils(AXI4_cfg)

   bit is_active = 1; // Default to active
   
   int trans_num=50000;

   function new(string name="AXI4_cfg");
	super.new(name);
   endfunction

endclass
