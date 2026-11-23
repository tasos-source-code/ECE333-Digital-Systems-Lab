The gif\_to\_vram.py Python script scans a folder of images and generates a Verilog module (vram16k.v) that stores each image in BRAM using Xilinx RAMB18E1 primitives.





&nbsp;	**FUNCTIONALITY**:

Output file: vram16k.v



Verilog module: vram16k



For every image in IMG\_DIR, it instantiates 3 BRAMs:

&nbsp;	Red plane BRAM

&nbsp;	Green plane BRAM

&nbsp;	Blue plane BRAM



Each BRAM is initialized with .INIT\_00….INIT\_3F (64 × 256-bit blocks = 16K bits).





&nbsp;	**NOTES**:

Each image is resized to 128×96 using nearest-neighbor.



Each color channel becomes 1 bit using a threshold:

&nbsp;	bit = 1 if channel value > THRESH, else 0







&nbsp;	**REQUIREMENTS**:

Python3



pillow library

&nbsp;	pip install pillow







&nbsp;	**USAGE**:

Place the desired images inside IMG\_DIR. 

&nbsp;	(use an online gif to image converter to extract the images from a gif)



Run the script



Confirm overwrite file. (CAUTION)





&nbsp;	**CONFIGURATION** (edit at top of script):

IMG\_DIR: folder containing images



WIDTH, HEIGHT: target resolution (default 128×96)



THRESH: threshold for 1-bit quantization (default 127)



OUT\_FILE: generated Verilog filename (default vram16k.v)



Supported formats: .png .jpg .jpeg .bmp .gif



