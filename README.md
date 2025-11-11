# 🎶 Distributed Arithmetic Based FIR Filter: FPGA Implementation

> ⚠️ **Research Confidentiality Notice**  
> This project is part of an ongoing research work submitted for IEEE publication.  
> The source files, data, and implementation details are provided here for academic reference only.  
> Redistribution, modification, or reuse of the content is **not permitted** without explicit author consent.

---

## 📘 Overview
This project focuses on the design, development, and real-time FPGA implementation of a **Distributed Arithmetic (DA)-based Finite Impulse Response (FIR) filter** on the **Altera DE2-115 board**.  
The objective is to achieve **high-performance, low-latency, and resource-efficient real-time audio filtering** by replacing traditional multiplier-heavy architectures with **look-up table (LUT)-based arithmetic**.

Unlike conventional Multiply-and-Accumulate (MAC) architectures, this project leverages **Distributed Arithmetic**, a multiplier-less computation method that replaces multiplications with precomputed LUTs and shift-add operations.  
This results in a **77–80% reduction in logic element usage** while maintaining identical real-time filtering performance and audio fidelity.

---

## ⚙️ Features
- 🎵 **Real-Time Audio Filtering** — Live audio input via Line-In and output via Line-Out using the onboard Wolfson codec.  
- 🧮 **Distributed Arithmetic (DA) Architecture** — Multiplier-less FIR filter implemented using LUT-based bit-serial computation.  
- ⚡ **High Resource Efficiency** — 80% reduction in logic elements vs traditional MAC-based filters.  
- 🔄 **Dynamic Mode Switching** — Hardware switch toggles between filtered and unfiltered (bypass) audio.  
- 🔊 **16-Tap Bandpass Filter Design** — Optimized coefficient quantization and LUT encoding for 16-bit stereo audio.  
- 🧩 **Debounced Hardware Control** — 200 ms debounce logic ensures stable switching during real-time operation.  

---

## 🧠 System Architecture

### 🏗️ Audio Signal Flow

Analog Input (Line-In)
↓
Audio ADC (Wolfson WM8731)
↓
DA-Based FIR Filter (bpf_da.v)
↓
Audio DAC (Wolfson WM8731)
↓
Analog Output (Line-Out / Headphones)

---

### 🔍 Core HDL Modules
| Module | Description |
|--------|--------------|
| `audioinit.v` | Initializes the Wolfson codec via I2C |
| `i2c_controller.v` | Manages configuration and communication |
| `audioadc.v` | Captures and digitizes analog audio input |
| `audiodac.v` | Converts processed audio back to analog |
| `bpf_da.v` | Implements the DA-based FIR filter core |
| `audiofilter.v` | Manages filter enable/disable logic |
| `debouncer.v` | Ensures stable hardware switching |
| `sevenseg.v` | Displays current filter mode on 7-seg display |

---

## 📊 Performance Comparison

| Metric | MAC-Based | DA-Based | Improvement |
|--------|------------|-----------|--------------|
| Logic Elements (LEs) | 3950 (3%) | 819 (<1%) | **≈80% reduction** |
| Registers | 528 | 272 | **≈49% reduction** |
| 2-Input LUTs | 941 | 31 | **≈97% reduction** |
| 3-Input LUTs | 2050 | 338 | **≈84% reduction** |
| 4-Input LUTs | 942 | 256 | **≈73% reduction** |
| Compilation Time | 33s | 24s | **27% faster** |

✅ The DA-based design achieves the same real-time audio quality and responsiveness while drastically reducing resource usage and synthesis time.

---

## 🧩 Design Workflow

1. **Coefficient Quantization** — Floating-point coefficients converted to fixed-point for FPGA compatibility.  
2. **LUT Generation** — Precomputed binary-weighted sums of coefficients stored in a compact lookup table.  
3. **Bit-Serial Processing** — Input samples processed bit-by-bit using shift and accumulate logic.  
4. **Integration with Codec Chain** — Real-time processing validated via Wolfson ADC/DAC path.  
5. **Interactive Testing** — Switch-controlled filter toggling enables immediate comparison between raw and filtered signals.

---

## 🎧 Real-Time Testing & Observations
- Audio input supplied via 3.5mm Line-In (music/audio source).  
- Output monitored using headphones through Line-Out port.  
- Clear difference observed between filtered and unfiltered modes.  
- Band-pass filtering emphasized mid-frequency vocals while attenuating bass and treble components.  
- No distortion or latency observed during playback.  

---

## 💡 Results Summary
- ✅ Real-time audio filtering verified successfully.  
- ✅ Stable operation achieved across all clock domains (timing closure met).  
- ✅ 80% reduction in hardware resource utilization.  
- ✅ Maintained high audio fidelity and smooth playback.  

---

## 🧰 Tools & Technologies
- **Hardware:** Terasic DE2-115 FPGA  
- **Codec:** Wolfson WM8731 (Line-In / Line-Out)  
- **Language:** Verilog HDL / SystemVerilog  
- **Software:** Intel Quartus Prime 18.0 Lite  
- **Clock:** 50 MHz FPGA clock, 12.288 MHz audio sampling  
- **Design Type:** Bit-serial Distributed Arithmetic FIR filter  

---

## 🚀 Future Enhancements
- 🔄 Dynamic coefficient reloading for adaptive filtering  
- 🎚️ GUI-based control for real-time filter tuning  
- 🔊 Stereo and multi-band FIR filter extension  
- 💻 Integration with MATLAB for automated coefficient generation  
- 🧠 Adaptive DA architecture for intelligent signal processing  

---

## 👨‍💻 Author
**Aravinthvasan S**  
B.Tech – Electronics & Communication Engineering (Cyber Physical Systems)  
SASTRA Deemed University  

🔗 [GitHub Profile](https://github.com/av1429)

---

## ⚠️ Intellectual Property Notice
This repository and all associated content are part of a **research project submitted for IEEE publication**.  
Unauthorized reproduction, redistribution, or modification of the source code or results is **strictly prohibited**.  
For academic references or collaborations, please contact the author directly.

---

## 🏷️ Keywords
`FPGA` · `Distributed Arithmetic` · `FIR Filter` · `Real-Time Audio Processing` · `Verilog HDL` · `DA Architecture` · `Resource Optimization` · `Signal Processing` · `DE2-115 FPGA`
