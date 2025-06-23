class AXI4_read_cov extends uvm_subscriber#(AXI4_seq_item);
   `uvm_component_utils(AXI4_read_cov)
   AXI4_seq_item tr;
   localparam max_pos ={32{1'b1}};
   localparam special1 = {16{{1'b0},{1'b1}}}; // pattern of zeros and ones
   localparam special2 = {16{{1'b1},{1'b0}}}; // pattern of ones and zeros
   covergroup AXI4_read_CovGrp;
	//Cover that the data read from the register from port a [rs1] has used all these values
        rdata_cp : coverpoint tr.s_axil_rdata {
            bins MAXPOS = {max_pos};
            bins ZERO = {31'b0};
            bins special1_b = {special1}; // pattern of zeros and ones
            bins special2_b = {special2}; // pattern of ones and zeros
            bins rest[4] = {[1:(max_pos-1)]};
        }	
	// Cover that all the addresses were written in the write operation
        raddr_cp : coverpoint tr.s_axil_araddr;
    
    // Because the current design doesnt support the protection bits, we will not cover them
        // raddr_prot_cp : coverpoint tr.s_axil_arprot[0] {
        //     bins Unpriv = {1'b0}; // Unprivileged access
        //     bins Priv = {1'b1}; // Privileged access
        // }
        // raddr_prot_cp : coverpoint tr.s_axil_arprot[1] {
        //     bins Secure = {1'b0}; 
        //     bins Non_Secure = {1'b1}; 
        // }
        // raddr_prot_cp : coverpoint tr.s_axil_arprot[2] {
        //     bins Data = {1'b0}; 
        //     bins Inst = {1'b1}; 
        // }




       endgroup

    function new(string name="AXI4_read_cov", uvm_component parent=null);
        super.new(name, parent);
        AXI4_read_CovGrp=new();
    endfunction
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    function void write(T t);
        $cast(tr, t);
        AXI4_read_CovGrp.sample();
    endfunction

endclass
