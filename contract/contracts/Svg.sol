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
    string internal constant GREEN = "00FF00";
    string internal constant G1 = "111111";
    string internal constant G2 = "444444";
    string internal constant G3 = "888888";

    mapping(uint256 => uint256[5]) tokenLayers;

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


    function store (uint256 tokenId, uint256[2] calldata layers) public {
        tokenLayers[tokenId] = layers;
    }
    
    function singleLayer (uint256 grid) public pure returns (string memory){
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
        bytes32 layer = bytes32(uint256(grid));
        
        string memory svg = SVG_HEADER;
        string[256] memory colours;

        for (uint256 i; i < 32; i++) {
            for (uint256 c; c < bitMask.length; c++) {
                colours[(i*8)+c] = (bitMask[c] | bytes1(uint8(layer[i])) == bytes1(uint8(0xFF))) ? BLACK : WHITE;
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

    function twoLayer (uint256 tokenId) public view returns (string memory){
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
        bytes32 layer1 = bytes32(uint256(tokenLayers[tokenId][0]));
        bytes32 layer2 = bytes32(uint256(tokenLayers[tokenId][1]));
        
        string memory svg = SVG_HEADER;
        string[256] memory colours;

        uint8 bit1;
        uint8 bit2;

        for (uint256 i; i < 32; i++) {
            for (uint256 b; b < bitMask.length; b++) {
                bit1 = (bitMask[b] | bytes1(uint8(layer1[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
                bit2 = (bitMask[b] | bytes1(uint8(layer2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;

                if(bit1 == 0 && bit2 == 0) colours[(i*8)+b] = BLACK;
                if(bit1 == 1 && bit2 == 1) colours[(i*8)+b] = WHITE;
                if(bit1 == 0 && bit2 == 1) colours[(i*8)+b] = RED;
                if(bit1 == 1 && bit2 == 0) colours[(i*8)+b] = GREEN;
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