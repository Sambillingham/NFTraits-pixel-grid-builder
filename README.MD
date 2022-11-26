# Custon ON-Chain Renderer 

inputs 2d array representing layers of pixel data
Outputs a base64 encoded 48x48 pixel grid svg

# Generator - grid
- Draw artwork
- assigns bit value combination based on colour
- generate output (2d array) to be stored via contract

# Read Data and Assign Colours
- Data Is built on two layers of binary. 
- 2x 2304 bits into 9 arrays (256 length) each converted to a BigNumber 
- Individual bits are refrenced using a bitmap
- 2bit data allows for 4 potential outputs used as 4 colours (1 white/ 3x grayscale)

# Build SVG onto grid
- Loops over each row of the grid
- concatenates batches of 6 pixels into an strut 8 element strut representing a single row
- rows are packed into a strut of 8 rows
- final concatinations combines 6 8row block for a total of 48 rows (48x48)
 
Recursively adding each pixel is inefficient (so inefficeient it will exceed the max block size in gas execution). Concatination with increasing string length is non viable. This technique packs multiple items togehter to reduce recursive concaitnations. 

# Shoutout
Chainrunners, Blitmap, Pixilations, pxc256 – Big shoutout for prior work on gas efficient rendering. 