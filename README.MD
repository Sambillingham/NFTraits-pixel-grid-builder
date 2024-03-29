# NFTraits Pixel Grid Builder 

# Generator - grid
- Draw artwork
- assigns bit value combination based on colour
- generate output array to be stored via contract

# Read Data and Assign Colours
- Data Is built on two layers of binary. 
- 8 arrays 256 bits each converted to an equivilent uint256/BigNumber 
- Individual bits are refrenced using a bitmasking 
- 4bit data allows for 4 potential outputs e.g - (1 white/ 3x grayscale)
- Colours are based on Rarity and applied with a css mix-blend-mode:overlay that covers the entire canvas

## Grid Colour Assignment
- 0) #C8C8C8 - layer 1 = 0, layer 2 = 0
- 1) #999999 - layer 1 = 1, layer 2 = 1
- 2) #666666 - layer 1 = 1, layer 2 = 0
- 3) #111111 - layer 1 = 0, layer 2 = 1

- split each array into 4 256 length chunks 
- convert 256 element array of 1/0 values to a uint256/BigNumber representation
- concatenate resulting array of 8 values into a single array 



# Build SVG onto grid
- Loops over each row of the grid
- concatenates batches of 4 pixels into an strut 8 element strut representing a single row
- rows are packed into a strut of 8 rows
- final concatinations combines 4 8row block for a total of 32 rows (32x32)
 
Recursively adding each pixel is inefficient (so inefficeient it will exceed the max block size in gas execution). Concatination with increasing string length is non viable. This technique packs multiple items togehter to reduce recursive concatenations. 


# Shoutout
Chainrunners, Blitmap, Pixilations, pxc256 – Big shoutout for prior work on gas efficient rendering. 