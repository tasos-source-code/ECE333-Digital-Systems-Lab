from PIL import Image
import os

# Βάλε εδώ το μονοπάτι για το txt που έβγαλε το Vivado
# Αν το python script είναι στον ίδιο φάκελο με το txt, άσε το σκέτο όνομα.
FILENAME = "frame_data.txt"
WIDTH = 640  # Η ανάλυση που έχεις ορίσει
HEIGHT = 480

def create_image():
    if not os.path.exists(FILENAME):
        print(f"Error: {FILENAME} not found!")
        return

    print("Reading data...")
    pixels = []
    
    with open(FILENAME, 'r') as f:
        for line in f:
            parts = line.strip().split()
            if len(parts) == 3:
                r, g, b = int(parts[0]), int(parts[1]), int(parts[2])
                pixels.append((r, g, b))

    # Έλεγχος αν τα pixels ταιριάζουν με την ανάλυση
    expected_pixels = WIDTH * HEIGHT
    if len(pixels) < expected_pixels:
        print(f"Warning: Not enough pixels! Got {len(pixels)}, expected {expected_pixels}")
        # Συμπλήρωσε με μαύρο αν λείπουν (για να μη κρασάρει)
        pixels += [(0,0,0)] * (expected_pixels - len(pixels))
    elif len(pixels) > expected_pixels:
        print(f"Warning: Too many pixels! Got {len(pixels)}, cropping to {expected_pixels}")
        pixels = pixels[:expected_pixels]

    print("Creating image...")
    img = Image.new('RGB', (WIDTH, HEIGHT))
    
    corrected = []
    for y in range(HEIGHT):
        corrected.extend(pixels[y*WIDTH:(y+1)*WIDTH][::-1])
    img.putdata(corrected)
    img.save("vivado_output.png")
    print("Success! Saved as vivado_output.png")
    img.show()

if __name__ == "__main__":
    create_image()