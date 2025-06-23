class AXI4_write_cov extends uvm_subscriber#(AXI4_seq_item);
   `uvm_component_utils(AXI4_write_cov)
   AXI4_seq_item tr;
   localparam max_pos ={32{1'b1}};
   localparam special1 = {16{{1'b0},{1'b1}}}; // pattern of zeros and ones
   localparam special2 = {16{{1'b1},{1'b0}}}; // pattern of ones and zeros
   covergroup AXI4_write_CovGrp;
	//Cover that the data read from the register from port a [rs1] has used all these values
        wdata_cp : coverpoint tr.s_axil_wdata {
            bins MAXPOS = {max_pos};
            bins ZERO = {31'b0};
            bins special1_b = {special1}; // pattern of zeros and ones
            bins special2_b = {special2}; // pattern of ones and zeros
            bins rest[4] = {[1:(max_pos-1)]};
        }	
    // Cover that the write strobes have used all these values
        wstrb_cp : coverpoint tr.s_axil_wstrb{
            bins ALL_ONES = {4'b1111};
            bins ALL_ZEROS = {4'b0000};
            bins one_zero = {4'b0111, 4'b1011, 4'b1101, 4'b1110}; // patterns with one bit set to zero
            bins two_zeros = {4'b1100, 4'b1010, 4'b1001, 4'b0110, 4'b0101, 4'b0011}; // patterns with two bits set to zero
            bins three_zeros = {4'b1000, 4'b0100, 4'b0010, 4'b0001}; // patterns with three bits set to zero
        }
	// Cover that all the addresses were written in the write operation
        waddr_cp : coverpoint tr.s_axil_awaddr;
        
    // Because the current design doesnt support the protection bits, we will not cover them
        // waddr_prot_cp : coverpoint tr.s_axil_awprot[0] {
        //     bins Unpriv = {1'b0}; // Unprivileged access
        //     bins Priv = {1'b1}; // Privileged access
        // }
        // waddr_prot_cp : coverpoint tr.s_axil_awprot[1] {
        //         bins Secure = {1'b0}; 
        //         bins Non_Secure = {1'b1}; 
        // }
        // waddr_prot_cp : coverpoint tr.s_axil_awprot[2] {
        //         bins Data = {1'b0}; 
        //         bins Inst = {1'b1}; 
        // }

    endgroup
    function new(string name="AXI4_write_cov", uvm_component parent=null);
        super.new(name, parent);
        AXI4_write_CovGrp=new();
    endfunction
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    function void write(T t);
        $cast(tr, t);
        AXI4_write_CovGrp.sample();
    endfunction

endclass
