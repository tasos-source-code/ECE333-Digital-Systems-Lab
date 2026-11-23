`timescale 1ns / 100ps

module tb_top_hdmi_image;

    // --- Inputs to Top Module ---
    reg clk;
    reg reset;

    // --- Outputs from Top Module (optional για waveform) ---
    wire [2:0] hdmi_tx_p;
    wire [2:0] hdmi_tx_n;
    wire       hdmi_clk_p;
    wire       hdmi_clk_n;

    integer f;   // file descriptor
    
    // --- Instantiation του TOP MODULE ---
    hdmi_controller uut (
        .clk        (clk), 
        .rst        (reset), 
        .intencity  (8'd255), // μέγιστη ένταση
        .hdmi_tx_p  (hdmi_tx_p), 
        .hdmi_tx_n  (hdmi_tx_n), 
        .hdmi_clk_p (hdmi_clk_p), 
        .hdmi_clk_n (hdmi_clk_n)
    );

    // --- Clock Generation (100MHz) ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk;    // 10ns period -> 100 MHz
    end

    // --- Main Control Process ---
    initial begin
        // 0. init
        reset = 1'b1;
        f     = 0;

        // 1. Reset System
        #100;
        reset = 1'b0;
        
        // 2. Άνοιγμα αρχείου
        f = $fopen("frame_data.txt", "w");   // ΠΡΟΣΩΡΙΝΑ ΧΩΡΙΣ ABSOLUTE PATH
        if (f == 0) begin
            $display("ERROR: Could not open file (f == 0) at time %0t", $time);
            $finish;
        end else begin
            $display("File opened OK, f = %0d, time = %0t", f, $time);
        end

        // 3. Περιμένουμε το MMCM να κλειδώσει (αν έχεις σήμα locked)
        // Αν έχεις π.χ. uut.locked:
        // wait (uut.locked);

        // Αν δεν έχεις locked, περίμενε απλώς μερικούς κύκλους pixel clock
        repeat (20) @(posedge uut.clk_pixel);

        // 4. Συγχρονισμός με VSYNC
        $display("Waiting for VSYNC...");

        // Αν VSYNC είναι active high:
        @(posedge uut.vsync);  // αρχή VSYNC
        @(negedge uut.vsync);  // τέλος VSYNC -> αρχή frame

        $display("Starting Frame Capture...");

        // 5. Τέλος capture στο *επόμενο* VSYNC (ένα πλήρες frame)
        @(posedge uut.vsync);  // VSYNC του επόμενου frame

        $display("Frame Capture Finished.");
        $fclose(f);
        $finish;
    end

    // --- Spy Process: Καταγραφή RGB ---
    always @(posedge uut.clk_pixel) begin
        // Γράφουμε στο αρχείο μόνο αν:
        // - το αρχείο είναι ανοιχτό (f != 0)
        // - είμαστε μέσα σε active draw
        if (f != 0 && uut.activedraw) begin
            $fwrite(f, "%d %d %d\n", 
                (uut.r ? 255 : 0), // Red
                (uut.g ? 255 : 0), // Green
                (uut.b ? 255 : 0)  // Blue
            );
        end
    end

endmodule
