// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Storage {
    string internal constant SVG_HEADER =
		"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' version='1.2' viewBox='0 0 16 16' shape-rendering='crispEdges' width='512px' height='512px'>";
	string internal constant SVG_FOOTER = "</svg>";

    string internal constant WHITE = "FFFFFF";
	string internal constant BLACK = "000000";

    uint256 number;
    bytes1[8] bitMask;
    uint256[256] colours;

    function draw(
		string memory _svg,
		uint256 _x,
		uint256 _y,
		string memory _color
	) internal pure returns (string memory) {
		return
			string.concat(
				_svg,
				"<rect x='",
				Strings.toString(_x),
				"' y='",
				Strings.toString(_y),
				"' width='1' height='1' fill='#",
				_color,
				"'/>"
			);
	}

    function run ()  public {
        bitMask[0] = (0x7F); // 01111111
        bitMask[1] = (0xBF); // 10111111
        bitMask[2] = (0xDF); // 11011111
        bitMask[3] = (0xEF); // 11101111
        bitMask[4] = (0xF7); // 11110111
        bitMask[5] = (0xFB); // 11111011
        bitMask[6] = (0xFD); // 11111101
        bitMask[7] = (0xFE); // 11111110
        
        string memory color;
		uint256 x;
		uint256 y;
        bytes32 _bytes = bytes32(uint256(77194726158210796949047323339125271902179989777093709359638389338608753093290));
        
        console.logBytes32(_bytes);
        string memory svg = string.concat('', SVG_HEADER);

        for (uint256 i; i < 32; i++) {
            for (uint256 c; c < bitMask.length; c++) {
                color = (bitMask[c] | bytes1(uint8(0xAA)) == bytes1(uint8(0xFF))) ? BLACK : WHITE;
                // console.log(color);
                svg = draw(svg, x + c, y, color);
            }
        	x += 8;
			if (x % 16 == 0) {
				y++;
				x = 0;
			}
        }
        svg = string.concat(svg, SVG_FOOTER);
        console.log(svg);

        if ( bitMask[0] | bytes1(uint8(0xAA)) == bytes1(uint8(0xFF)) ) {
            // console.log("white");

                // | OR - result of OR is zero when both bits are zero - otherwise 1
                
                // Check first bit 
                // 01111111 - mask
                // 10101010 - test case
                // = 
                // 11111111 - black (all bits end up as 1 because only matching 0 would return 0)

                // 01111111 - mask
                // 00101010 - test case
                // = 
                // 01111111 - white (first bit is 0 because first bi in test case and mask are 0)

                // compare 11111111 against 11111111 = true = black
                // compare 01111111 against 11111111 = false = white
        }
    }
}