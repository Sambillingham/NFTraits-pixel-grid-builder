// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Svg {
    string internal constant SVG_HEADER =
		"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' version='1.2' viewBox='0 0 16 16' shape-rendering='crispEdges' width='512px' height='512px'>";
	string internal constant SVG_FOOTER = "</svg>";

    string internal constant WHITE = "FFFFFF";
	string internal constant BLACK = "000000";
    string internal constant RED = "FF0000";

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

    function run (uint256 grid) public view returns (string memory){
        bytes1[8] memory bitMask;
        bitMask[0] = (0x7F); // 01111111
        bitMask[1] = (0xBF); // 10111111
        bitMask[2] = (0xDF); // 11011111
        bitMask[3] = (0xEF); // 11101111
        bitMask[4] = (0xF7); // 11110111
        bitMask[5] = (0xFB); // 11111011
        bitMask[6] = (0xFD); // 11111101
        bitMask[7] = (0xFE); // 11111110
        
		uint256 x;
		uint256 y;
        bytes32 _bytes = bytes32(uint256(grid));
        
        string memory svg = SVG_HEADER;
        string[256] memory colours;

        for (uint256 i; i < 32; i++) {
            for (uint256 c; c < bitMask.length; c++) {
                colours[(i*8)+c] = (bitMask[c] | bytes1(uint8(_bytes[i])) == bytes1(uint8(0xFF))) ? BLACK : WHITE;
            }
        }

        for (uint256 i; i < 32; i++) {
            for (uint256 c; c < bitMask.length; c++) {
                svg = draw(svg, x + c, y, colours[ (i*8)+c]);
            }
        	x += 8;
			if (x % 16 == 0) {
				y++;
				x = 0;
			}
        }
        return string.concat(svg, SVG_FOOTER);
    }

    function run2 (uint256 grid, uint256 grid2) public view returns (string memory){
        bytes1[8] memory bitMask;
        bitMask[0] = (0x7F); // 01111111
        bitMask[1] = (0xBF); // 10111111
        bitMask[2] = (0xDF); // 11011111
        bitMask[3] = (0xEF); // 11101111
        bitMask[4] = (0xF7); // 11110111
        bitMask[5] = (0xFB); // 11111011
        bitMask[6] = (0xFD); // 11111101
        bitMask[7] = (0xFE); // 11111110
        
		uint256 x;
		uint256 y;
        bytes32 _bytes = bytes32(uint256(grid));
        bytes32 _bytes2 = bytes32(uint256(grid2));
        
        string memory svg = SVG_HEADER;
        string[256] memory colours;

        for (uint256 i; i < 32; i++) {
            for (uint256 c; c < bitMask.length; c++) {
                colours[(i*8)+c] = (bitMask[c] | bytes1(uint8(_bytes[i])) == bytes1(uint8(0xFF))) ? BLACK : WHITE;
                if (bitMask[c] | bytes1(uint8(_bytes2[i])) == bytes1(uint8(0xFF))) {
                    colours[(i*8)+c] = RED;
                }
            }
        }

        for (uint256 i; i < 32; i++) {
            for (uint256 c; c < bitMask.length; c++) {
                svg = draw(svg, x + c, y, colours[ (i*8)+c]);
            }
        	x += 8;
			if (x % 16 == 0) {
				y++;
				x = 0;
			}
        }
        return string.concat(svg, SVG_FOOTER);
    }
}