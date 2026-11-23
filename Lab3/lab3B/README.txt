	The image_to_vram.py script converts an RGB image into three 1-bit bitplanes (R, G, B) and prints Xilinx .INIT_00….INIT_3F (256-bit) initialization values suitable for BRAM preloading.
	
	It also saves a preview image of the quantized result.


	STEPS:

Loads an image, converts to RGB, and resizes to 128×96 (nearest-neighbor)

Thresholds each channel to 1 bit (>= 128 → 1, else 0)

Pads/truncates each bitplane to 16384 bits (16K)

Packs bits into 64 × 256-bit INIT blocks (.INIT_00….INIT_3F)

Generates vram_preview.png for quick visual verification


	REQUIRMENTS:

python3

pillow, numpy libraries
	pip install pillow numpy


	USAGE:
change the input image to the desired

adjust parameters(if needed)

run the script
