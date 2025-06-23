# AXI4-Lite-UVM-Verification-Environment
This repository contains a complete UVM-based verification environment for an **AXI4-Lite slave interface**. The goal of this project is to **verify compliance** with the AMBA AXI4-Lite protocol through **exhaustive randomized and constrained stimulus**, protocol assertions, and functional coverage.

## 📌 Features

- ✅ AXI4-Lite protocol support (write & read channels fully modeled)
- ✅ Independent read and write agents (as per AXI4-Lite independence)
- ✅ Protocol-compliant driver with **separated address/data channels**
- ✅ Monitors with **queue-based matching** and transaction analysis
- ✅ Scoreboard for data checking
- ✅ AXI4-Lite assertions (SystemVerilog Assertions - SVA)
- ✅ Functional coverage model for AXI4-Lite behavior
- ✅ Configurable delays (address/data)
- ✅ Reset and ready/valid handshake handling
- 🧪 Support for concurrent transactions (within AXI-Lite limits)

## 📁 Project Structure
```
axi4lite_uvm_tb/
├── src/ # DUT source files
│   └── axil_ram.v
├── tb/ # Testbench files
│   ├── Env/
│   │   ├── AXI4_agent.sv
│   │   ├── AXI4_Assertions.sv
│   │   ├── AXI4_cfg.sv
│   │   ├── AXI4_environment.sv
│   │   ├── AXI4_pkg.sv
│   │   ├── AXI4_read_agent.sv
│   │   ├── AXI4_read_cov.sv
│   │   ├── AXI4_read_driver.sv
│   │   ├── AXI4_read_monitor.sv
│   │   ├── AXI4_scoreboard.sv
│   │   ├── AXI4_seq_item.sv
│   │   ├── AXI4_sequencer.sv
│   │   ├── AXI4_write_agent.sv
│   │   ├── AXI4_write_cov.sv
│   │   ├── AXI4_write_driver.sv
│   │   ├── AXI4_write_monitor.sv
│   │   └── tb.sv
│   ├── Tests/
│   │   ├── AXI4_ideal_seq.sv
│   │   ├── AXI4_seq.sv
│   │   ├── AXI4_test.sv
│   │   ├── Concurrent_Seq.sv
│   │   ├── Concurrent_Test.sv
│   │   ├── Virtual_seq.sv
│   │   ├── virtual_seqr.sv
│   │   ├── Write_Read_Seq.sv
│   └── └── Write_Read_Test.sv
├── interface/ # Virtual interface definitions
│   └── axi4_if.sv
├── sim/ # Simulation files (compile/run scripts)
│   └── run.do
├── docs/                            # Documentation and simulation output
│   ├── Concurrent_Test_Ideal.jpg      # Logs and waveform snapshots for ideal scenarios
│   ├── Concurrent_Test_Ideal_log.jpg      # Logs and waveform snapshots for ideal scenarios
│   ├── Concurrent_Test_Non_Ideal.jpg  # Non-ideal  logs
│   ├── Concurrent_Test_Non_Ideal_log.jpg  # Non-ideal  logs
│   ├── Read_Ideal.jpg                     # Waveform snapshot for ideal read transaction
│   ├── Write_Ideal.jpg                    # Waveform snapshot for ideal write transaction
│   ├── Write_Read_Ideal_log.jpg               # Waveform snapshot for mixed transaction
│   ├── coverage_rpt.txt                   # Coverage report (functional/code)
│   ├── coverage.jpg                       # Visual representation of coverage
│   └── logs                               # (contain UVM and QuestaSim log files)
└── README.md # You’re here
```
## ⚙️ How to Run

1. **Clone the repo:**
   ```bash
   git clone https://github.com/<your-username>/axi4lite_uvm_tb.git
   cd axi4lite_uvm_tb
2. **Compile and simulate:**
Use your simulator of choice (QuestaSim, VCS, Xcelium, etc.)


## 🧠 AXI-Lite Protocol Notes
No support for outstanding transactions

Read and write channels are fully independent

Address and data phases may arrive in any order

Handshakes follow valid/ready rule for all channels

This testbench respects these constraints while also testing for misbehavior (e.g., premature data, missing response, stuck signals).

## 🚀 Goals
Stress-test DUT with random interleaving of read/write ops

Validate behavior under corner cases

Achieve high functional coverage

Use UVM methodology best practices

Use assertions to catch real protocol violations in waveform-free form

## 🛠️ To-Do
 Add AXI-lite burst violation checks

 Enhance scoreboard with backdoor memory mirroring

 Add corner-case regression suite

 Hook into GitHub Actions for CI testing

## 📖 References
AMBA AXI4-Lite Spec

UVM User Guide

Alex Forencich’s AXI RAM (used as DUT)

👨‍💻 Author
Mohamed – Design & Verification Engineer
If you find this useful, feel free to star 🌟 the repo or raise an issue!
