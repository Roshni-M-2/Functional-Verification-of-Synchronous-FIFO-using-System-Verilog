# Design and Functional Verification of a Parameterized Synchronous FIFO using SystemVerilog

A SystemVerilog RTL design and functional verification project for a **parameterized synchronous FIFO**, including a class based verification environment, directed and constrained random stimulus, scoreboard checking, and coverage analysis.

## Project Highlights

- Parameterized synchronous FIFO RTL
- Configurable FIFO depth and data width
- Full and empty status generation
- Class based SystemVerilog verification environment
- Generator, driver, monitor, scoreboard, environment and test
- Mailbox based transaction communication
- Directed boundary condition testing
- Constrained random traffic
- Functional coverage with cover points and cross coverage
- Vivado code coverage analysis

## Repository Structure

```text
Functional-Verification-of-Synchronous-FIFO-using-SystemVerilog/
├── README.md
│
├── src/
│   └── synchronous_fifo.sv
│
├── tb/
│   ├── fifo_pkg.sv
│   ├── fifo_intf.sv
│   ├── transaction.sv
│   ├── generator.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── env.sv
│   ├── test.sv
│   ├── top.sv
│   
|── coverage/
│       ├── code_coverage/
│       │   ├── dashboard.html
│       │   ├── files.html
│       │   ├── modules.html
│       │   ├── file1.html ... file7.html
│       │   └── mod1.html ... mod7.html
│       │
│       └── functional_coverage/
│           ├── dashboard.html
│           ├── groups.html
│           └── grp0.html
│
```

## RTL Design

The FIFO RTL is located at:

`src/synchronous_fifo.sv`

The implementation is parameterized by:

- `DEPTH`
- `DATA_WIDTH`

The FIFO provides synchronous write/read operation and `full` / `empty` status signals.

## Verification Environment

The testbench follows:

```text
Generator → Driver → DUT → Monitor → Scoreboard
```

### Components

| Component | Purpose |
|---|---|
| `fifo_pkg.sv` | Package-level definitions |
| `fifo_intf.sv` | FIFO interface |
| `transaction.sv` | Transaction object |
| `generator.sv` | Directed and constrained random stimulus generator |
| `driver.sv` | Drives transactions to the DUT |
| `monitor.sv` | Samples DUT activity and collects functional coverage |
| `scoreboard.sv` | Reference model |
| `env.sv` | Verification environment |
| `test.sv` | Test control |
| `top.sv` | Simulation top level |

## Verification Strategy

The verification environment exercises:

- FIFO filling to the full condition
- FIFO draining to the empty condition
- FIFO boundary conditions
- Simultaneous read/write activity
- Read attempts while empty
- Write attempts while full
- Mixed constrained random traffic

The scoreboard uses an expected data model to compare observed FIFO behavior against the expected sequence.

## Coverage Results

### 1. Code Coverage

The supplied Vivado Simulator 2023.1 code coverage report contains Statement, Branch, Condition and Toggle coverage.

| Coverage Type | Score |
|---|---:|
| **Statement** | **100%** |
| **Branch** | **76.1905%** |
| **Condition** | **100%** |
| **Toggle** | **17.42%** |

See:

`tb/coverage/code_coverage/dashboard.html`

for the complete report.

### 2. Functional Coverage

The supplied Vivado functional coverage report shows:

| Metric | Score |
|---|---:|
| **Functional Coverage** | **100%** |
| **Instance Coverage** | **100%** |
| Tests | **1** |

The functional coverage report contains the monitor covergroup, cover points and cross coverage.

See:

`tb/coverage/functional_coverage/dashboard.html`

for the complete report.

## Tools

- Vivado Simulator 2023.1

## Running the Simulation

The project was developed using **Vivado Simulator 2023.1**.

1. Create a Vivado project.
2. Add `rtl/synchronous_fifo.sv` as a design source.
3. Add the files under `tb/` as simulation sources.
4. Set `top` as the simulation top.
5. Run Behavioral Simulation.
