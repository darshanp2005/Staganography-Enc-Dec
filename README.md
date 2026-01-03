# Steganography Encoder-Decoder

MATLAB toolbox for hiding text inside images and retrieving hidden payloads using basic least-significant-bit steganography.

## Features
- Encode arbitrary text into lossless images via encoding.m
- Decode hidden payloads with decoding.m
- Command-line runner in main.m to demo the workflow
- Works with standard grayscale and RGB formats (PNG, TIFF, BMP)

## Getting Started

### Prerequisites
- MATLAB 
- Test images placed under data/input and output placeholders under data/output

### Quick Start
1. Update paths inside main.m to point to your source image and payload text.
2. Run `main` in MATLAB.
3. Open the generated image under data/output to verify the embedded message.
4. Use decoding.m on the stego image to extract the message.

## Project Structure
- encoding.m: embeds text by modifying pixel LSBs
- decoding.m: reverses the embedding process
- main.m: sample pipeline tying both scripts together
- README.md: project overview (this file)

## Roadmap

[Diagram](flow.pdf)

