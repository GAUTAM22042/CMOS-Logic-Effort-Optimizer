# ECE 558 Lab 2: Logic Effort and Optimal Driver Design

**Digital Integrated Circuits - CMOS Half-Adder Accumulator**  
University of Massachusetts Amherst | Fall 2024  
**Gautam Jayakishan** | gjayakishan@umass.edu

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Project Overview

Full-custom VLSI design of a CMOS half-adder accumulator bitslice using Cadence Virtuoso and HSPICE. This project demonstrates advanced digital IC design skills including logic effort optimization, layout verification, and post-silicon power analysis.

### Key Achievements

| Metric | Result |
|--------|--------|
| **Speedup** | 6.3× (optimal driver vs direct connection) |
| **Delay Reduction** | 110τ → 17.33τ |
| **Power Model** | P = 0.23µW + (2.08×10⁻¹⁴ W/Hz)·f |
| **Process** | GPDK 45nm CMOS |
| **Verification** | ✅ DRC/LVS Clean |

---

## Technical Implementation

### Part 1: Logic Effort Analysis

**Problem**: Drive a 109× fanout with minimal delay

**Solution**: Two-stage optimized driver chain

```
Direct connection:     110τ delay
Optimal 2-stage:       17.33τ delay
Improvement:           6.35× faster
```

**Transistor Sizing Progression**:
- Stage 1: 4.78× minimum size (Wn=573nm, Wp=1.15µm)
- Stage 2: 22.8× minimum size (Wn=2.74µm, Wp=5.47µm)  
- Load: 109× minimum size (Wn=13.1µm, Wp=26.2µm)

### Part 2: Circuit Design

**Half-Adder Truth Table**:
| SOUT | CIN | S (XOR) | COUT |
|------|-----|---------|------|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |

**Implementation**:
- XOR gate using transmission gates
- NAND gate for reset control
- SR latches for state storage
- Clocked at 1 GHz (PHI signal)

### Part 3: Post-Layout Power Analysis

**Frequency Sweep Results**:

| Frequency | Measured Power |
|-----------|---------------|
| 500 MHz | 10.64 µW |
| 667 MHz | 14.19 µW |
| 1 GHz | 21.12 µW |
| 2 GHz | 41.87 µW |

**Power-Frequency Model**:
```
P(f) = 2.3×10⁻⁷ W + (2.08×10⁻¹⁴ W/Hz) × f
```

**Key Findings**:
- Static power: 0.23 µW (leakage)
- Dynamic coefficient: 2.08×10⁻¹⁴ W/Hz
- Crossover frequency: ~100 MHz (static = 10% of total)
- Linear relationship confirms CMOS switching dominates

### Part 4: Timing Verification

**Hold-Time Analysis**:
- ❌ **Violation**: RST rising 20ps before PHI → premature SOUT switching
- ✅ **Fixed**: Delayed RST by +10ps → correct operation restored

---

## Repository Contents

### Simulation Files

```
simulations/
├── spice/
│   ├── step3_gjayakishan.sp      # Functional testbench
│   ├── step5_0.5GHz.sp           # Power @ 500 MHz
│   ├── step5_1.5GHz.sp           # Power @ 1.5 GHz  
│   ├── step5_1GHz.sp             # Power @ 1 GHz
│   └── step5_2GHz.sp             # Power @ 2 GHz
│
├── results/
│   ├── step3_gjayakishan.tr0     # Waveform data
│   ├── step5_*.tr0               # Power sweep waveforms
│   └── *.ic0, *.mt0, *.pa0       # SPICE output files
│
└── logs/
    └── logs_gjayakishan/         # Simulation logs
```

### Documentation

```
docs/
├── lab_report_results_7.1_7.2.pdf    # Logic effort calculations
├── lab_submission_full.pdf           # Complete lab report with layouts
└── gpdk045_drc.pdf                   # Design rules reference
```

### Analysis Tools

```
scripts/
└── power_analysis.py             # Python visualization tool
```

---

## Design Flow

```
1. Schematic Entry (Virtuoso Schematic Editor)
   ↓
2. Symbol Creation
   ↓
3. Layout Design (Virtuoso Layout XL)
   ↓
4. DRC Verification (Assura/Calibre)
   ↓
5. LVS Verification (Layout vs Schematic)
   ↓
6. Parasitic Extraction
   ↓
7. Post-Layout Simulation (HSPICE)
   ↓
8. Power & Timing Analysis
```

---

## Tools & Technologies

| Category | Tools |
|----------|-------|
| **Schematic** | Cadence Virtuoso Schematic Editor |
| **Layout** | Cadence Virtuoso Layout XL |
| **Verification** | Assura DRC/LVS |
| **Simulation** | Synopsys HSPICE |
| **PDK** | GPDK 45nm (Generic Process Design Kit) |
| **Analysis** | Python, Matplotlib, NumPy |

---

## Running the Simulations

### Prerequisites
- HSPICE or compatible SPICE simulator
- GPDK045 models (45nm process)
- Python 3.x with matplotlib, numpy, scipy

### Execute Power Analysis

```bash
# Run HSPICE simulations
hspice simulations/spice/step5_1GHz.sp -o simulations/results/

# Generate power-frequency plot
python3 scripts/power_analysis.py
```

### View Waveforms

```bash
# Open in waveform viewer (CosmosScope, WaveView, etc.)
waveview simulations/results/step3_gjayakishan.tr0
```

---

## Key Learning Outcomes

✅ **Logic Effort Theory**: Quantitative multi-stage driver optimization  
✅ **CMOS Layout**: Full-custom design, DRC/LVS methodology  
✅ **Power Analysis**: Linear P-f relationship in digital CMOS  
✅ **Timing Constraints**: Hold/setup time debugging  
✅ **Parasitic Effects**: Impact of layout on performance  

---

## Results Summary

### Optimization Success
- **6.3× delay improvement** through proper staging
- Equal electrical effort per stage (f = 4.78)
- Validated through post-layout SPICE

### Power Characterization  
- Successfully modeled dynamic and static components
- Identified frequency threshold where leakage matters
- Linear scaling confirms switching activity dominance

### Verification Success
- ✅ DRC clean (no design rule violations)
- ✅ LVS match (layout = schematic)
- ✅ Functional test (all truth table rows exercised)
- ✅ Timing constraints met after hold-time fix

---

## Author

**Gautam Jayakishan**  
Computer Engineering, UMass Amherst  
Expected Graduation: May 2026  
[LinkedIn](https://www.linkedin.com/in/gautam-jayakishan-350a8b1b8/)

### Skills Demonstrated
- Digital IC Design
- CMOS Layout & Verification  
- SPICE Circuit Simulation
- Logic Effort Optimization
- Power/Timing Analysis
- Python Automation

---

## Acknowledgments

ECE 558: Digital Integrated Circuits  
University of Massachusetts Amherst  
Fall 2025
