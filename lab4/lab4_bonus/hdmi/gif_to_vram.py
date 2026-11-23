from PIL import Image
import os

# ===== USER SETTINGS =========================================

IMG_DIR = "image"
WIDTH   = 128   
HEIGHT  = 96
THRESH  = 127

VALID_EXT = (".png", ".jpg", ".jpeg", ".bmp", ".gif")
OUT_FILE  = "vram16k.v"   # Output Verilog file

# =============================================================


def generate_plane_inits(img, plane, width, height, threshold=127):
    """Build INIT_00..INIT_3F for one color plane (R/G/B)."""
    data = list(img.getdata())  # [(R,G,B), ...]
    chan_index = {"R": 0, "G": 1, "B": 2}[plane]

    # Convert pixels to 1-bit values
    bits = []
    for (r, g, b) in data:
        v = (r, g, b)[chan_index]
        bits.append(1 if v > threshold else 0)

    # RAMB18E1 capacity (16K bits)
    TOTAL_BITS = 16 * 1024
    if len(bits) > TOTAL_BITS:
        raise ValueError(f"Image {width}x{height} has {len(bits)} bits > {TOTAL_BITS}.")

    # Pad unused memory with zeros
    bits += [0] * (TOTAL_BITS - len(bits))

    # Pack into 64 blocks of 256 bits
    lines = []
    for blk in range(64):
        block_bits = bits[blk * 256:(blk + 1) * 256]
        val = 0
        for j, b in enumerate(block_bits):
            if b:
                val |= (1 << j)
        hexval = f"{val:064X}"
        comma = "," if blk != 63 else ""
        lines.append(f"        .INIT_{blk:02X}(256'h{hexval}){comma}")

    return "\n".join(lines)


