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
├── src/ # DUT source files (e.g., axil_ram.v)
├── tb/ # Testbench files
│ ├── axi4_write_driver.sv
│ ├── axi4_read_driver.sv
│ ├── axi4_monitors.sv
│ ├── axi4_scoreboard.sv
│ ├── axi4_seq_item.sv
│ ├── axi4_sequences.sv
│ ├── axi4_environment.sv
│ └── axi4_test.sv
├── interface/ # Virtual interface definitions
│ └── axi4_if.sv
├── sim/ # Simulation files (compile/run scripts)
├── docs/ # Documentation and waveform captures
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
