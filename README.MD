# NFTraits Pixel Renderer & Dashboard

# Generator - grid
- Draw artwork
- assigns bit value combination based on colour
- generate output array to be stored via contract

# Read Data and Assign Colours
- Data Is built on two layers of binary. 
- 18 arrays 256 bits each converted to an equivilent BigNumber 
- Individual bits are refrenced using a bitmap
- 2bit data allows for 4 potential outputs used a 4 colours (1 white/ 3x grayscale)

# Build SVG onto grid
- Loops over each row of the grid
- concatenates batches of 6 pixels into an strut 8 element strut representing a single row
- rows are packed into a strut of 8 rows
- final concatinations combines 6 8row block for a total of 48 rows (48x48)
 
Recursively adding each pixel is inefficient (so inefficeient it will exceed the max block size in gas execution). Concatination with increasing string length is non viable. This technique packs multiple items togehter to reduce recursive concatenations. 

# Asset Data Structure

```
0 - 250 -> unique elements
```

```
5 varients of each el -> 1250
[0] -> 0-4
[1] -> 5->9
[2] -> 9->14
```



# Shoutout
Chainrunners, Blitmap, Pixilations, pxc256 – Big shoutout for prior work on gas efficient rendering. 