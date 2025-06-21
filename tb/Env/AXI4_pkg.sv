package AXI4_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "AXI4_seq_item.sv"
`include "AXI4_cfg.sv"
`include "../Tests/AXI4_seq.sv"
`include "AXI4_scoreboard.sv"
`include "AXI4_read_cov.sv"
`include "AXI4_write_cov.sv"
`include "AXI4_write_driver.sv"
`include "AXI4_read_driver.sv"
`include "AXI4_write_monitor.sv"
`include "AXI4_read_monitor.sv"
`include "AXI4_sequencer.sv"
`include "AXI4_read_agent.sv"
`include "AXI4_write_agent.sv"
`include "AXI4_agent.sv"
`include "../Tests/virtual_seqr.sv"
`include "../Tests/Virtual_seq.sv"
`include "../Tests/Write_Read_Seq.sv"
`include "../Tests/Concurrent_Seq.sv"
`include "AXI4_enviroment.sv"
`include "../Tests/AXI4_test.sv"
`include "../Tests/Write_Read_Test.sv"
`include "../Tests/Concurrent_Test.sv"


endpackage 
