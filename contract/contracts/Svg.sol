// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "solady/src/utils/LibString.sol";

contract Svg {
    string internal constant SVG_HEADER =
		"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' version='1.2' viewBox='0 0 20 20' shape-rendering='crispEdges' width='512px' height='512px'>";
	string internal constant SVG_FOOTER = "</svg>";

    string internal constant WHITE = "FFFFFF";
	string internal constant BLACK = "000000";
    string internal constant RED = "FF0000";
    string internal constant GREEN = "00FF00";
    string internal constant G1 = "111111";
    string internal constant G2 = "444444";
    string internal constant G3 = "888888";


    // id -> array[] //layers
    //          -> array[] /layer 1
    //                 -> 0 - 256 (bigN)
    //                 -> 256 - 5132 (bigN)
    //          -> array[] /layer 2
    //                 -> 0 - 256 (bigN)
    //                 -> 0 - 256 (bigN)
    //                 -> 256 - 5132 (bigN)
    mapping(uint256 => uint256[2][2]) tokenLayers;


    // function draw2() view public returns (string memory) {
    //     return string.concat("<svg xmlns='http://www.w3.org/2000/svg' version='1.2' viewBox='0 0 20 20' shape-rendering='crispEdges' width='512px' height='512px'><rect x='0' y='0' width='1' height='1' fill='#000000'/><rect x='1' y='0' width='1' height='1' fill='#000000'/><rect x='2' y='0' width='1' height='1' fill='#000000'/><rect x='3' y='0' width='1' height='1' fill='#000000'/><rect x='4' y='0' width='1' height='1' fill='#000000'/><rect x='5' y='0' width='1' height='1' fill='#000000'/><rect x='6' y='0' width='1' height='1' fill='#000000'/><rect x='7' y='0' width='1' height='1' fill='#000000'/><rect x='8' y='0' width='1' height='1' fill='#000000'/><rect x='9' y='0' width='1' height='1' fill='#000000'/><rect x='10' y='0' width='1' height='1' fill='#000000'/><rect x='11' y='0' width='1' height='1' fill='#000000'/><rect x='12' y='0' width='1' height='1' fill='#000000'/><rect x='13' y='0' width='1' height='1' fill='#000000'/><rect x='14' y='0' width='1' height='1' fill='#000000'/><rect x='15' y='0' width='1' height='1' fill='#000000'/><rect x='0' y='1' width='1' height='1' fill='#000000'/><rect x='1' y='1' width='1' height='1' fill='#000000'/><rect x='2' y='1' width='1' height='1' fill='#000000'/><rect x='3' y='1' width='1' height='1' fill='#000000'/><rect x='4' y='1' width='1' height='1' fill='#000000'/><rect x='5' y='1' width='1' height='1' fill='#000000'/><rect x='6' y='1' width='1' height='1' fill='#000000'/><rect x='7' y='1' width='1' height='1' fill='#000000'/><rect x='8' y='1' width='1' height='1' fill='#000000'/><rect x='9' y='1' width='1' height='1' fill='#000000'/><rect x='10' y='1' width='1' height='1' fill='#000000'/><rect x='11' y='1' width='1' height='1' fill='#000000'/><rect x='12' y='1' width='1' height='1' fill='#000000'/><rect x='13' y='1' width='1' height='1' fill='#000000'/><rect x='14' y='1' width='1' height='1' fill='#000000'/><rect x='15' y='1' width='1' height='1' fill='#000000'/><rect x='0' y='2' width='1' height='1' fill='#000000'/><rect x='1' y='2' width='1' height='1' fill='#000000'/><rect x='2' y='2' width='1' height='1' fill='#000000'/><rect x='3' y='2' width='1' height='1' fill='#000000'/><rect x='4' y='2' width='1' height='1' fill='#000000'/><rect x='5' y='2' width='1' height='1' fill='#000000'/><rect x='6' y='2' width='1' height='1' fill='#000000'/><rect x='7' y='2' width='1' height='1' fill='#000000'/><rect x='8' y='2' width='1' height='1' fill='#000000'/><rect x='9' y='2' width='1' height='1' fill='#000000'/><rect x='10' y='2' width='1' height='1' fill='#000000'/><rect x='11' y='2' width='1' height='1' fill='#000000'/><rect x='12' y='2' width='1' height='1' fill='#000000'/><rect x='13' y='2' width='1' height='1' fill='#000000'/><rect x='14' y='2' width='1' height='1' fill='#000000'/><rect x='15' y='2' width='1' height='1' fill='#000000'/><rect x='0' y='3' width='1' height='1' fill='#000000'/><rect x='1' y='3' width='1' height='1' fill='#000000'/><rect x='2' y='3' width='1' height='1' fill='#000000'/><rect x='3' y='3' width='1' height='1' fill='#000000'/><rect x='4' y='3' width='1' height='1' fill='#000000'/><rect x='5' y='3' width='1' height='1' fill='#000000'/><rect x='6' y='3' width='1' height='1' fill='#000000'/><rect x='7' y='3' width='1' height='1' fill='#000000'/><rect x='8' y='3' width='1' height='1' fill='#000000'/><rect x='9' y='3' width='1' height='1' fill='#000000'/><rect x='10' y='3' width='1' height='1' fill='#000000'/><rect x='11' y='3' width='1' height='1' fill='#000000'/><rect x='12' y='3' width='1' height='1' fill='#000000'/><rect x='13' y='3' width='1' height='1' fill='#000000'/><rect x='14' y='3' width='1' height='1' fill='#000000'/><rect x='15' y='3' width='1' height='1' fill='#000000'/><rect x='0' y='4' width='1' height='1' fill='#000000'/><rect x='1' y='4' width='1' height='1' fill='#000000'/><rect x='2' y='4' width='1' height='1' fill='#000000'/><rect x='3' y='4' width='1' height='1' fill='#000000'/><rect x='4' y='4' width='1' height='1' fill='#000000'/><rect x='5' y='4' width='1' height='1' fill='#000000'/><rect x='6' y='4' width='1' height='1' fill='#000000'/><rect x='7' y='4' width='1' height='1' fill='#000000'/><rect x='8' y='4' width='1' height='1' fill='#000000'/><rect x='9' y='4' width='1' height='1' fill='#000000'/><rect x='10' y='4' width='1' height='1' fill='#000000'/><rect x='11' y='4' width='1' height='1' fill='#000000'/><rect x='12' y='4' width='1' height='1' fill='#000000'/><rect x='13' y='4' width='1' height='1' fill='#000000'/><rect x='14' y='4' width='1' height='1' fill='#000000'/><rect x='15' y='4' width='1' height='1' fill='#000000'/><rect x='0' y='5' width='1' height='1' fill='#000000'/><rect x='1' y='5' width='1' height='1' fill='#000000'/><rect x='2' y='5' width='1' height='1' fill='#000000'/><rect x='3' y='5' width='1' height='1' fill='#000000'/><rect x='4' y='5' width='1' height='1' fill='#000000'/><rect x='5' y='5' width='1' height='1' fill='#000000'/><rect x='6' y='5' width='1' height='1' fill='#000000'/><rect x='7' y='5' width='1' height='1' fill='#000000'/><rect x='8' y='5' width='1' height='1' fill='#000000'/><rect x='9' y='5' width='1' height='1' fill='#000000'/><rect x='10' y='5' width='1' height='1' fill='#000000'/><rect x='11' y='5' width='1' height='1' fill='#000000'/><rect x='12' y='5' width='1' height='1' fill='#000000'/><rect x='13' y='5' width='1' height='1' fill='#000000'/><rect x='14' y='5' width='1' height='1' fill='#000000'/><rect x='15' y='5' width='1' height='1' fill='#000000'/><rect x='0' y='6' width='1' height='1' fill='#000000'/><rect x='1' y='6' width='1' height='1' fill='#000000'/><rect x='2' y='6' width='1' height='1' fill='#000000'/><rect x='3' y='6' width='1' height='1' fill='#000000'/><rect x='4' y='6' width='1' height='1' fill='#000000'/><rect x='5' y='6' width='1' height='1' fill='#000000'/><rect x='6' y='6' width='1' height='1' fill='#000000'/><rect x='7' y='6' width='1' height='1' fill='#000000'/><rect x='8' y='6' width='1' height='1' fill='#000000'/><rect x='9' y='6' width='1' height='1' fill='#000000'/><rect x='10' y='6' width='1' height='1' fill='#000000'/><rect x='11' y='6' width='1' height='1' fill='#000000'/><rect x='12' y='6' width='1' height='1' fill='#000000'/><rect x='13' y='6' width='1' height='1' fill='#000000'/><rect x='14' y='6' width='1' height='1' fill='#000000'/><rect x='15' y='6' width='1' height='1' fill='#000000'/><rect x='0' y='7' width='1' height='1' fill='#000000'/><rect x='1' y='7' width='1' height='1' fill='#000000'/><rect x='2' y='7' width='1' height='1' fill='#000000'/><rect x='3' y='7' width='1' height='1' fill='#000000'/><rect x='4' y='7' width='1' height='1' fill='#000000'/><rect x='5' y='7' width='1' height='1' fill='#000000'/><rect x='6' y='7' width='1' height='1' fill='#000000'/><rect x='7' y='7' width='1' height='1' fill='#000000'/><rect x='8' y='7' width='1' height='1' fill='#000000'/><rect x='9' y='7' width='1' height='1' fill='#000000'/><rect x='10' y='7' width='1' height='1' fill='#000000'/><rect x='11' y='7' width='1' height='1' fill='#000000'/><rect x='12' y='7' width='1' height='1' fill='#000000'/><rect x='13' y='7' width='1' height='1' fill='#000000'/><rect x='14' y='7' width='1' height='1' fill='#000000'/><rect x='15' y='7' width='1' height='1' fill='#000000'/><rect x='0' y='8' width='1' height='1' fill='#000000'/><rect x='1' y='8' width='1' height='1' fill='#000000'/><rect x='2' y='8' width='1' height='1' fill='#000000'/><rect x='3' y='8' width='1' height='1' fill='#000000'/><rect x='4' y='8' width='1' height='1' fill='#000000'/><rect x='5' y='8' width='1' height='1' fill='#000000'/><rect x='6' y='8' width='1' height='1' fill='#000000'/><rect x='7' y='8' width='1' height='1' fill='#000000'/><rect x='8' y='8' width='1' height='1' fill='#000000'/><rect x='9' y='8' width='1' height='1' fill='#000000'/><rect x='10' y='8' width='1' height='1' fill='#000000'/><rect x='11' y='8' width='1' height='1' fill='#000000'/><rect x='12' y='8' width='1' height='1' fill='#000000'/><rect x='13' y='8' width='1' height='1' fill='#000000'/><rect x='14' y='8' width='1' height='1' fill='#000000'/><rect x='15' y='8' width='1' height='1' fill='#000000'/><rect x='0' y='9' width='1' height='1' fill='#000000'/><rect x='1' y='9' width='1' height='1' fill='#000000'/><rect x='2' y='9' width='1' height='1' fill='#000000'/><rect x='3' y='9' width='1' height='1' fill='#000000'/><rect x='4' y='9' width='1' height='1' fill='#000000'/><rect x='5' y='9' width='1' height='1' fill='#000000'/><rect x='6' y='9' width='1' height='1' fill='#000000'/><rect x='7' y='9' width='1' height='1' fill='#000000'/><rect x='8' y='9' width='1' height='1' fill='#000000'/><rect x='9' y='9' width='1' height='1' fill='#000000'/><rect x='10' y='9' width='1' height='1' fill='#000000'/><rect x='11' y='9' width='1' height='1' fill='#000000'/><rect x='12' y='9' width='1' height='1' fill='#000000'/><rect x='13' y='9' width='1' height='1' fill='#000000'/><rect x='14' y='9' width='1' height='1' fill='#000000'/><rect x='15' y='9' width='1' height='1' fill='#000000'/><rect x='0' y='10' width='1' height='1' fill='#000000'/><rect x='1' y='10' width='1' height='1' fill='#000000'/><rect x='2' y='10' width='1' height='1' fill='#000000'/><rect x='3' y='10' width='1' height='1' fill='#000000'/><rect x='4' y='10' width='1' height='1' fill='#000000'/><rect x='5' y='10' width='1' height='1' fill='#000000'/><rect x='6' y='10' width='1' height='1' fill='#000000'/><rect x='7' y='10' width='1' height='1' fill='#000000'/><rect x='8' y='10' width='1' height='1' fill='#000000'/><rect x='9' y='10' width='1' height='1' fill='#000000'/><rect x='10' y='10' width='1' height='1' fill='#000000'/><rect x='11' y='10' width='1' height='1' fill='#000000'/><rect x='12' y='10' width='1' height='1' fill='#000000'/><rect x='13' y='10' width='1' height='1' fill='#000000'/><rect x='14' y='10' width='1' height='1' fill='#000000'/><rect x='15' y='10' width='1' height='1' fill='#000000'/><rect x='0' y='11' width='1' height='1' fill='#000000'/><rect x='1' y='11' width='1' height='1' fill='#000000'/><rect x='2' y='11' width='1' height='1' fill='#000000'/><rect x='3' y='11' width='1' height='1' fill='#000000'/><rect x='4' y='11' width='1' height='1' fill='#000000'/><rect x='5' y='11' width='1' height='1' fill='#000000'/><rect x='6' y='11' width='1' height='1' fill='#000000'/><rect x='7' y='11' width='1' height='1' fill='#000000'/><rect x='8' y='11' width='1' height='1' fill='#000000'/><rect x='9' y='11' width='1' height='1' fill='#000000'/><rect x='10' y='11' width='1' height='1' fill='#000000'/><rect x='11' y='11' width='1' height='1' fill='#000000'/><rect x='12' y='11' width='1' height='1' fill='#000000'/><rect x='13' y='11' width='1' height='1' fill='#000000'/><rect x='14' y='11' width='1' height='1' fill='#000000'/><rect x='15' y='11' width='1' height='1' fill='#000000'/><rect x='0' y='12' width='1' height='1' fill='#000000'/><rect x='1' y='12' width='1' height='1' fill='#000000'/><rect x='2' y='12' width='1' height='1' fill='#000000'/><rect x='3' y='12' width='1' height='1' fill='#000000'/><rect x='4' y='12' width='1' height='1' fill='#000000'/><rect x='5' y='12' width='1' height='1' fill='#000000'/><rect x='6' y='12' width='1' height='1' fill='#000000'/><rect x='7' y='12' width='1' height='1' fill='#000000'/><rect x='8' y='12' width='1' height='1' fill='#000000'/><rect x='9' y='12' width='1' height='1' fill='#000000'/><rect x='10' y='12' width='1' height='1' fill='#000000'/><rect x='11' y='12' width='1' height='1' fill='#000000'/><rect x='12' y='12' width='1' height='1' fill='#000000'/><rect x='13' y='12' width='1' height='1' fill='#000000'/><rect x='14' y='12' width='1' height='1' fill='#000000'/><rect x='15' y='12' width='1' height='1' fill='#000000'/><rect x='0' y='13' width='1' height='1' fill='#000000'/><rect x='1' y='13' width='1' height='1' fill='#000000'/><rect x='2' y='13' width='1' height='1' fill='#000000'/><rect x='3' y='13' width='1' height='1' fill='#000000'/><rect x='4' y='13' width='1' height='1' fill='#000000'/><rect x='5' y='13' width='1' height='1' fill='#000000'/><rect x='6' y='13' width='1' height='1' fill='#000000'/><rect x='7' y='13' width='1' height='1' fill='#000000'/><rect x='8' y='13' width='1' height='1' fill='#000000'/><rect x='9' y='13' width='1' height='1' fill='#000000'/><rect x='10' y='13' width='1' height='1' fill='#000000'/><rect x='11' y='13' width='1' height='1' fill='#000000'/><rect x='12' y='13' width='1' height='1' fill='#000000'/><rect x='13' y='13' width='1' height='1' fill='#000000'/><rect x='14' y='13' width='1' height='1' fill='#000000'/><rect x='15' y='13' width='1' height='1' fill='#000000'/><rect x='0' y='14' width='1' height='1' fill='#000000'/><rect x='1' y='14' width='1' height='1' fill='#000000'/><rect x='2' y='14' width='1' height='1' fill='#000000'/><rect x='3' y='14' width='1' height='1' fill='#000000'/><rect x='4' y='14' width='1' height='1' fill='#000000'/><rect x='5' y='14' width='1' height='1' fill='#000000'/><rect x='6' y='14' width='1' height='1' fill='#000000'/><rect x='7' y='14' width='1' height='1' fill='#000000'/><rect x='8' y='14' width='1' height='1' fill='#000000'/><rect x='9' y='14' width='1' height='1' fill='#000000'/><rect x='10' y='14' width='1' height='1' fill='#000000'/><rect x='11' y='14' width='1' height='1' fill='#000000'/><rect x='12' y='14' width='1' height='1' fill='#000000'/><rect x='13' y='14' width='1' height='1' fill='#000000'/><rect x='14' y='14' width='1' height='1' fill='#000000'/><rect x='15' y='14' width='1' height='1' fill='#000000'/><rect x='0' y='15' width='1' height='1' fill='#000000'/><rect x='1' y='15' width='1' height='1' fill='#000000'/><rect x='2' y='15' width='1' height='1' fill='#000000'/><rect x='3' y='15' width='1' height='1' fill='#000000'/><rect x='4' y='15' width='1' height='1' fill='#000000'/><rect x='5' y='15' width='1' height='1' fill='#000000'/><rect x='6' y='15' width='1' height='1' fill='#000000'/><rect x='7' y='15' width='1' height='1' fill='#000000'/><rect x='8' y='15' width='1' height='1' fill='#000000'/><rect x='9' y='15' width='1' height='1' fill='#000000'/><rect x='10' y='15' width='1' height='1' fill='#000000'/><rect x='11' y='15' width='1' height='1' fill='#000000'/><rect x='12' y='15' width='1' height='1' fill='#000000'/><rect x='13' y='15' width='1' height='1' fill='#000000'/><rect x='14' y='15' width='1' height='1' fill='#000000'/><rect x='15' y='15' width='1' height='1' fill='#000000'/><rect x='0' y='16' width='1' height='1' fill='#000000'/><rect x='1' y='16' width='1' height='1' fill='#000000'/><rect x='2' y='16' width='1' height='1' fill='#000000'/><rect x='3' y='16' width='1' height='1' fill='#000000'/><rect x='4' y='16' width='1' height='1' fill='#000000'/><rect x='5' y='16' width='1' height='1' fill='#000000'/><rect x='6' y='16' width='1' height='1' fill='#000000'/><rect x='7' y='16' width='1' height='1' fill='#000000'/><rect x='8' y='16' width='1' height='1' fill='#000000'/><rect x='9' y='16' width='1' height='1' fill='#000000'/><rect x='10' y='16' width='1' height='1' fill='#000000'/><rect x='11' y='16' width='1' height='1' fill='#000000'/><rect x='12' y='16' width='1' height='1' fill='#000000'/><rect x='13' y='16' width='1' height='1' fill='#000000'/><rect x='14' y='16' width='1' height='1' fill='#000000'/><rect x='15' y='16' width='1' height='1' fill='#000000'/><rect x='0' y='17' width='1' height='1' fill='#000000'/></svg>");
    // }

    

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
            LibString.toString(_x),
            "' y='",
            LibString.toString(_y),
            "' width='1' height='1' fill='#",
            _color,
            "'/>"
        );
	}


        function drawRow(
		string memory _svg,
		string[1024] memory _colors
	) internal pure returns (string memory) {
        string memory square = "<rect x='A' y='B' width='1' height='1' fill='#C'/>";

        string memory row = "<rect x='1' y='1' width='1' height='1' fill='#C1'/><rect x='2' y='1' width='1' height='1' fill='#C2'/><rect x='3' y='1' width='1' height='1' fill='#C3'/><rect x='4' y='1' width='1' height='1' fill='#C4'/><rect x='5' y='1' width='1' height='1' fill='#C5'/><rect x='6' y='1' width='1' height='1' fill='#C6'/><rect x='7' y='1' width='1' height='1' fill='#C7'/><rect x='8' y='1' width='1' height='1' fill='#C'/><rect x='9' y='1' width='1' height='1' fill='#C'/><rect x='10' y='1' width='1' height='1' fill='#C'/><rect x='11' y='1' width='1' height='1' fill='#C'/><rect x='12' y='1' width='1' height='1' fill='#C'/><rect x='13' y='1' width='1' height='1' fill='#C'/><rect x='14' y='1' width='1' height='1' fill='#C'/><rect x='15' y='1' width='1' height='1' fill='#C'/><rect x='16' y='1' width='1' height='1' fill='#C'/><rect x='17' y='1' width='1' height='1' fill='#C'/><rect x='18' y='1' width='1' height='1' fill='#C'/><rect x='19' y='1' width='1' height='1' fill='#C'/><rect x='20' y='1' width='1' height='1' fill='#C'/><rect x='21' y='1' width='1' height='1' fill='#C'/><rect x='22' y='1' width='1' height='1' fill='#C'/><rect x='23' y='1' width='1' height='1' fill='#C'/><rect x='24' y='1' width='1' height='1' fill='#C'/><rect x='25' y='1' width='1' height='1' fill='#C'/>";

        row = LibString.replace(row, 'C1', _colors[1]);
        row = LibString.replace(row, 'C2', _colors[1]);
        row = LibString.replace(row, 'C3', _colors[1]);
        row = LibString.replace(row, 'C4', _colors[1]);
        row = LibString.replace(row, 'C5', _colors[1]);
        row = LibString.replace(row, 'C6', _colors[1]);
        row = LibString.replace(row, 'C7', _colors[1]);
        
        return LibString.concat(_svg, row);
	}


    function store (uint256 tokenId, uint256[2] calldata layer1, uint256[2] calldata layer2) public {
        tokenLayers[tokenId][0] = layer1;
        tokenLayers[tokenId][1] = layer2;
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
        console.log(tokenId);
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
        bytes32 layer1 = bytes32(uint256(tokenLayers[tokenId][0][0]));
        console.logBytes32(layer1);

        bytes32 layer1P2 = bytes32(uint256(tokenLayers[tokenId][0][1]));
        console.logBytes32(layer1P2);


        bytes32 layer2 = bytes32(uint256(tokenLayers[tokenId][1][0]));
        console.logBytes32(layer2);

        bytes32 layer2P2 = bytes32(uint256(tokenLayers[tokenId][1][1]));
        console.logBytes32(layer2P2);

        string memory svg = SVG_HEADER;
        string[1024] memory colours;

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
        console.log('GAS:: ', gasleft());

        for (uint256 i; i < 32; i++) {
            for (uint256 b; b < bitMask.length; b++) {
                bit1 = (bitMask[b] | bytes1(uint8(layer1P2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
                bit2 = (bitMask[b] | bytes1(uint8(layer2P2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;

                if(bit1 == 0 && bit2 == 0) colours[255+(i*8)+b] = BLACK;
                if(bit1 == 1 && bit2 == 1) colours[255+(i*8)+b] = WHITE;
                if(bit1 == 0 && bit2 == 1) colours[255+(i*8)+b] = RED;
                if(bit1 == 1 && bit2 == 0) colours[255+(i*8)+b] = GREEN;
            }
        }
        



        uint256 height = 25;
        uint256 width = 16;
        for (uint256 r; r < height; r++) { 
            // 0
            svg = drawRow(svg, colours );
            // for (uint256 c; c < width; c++) { 
            //     uint256 num = (r*height) + c ;
            //     // console.log(num);
            //     // console.log(colours[num]);
            //     svg = draw(svg, c, r, colours[num] );
            //     console.log(num, ' GAS:: ', gasleft());
            // }
            console.log(r,' GAS:: ', gasleft());
        }
        return string.concat(svg, SVG_FOOTER);
    }

    // function twoLayer (uint256 tokenId) public view returns (string memory){
    //     bytes1[8] memory bitMask;
    //     bitMask[0] = (0x7F); // 01111111
    //     bitMask[1] = (0xBF); // 10111111
    //     bitMask[2] = (0xDF); // 11011111
    //     bitMask[3] = (0xEF); // 11101111
    //     bitMask[4] = (0xF7); // 11110111
    //     bitMask[5] = (0xFB); // 11111011
    //     bitMask[6] = (0xFD); // 11111101
    //     bitMask[7] = (0xFE); // 11111110
        
	// 	uint256 x;
	// 	uint256 y;
    //     bytes32 layer1 = bytes32(uint256(tokenLayers[tokenId][0]));
    //     bytes32 layer2 = bytes32(uint256(tokenLayers[tokenId][1]));
        
    //     string memory svg = SVG_HEADER;
    //     string[256] memory colours;

    //     uint8 bit1;
    //     uint8 bit2;

    //     for (uint256 i; i < 32; i++) {
    //         for (uint256 b; b < bitMask.length; b++) {
    //             bit1 = (bitMask[b] | bytes1(uint8(layer1[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
    //             bit2 = (bitMask[b] | bytes1(uint8(layer2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;

    //             if(bit1 == 0 && bit2 == 0) colours[(i*8)+b] = BLACK;
    //             if(bit1 == 1 && bit2 == 1) colours[(i*8)+b] = WHITE;
    //             if(bit1 == 0 && bit2 == 1) colours[(i*8)+b] = RED;
    //             if(bit1 == 1 && bit2 == 0) colours[(i*8)+b] = GREEN;
    //         }
    //     }

    //     for (uint256 i; i < 32; i++) {
    //         for (uint256 c; c < bitMask.length; c++) {
    //             svg = draw(svg, x + c, y, colours[ (i*8)+c]);
    //         }
    //     	x += 8;
	// 		if (x % 16 == 0) {
	// 			y++;
	// 			x = 0;
	// 		}
    //     }
    //     return string.concat(svg, SVG_FOOTER);
    // }
}