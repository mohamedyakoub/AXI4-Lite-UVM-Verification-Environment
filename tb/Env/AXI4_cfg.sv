class AXI4_cfg  extends uvm_object;
   `uvm_object_utils(AXI4_cfg)
   //virtual AXI4_if vif;
   bit is_active = 1; // Default to active
   
   int inst_num=50000;

   function new(string name="AXI4_cfg");
	super.new(name);
   endfunction

endclass
