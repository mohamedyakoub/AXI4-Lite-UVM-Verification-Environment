# AXI4 Lite UVM Verification Environment
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
## **Tests:**
I created 2 Tests 
1. Concurrent Test: Read and Write happens at the same time randomly and nothing is controlling it
2. Write Read Test: Write to the memory number of times then after finishing the Write sequence, Starts the Read sequence

There is also a macro I added so the system can be ideal because in the tests above the system delays and valid signals were randomized so it doesnt always write and read 
The macro holds the ready signals for the response channels to be always high, And the delays are 0.
If you want to use the Ideal case 
In the run.do file in the vlog line add
```
+define+IDEAL
```

## ⚙️ How to Run

1. **Clone the repo:**
   ```bash
   git clone https://github.com/<your-username>/axi4lite_uvm_tb.git
   cd axi4lite_uvm_tb
2. **Set the directory in Questa**
In questa change the directory you are in to the sim directory
3. **Compile and simulate:**
just use the run.do file
In the transcript write
```
do run.do
```

## 🧠 AXI-Lite Protocol Notes
No support for outstanding transactions

Read and write channels are fully independent

Address and data phases may arrive in any order

Handshakes follow valid/ready rule for all channels

## 🚀 Goals
Stress-test DUT with random interleaving of read/write ops

Validate behavior under corner cases

Achieve high functional coverage

Use UVM methodology best practices

Use assertions to catch real protocol violations in waveform-free form

## Waveforms and transcript
1. Concurrent Test [Ideal]
![Concurrent_Test_Ideal](https://github.com/user-attachments/assets/2354fb2e-9f60-4055-b292-84b9764dd8a5)
![Concurrent_Test_Ideal_log](https://github.com/user-attachments/assets/5a285c7a-7a71-4f46-9432-a9a0adc53d06)
2. Concurrent Test [Non-Ideal]
![Concurrent_Test_Non_Ideal](https://github.com/user-attachments/assets/c8020bfe-bdd7-4187-bddd-7eb6fe2087df)
![Concurrent_Test_Non_Ideal_log](https://github.com/user-attachments/assets/11f8c094-9055-478d-bbc9-540fe92b13a9)
3. Write Read Test [Ideal]

   Write
![Write_Ideal](https://github.com/user-attachments/assets/c34e725b-6acd-4338-904b-cfc9e626a4ca)
   Read
![Read_Ideal](https://github.com/user-attachments/assets/1cf9b9c2-bec2-4d9a-9ccf-c8bd94696aa9)

   ![Write_Read_Ideal](https://github.com/user-attachments/assets/e59227bb-8e85-43c1-a027-8fa7046ac2f4)

## Coverage 
![coverage](https://github.com/user-attachments/assets/ad473aa4-c9be-4142-924e-63af06373800)

## 🛠️ To-Do

 Enhance scoreboard with backdoor memory mirroring (RAL)

 Inject some errors
 

## 📖 References
AMBA AXI4-Lite Spec

UVM User Guide

Alex Forencich’s AXI RAM (used as DUT)

👨‍💻 Author
Mohamed – Design & Verification Engineer
If you find this useful, feel free to star 🌟 the repo or raise an issue!
