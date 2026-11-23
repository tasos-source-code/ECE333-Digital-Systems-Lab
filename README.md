# ECE333 – Digital Systems Lab

Lab projects for **ECE333 – Digital Systems Laboratory**, Department of Electrical
and Computer Engineering, University of Thessaly (Winter semester 2025–2026).

All designs are written in **Verilog** and target a Xilinx FPGA board using
**Vivado**. Each lab builds on the previous one, ending with a complete Pong game
on an HDMI display.

**Team:** Anastasios Papadopoulos · Nikolaos Dimitriou

| Lab | Project | Folder |
|-----|---------|--------|
| 1 | 7-Segment Display Driver | [`Lab1/`](Lab1) |
| 2 | UART Transmitter / Receiver | [`Lab2/`](Lab2) |
| 3 | HDMI Controller | [`Lab3/`](Lab3) |
| 4 | Pong Game | [`lab4/`](lab4) |

---

## Lab 1 – 7-Segment Display Driver

Drives the board's four 7-segment digits.

- **Part A** – 7-segment decoder (`1A.v`, `1B.v`).
- **Part B** – Four-digit driver with time-multiplexed anode control (`4dLedDriver.v`).
- **Parts C/D** – Scrolling message display, advanced by a debounced, synchronized
  button (`4dLedDriver_btn.v`) or automatically by a timer (`4dLedDriver_tmr.v`).
- Supporting modules: synchronizer, debouncers, message counter, XDC constraints and
  testbenches.

## Lab 2 – UART (Universal Asynchronous Receiver Transmitter)

A serial communication system built in stages.

- **Part A** – Baud rate controller with selectable baud rates (`partA/`).
- **Part B** – UART transmitter with an FSM (`partB/`).
- **Part C** – UART receiver with an FSM and output control (`partC/`).
- **Part D** – Transmitter and receiver connected for serial data transfer (`partD/`).
- **Bonus** – Full UART system with message memory, shown on the 7-segment display
  from Lab 1 (`bonus/`).

Report: [`Lab2/Lab2_report.pdf`](Lab2/Lab2_report.pdf)

## Lab 3 – HDMI Controller

An HDMI display controller that shows an image stored in on-chip memory.

- **Part A** – Video RAM (VRAM) built on `RAMB18E1` block RAM, preloaded with a
  128×96 1-bit-per-channel image (`lab3A/`).
- **Part B** – Timing and color driver: an FSM that scans VRAM and produces
  hsync/vsync/active-draw signals (`lab3B/`).
- **Part C** – TMDS encoder and serializer (`lab3C/`).
- **Part D** – Complete HDMI controller with an MMCM pixel clock (`lab3D/`).
- **Extensions** – Adjustable color brightness (`lab3D_brightness/`) and GIF/video
  playback from multiple VRAM banks (`lab3D_gif/`).
- Python helpers (`image_to_vram.py`, `gif_to_vram.py`) turn images into BRAM
  `INIT` values. They need Python 3 with `pillow` and `numpy`.

Report: [`Lab3/lab3report.pdf`](Lab3/lab3report.pdf)

## Lab 4 – Pong

The arcade game Pong at 640×480 @ 60 Hz, built on the Lab 3 HDMI controller.

- **Part A** – Generating and checking the `new_frame` signal.
- **Part B** – Drawing block sprites (`block_sprite.v`, `lab4b/`).
- **Parts C/D** – Paddle and puck movement, collisions and game over (`pong.v`, `lab4c/`).
- **Bonus** (`lab4_bonus/`):
  - Background image
  - 1080p resolution
  - Two-player mode
  - Player scores on the 7-segment display

Report: [`lab4/Lab4_report.pdf`](lab4/Lab4_report.pdf)

---

## Building

1. Open the Vivado project (`.xpr`) where there is one, or create a new project
   and add the lab's `.v` sources and `.xdc` constraints file.
2. Run the testbenches (`*_tb.v`, `*testbench*.v`) in the Vivado simulator.
3. Run synthesis and implementation, generate the bitstream and program the board.

Vivado-generated folders (`*.runs`, `*.cache`, `*.sim`, …) are not tracked.

## License

Licensed under the [Apache License 2.0](LICENSE).