def main():
    # List images in folder
    files = sorted(
        f for f in os.listdir(IMG_DIR)
        if f.lower().endswith(VALID_EXT)
    )
    if not files:
        raise SystemExit(f"No image files found in '{IMG_DIR}'")

    # Bits needed for image select
    num_images = len(files)
    sel_bits = max(1, (num_images - 1).bit_length())

    resp = input(f"\n OVERWRITE {OUT_FILE}? [y/N]: ").strip().lower()
    if resp not in ("y", "yes"):
        raise SystemExit("Aborted by user — not overwriting file.")
    print(f"    writing imgages form: {IMG_DIR}")

    # Write Verilog to file
    with open(OUT_FILE, "w", encoding="utf-8") as out:
        def emit(s=""):
            out.write(s + "\n")

        # Module header
        emit("module vram16k (")
        emit("    input  wire        clk,")
        emit("    input  wire        rst,")
        emit("    // write port")
        emit("    input  wire        we,")
        emit("    input  wire [13:0] wr_addr,")
        emit("    input  wire [2:0]  din,")
        emit("    // read port")
        emit("    input  wire [13:0] rd_addr,")
        emit(f"    input  wire [{sel_bits-1}:0] img_sel,")
        emit("    output reg  [2:0]  rgb")
        emit(");")
        emit()

        # Signals per image
        for idx, fname in enumerate(files, start=1):
            emit(f"    // Image {idx}: {fname}")
            emit(f"    wire [15:0] doaR_{idx}, doaG_{idx}, doaB_{idx};")
            emit(f"    reg en_{idx};")
            emit()
        emit(f"    reg [{sel_bits}-1:0] img_sel_q;")
        emit()

        # BRAM instances per image
        for idx, fname in enumerate(files, start=1):
            path = os.path.join(IMG_DIR, fname)
            img = Image.open(path).convert("RGB").resize((WIDTH, HEIGHT), Image.NEAREST)

            init_r = generate_plane_inits(img, "R", WIDTH, HEIGHT, THRESH)
            init_g = generate_plane_inits(img, "G", WIDTH, HEIGHT, THRESH)
            init_b = generate_plane_inits(img, "B", WIDTH, HEIGHT, THRESH)

            emit(f"    // ===== Image {idx}: {fname} =====")

            # R plane
            emit("    // Red plane BRAM")
            emit("    RAMB18E1 #(")
            emit('        .RAM_MODE("TDP"),')
            emit("        .READ_WIDTH_A(1),")
            emit("        .WRITE_WIDTH_A(1),")
            emit("        .READ_WIDTH_B(1),")
            emit("        .WRITE_WIDTH_B(1),")
            emit("        .DOA_REG(0),")
            emit("        .DOB_REG(0),")
            emit('        .INIT_FILE("NONE"),')
            emit(init_r)
            emit(f"    ) vram_R{idx} (")
            emit("        // Port A: read")
            emit(f"        .DOADO         (doaR_{idx}),")
            emit("        .ADDRARDADDR   (rd_addr),")
            emit("        .CLKARDCLK     (clk),")
            emit("        .ENARDEN       (1'b1),")
            emit("        .REGCEAREGCE   (1'b1),")
            emit("        .RSTRAMARSTRAM (1'b0),")
            emit("        .RSTREGARSTREG (rst),")
            emit("        .WEA           (2'b00),")
            emit("        .DIADI         (16'b0),")
            emit("        .DIPADIP       (2'b0),")
            emit()
            emit("        // Port B: write")
            emit("        .ADDRBWRADDR (wr_addr),")
            emit("        .CLKBWRCLK   (clk),")
            emit("        .ENBWREN     (1'b1),")
            emit("        .REGCEB      (1'b0),")
            emit("        .WEBWE       ({4{we}}),")
            emit(f"        .DIBDI       ({{15'b0, din[2]}}),")
            emit("        .DIPBDIP     (2'b0)")
            emit("    );")
            emit()

            # G plane
            emit("    // Green plane BRAM")
            emit("    RAMB18E1 #(")
            emit('        .RAM_MODE("TDP"),')
            emit("        .READ_WIDTH_A(1),")
            emit("        .WRITE_WIDTH_A(1),")
            emit("        .READ_WIDTH_B(1),")
            emit("        .WRITE_WIDTH_B(1),")
            emit("        .DOA_REG(0),")
            emit("        .DOB_REG(0),")
            emit('        .INIT_FILE("NONE"),')
            emit(init_g)
            emit(f"    ) vram_G{idx} (")
            emit("        // Port A: read")
            emit(f"        .DOADO         (doaG_{idx}),")
            emit("        .ADDRARDADDR   (rd_addr),")
            emit("        .CLKARDCLK     (clk),")
            emit("        .ENARDEN       (1'b1),")
            emit("        .REGCEAREGCE   (1'b1),")
            emit("        .RSTRAMARSTRAM (1'b0),")
            emit("        .RSTREGARSTREG (rst),")
            emit("        .WEA           (2'b00),")
            emit("        .DIADI         (16'b0),")
            emit("        .DIPADIP       (2'b0),")
            emit()
            emit("        // Port B: write")
            emit("        .DOBDO    (),")
            emit("        .DOPBDOP  (),")
            emit("        .ADDRBWRADDR (wr_addr),")
            emit("        .CLKBWRCLK   (clk),")
            emit("        .ENBWREN     (1'b1),")
            emit("        .REGCEB      (1'b0),")
            emit("        .WEBWE       ({4{we}}),")
            emit(f"        .DIBDI       ({{15'b0, din[1]}}),")
            emit("        .DIPBDIP     (2'b0)")
            emit("    );")
            emit()

            # B plane
            emit("    // Blue plane BRAM")
            emit("    RAMB18E1 #(")
            emit('        .RAM_MODE("TDP"),')
            emit("        .READ_WIDTH_A(1),")
            emit("        .WRITE_WIDTH_A(1),")
            emit("        .READ_WIDTH_B(1),")
            emit("        .WRITE_WIDTH_B(1),")
            emit("        .DOA_REG(0),")
            emit("        .DOB_REG(0),")
            emit('        .INIT_FILE("NONE"),')
            emit(init_b)
            emit(f"    ) vram_B{idx} (")
            emit("        // Port A: read")
            emit(f"        .DOADO         (doaB_{idx}),")
            emit("        .ADDRARDADDR   (rd_addr),")
            emit("        .CLKARDCLK     (clk),")
            emit("        .ENARDEN       (1'b1),")
            emit("        .REGCEAREGCE   (1'b1),")
            emit("        .RSTRAMARSTRAM (1'b0),")
            emit("        .RSTREGARSTREG (rst),")
            emit("        .WEA           (2'b00),")
            emit("        .DIADI         (16'b0),")
            emit("        .DIPADIP       (2'b0),")
            emit()
            emit("        // Port B: write")
            emit("        .DOBDO    (),")
            emit("        .DOPBDOP  (),")
            emit("        .ADDRBWRADDR (wr_addr),")
            emit("        .CLKBWRCLK   (clk),")
            emit("        .ENBWREN     (1'b1),")
            emit("        .REGCEB      (1'b0),")
            emit("        .RSTRAMB     (1'b0),")
            emit("        .RSTREGB     (1'b0),")
            emit("        .WEBWE       ({4{we}}),")
            emit(f"        .DIBDI       ({{15'b0, din[0]}}),")
            emit("        .DIPBDIP     (2'b0)")
            emit("    );")
            emit()

        # Image select pipeline
        emit("    // Register selection")
        emit("    always @(posedge clk) img_sel_q <= img_sel;")
        emit()

        # Output mux
        emit("    // Select image output")
        emit("    always @(posedge clk) begin")
        emit("        case (img_sel_q)")
        for idx, _fname in enumerate(files, start=1):
            sel_val = idx - 1
            emit(f"            {sel_bits}'d{sel_val}: rgb = {{doaR_{idx}[0], doaG_{idx}[0], doaB_{idx}[0]}};")
        emit("            default: rgb = 3'b000;")
        emit("        endcase")
        emit("    end")
        emit()
        emit("endmodule")

    print(f"Generated Verilog file: {OUT_FILE}")


if __name__ == "__main__":
    main()
