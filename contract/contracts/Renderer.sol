// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";

contract Renderer {
    struct SVGRowBuffer {
        string one; // 1px-4px
        string two; // 4px -> 8px
        string three; // 8px -> 12px
        string four; // 12px -> 16px
        string five;  // 16px -> 20px
        string six; // 20px -> 24px
        string seven; // 24px -> 28px
        string eight; // 28px -> 32px
        string nine; 
        string ten; 
        string eleven; 
        string twelve; 
    }

    struct SVGCursor {
        uint16 x;
        uint16 y;
        // string color1;
        // string color2;
        // string color3;
        // string color4;
    }

    string WHITE64 = "ZmZm";
    string BLACK64 = "MDAw";
    string RED64 = "ZmYwMDAw";
    string GREEN64 = "MDBmZjAw";
    string BLUE64 = "MDAwMGZm";
    constructor() {}



    // id -> array[] //layers
    //          -> array[] /layer 1
    //                 -> 0 - 256 (bigN)
    //                 -> 256 - 5132 (bigN)
    //          -> array[] /layer 2
    //                 -> 0 - 256 (bigN)
    //                 -> 0 - 256 (bigN)
    //                 -> 256 - 5132 (bigN)
    
    mapping(uint256 => uint256[9][2]) tokenLayers;


    function store (uint256 tokenId, uint256[9] calldata layer1, uint256[9] calldata layer2) public {
        tokenLayers[tokenId][0] = layer1;
        tokenLayers[tokenId][1] = layer2;
    }


    function tokenSVG(uint256 tokenId) public view returns (string memory) {
        string[6] memory buffer = tokenSvgDataOf(tokenId);

        return
            string(
                abi.encodePacked(
                    "PHN2ZyB2ZXJzaW9uPScxLjEnIHZpZXdCb3g9JzAgMCA0ODAgNDgwJyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHNoYXBlLXJlbmRlcmluZz0nY3Jpc3BFZGdlcyc+",
                    buffer[0],
                    buffer[1],
                    buffer[2],
                    buffer[3],
                    buffer[4], // 
                    buffer[5], // 
                    "PHN0eWxlPnJlY3R7d2lkdGg6MTBweDtoZWlnaHQ6MTBweDt9PC9zdHlsZT48L3N2Zz4"
                )
            );
    }


    function tokenSvgDataOf(uint256 tokenId) private view returns (string[6] memory) {
        SVGCursor memory cursor;

        SVGRowBuffer memory cursorRow;

        string[8] memory bufferOfRows;
        uint8 indexIntoBufferOfRows;

        string[6] memory blockOfEightRows;
        uint8 indexIntoblockOfEightRows;

        // base64-encoded svg coordinates from 010 to 470
        string[48] memory coordinateLookup = [
            "MDAw", "MDEw", "MDIw", "MDMw", "MDQw", "MDUw", "MDYw", "MDcw", "MDgw", "MDkw", "MTAw", "MTEw", "MTIw", "MTMw", "MTQw", "MTUw", "MTYw", "MTcw", "MTgw", "MTkw", "MjAw", "MjEw", "MjIw", "MjMw", "MjQw", "MjUw", "MjYw", "Mjcw", "Mjgw", "Mjkw", "MzAw", "MzEw", "MzIw", "MzMw", "MzQw", "MzUw", "MzYw", "Mzcw", "Mzgw", "Mzkw", "NDAw", "NDEw", "NDIw", "NDMw", "NDQw", "NDUw", "NDYw", "NDcw"
        ];


        string[2304] memory colours  = twoLayer(tokenId);

        for (uint256 row = 0; row < 48; row++) {
            
            cursorRow.one = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.two = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.three = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.four = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.five = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.six = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.seven = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.eight = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.nine = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.ten = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.eleven = fourPixels(coordinateLookup, cursor, colours);
            cursor.x += 4;
            cursorRow.twelve = fourPixels(coordinateLookup, cursor, colours);


            // string memory p1 = string.concat(
            //         cursorRow.one,
            //         cursorRow.two,
            //         cursorRow.three,
            //         cursorRow.four,
            //         cursorRow.five,
            //         cursorRow.six
            // );

            // string memory p2 = string.concat(
            //         cursorRow.seven,
            //         cursorRow.eight,
            //         cursorRow.nine,
            //         cursorRow.ten,
            //         cursorRow.eleven,
            //         cursorRow.twelve
            // );

            bufferOfRows[indexIntoBufferOfRows++] = string.concat(
                string.concat(
                    cursorRow.one,
                    cursorRow.two,
                    cursorRow.three,
                    cursorRow.four,
                    cursorRow.five,
                    cursorRow.six
                ),
                string.concat(
                    cursorRow.seven,
                    cursorRow.eight,
                    cursorRow.nine,
                    cursorRow.ten,
                    cursorRow.eleven,
                    cursorRow.twelve
                )
            );


            // bufferOfRows[indexIntoBufferOfRows++] = string(
            //     abi.encodePacked(
            //         cursorRow.one,
            //         cursorRow.two,
            //         cursorRow.three,
            //         cursorRow.four,
            //         cursorRow.five,
            //         cursorRow.six,
            //         cursorRow.seven,
            //         cursorRow.eight
            //     )
            // );
            cursor.x = 0;
            cursor.y += 1;
            
            console.log('ROW:: ', row );


            if (indexIntoBufferOfRows >= 8) {

                blockOfEightRows[indexIntoblockOfEightRows++] = string(
                    abi.encodePacked(
                        bufferOfRows[0],
                        bufferOfRows[1],
                        bufferOfRows[2],
                        bufferOfRows[3],
                        bufferOfRows[4],
                        bufferOfRows[5],
                        bufferOfRows[6],
                        bufferOfRows[7]
                    )
                );
                console.log('BLOCK COMPLETE:: ', indexIntoblockOfEightRows );
                console.log('GAS:: ', gasleft());
                indexIntoBufferOfRows = 0;
            }
        }


        // for (uint256 dataIndex = 0; dataIndex < 1024; ) {
            
        //     cursorRow.one = fourPixels(coordinateLookup, cursor, colours);
        //     cursor.x += 4;
        //     cursorRow.two = fourPixels(coordinateLookup, cursor, colours);
        //     dataIndex += 8;
        //     // - //
        //     cursor.x += 4;
        //     cursorRow.three = fourPixels(coordinateLookup, cursor, colours);
        //     cursor.x += 4;
        //     cursorRow.four = fourPixels(coordinateLookup, cursor, colours);
        //     dataIndex += 8;
        //     // - //
        //     cursor.x += 4;
        //     cursorRow.five = fourPixels(coordinateLookup, cursor, colours);
        //     cursor.x += 4;
        //     cursorRow.six = fourPixels(coordinateLookup, cursor, colours);
        //     dataIndex += 8;
        //     // - //
        //     cursor.x += 4;
        //     cursorRow.seven = fourPixels(coordinateLookup, cursor, colours);
        //     cursor.x += 4;
        //     cursorRow.eight = fourPixels(coordinateLookup, cursor, colours);
        //     dataIndex += 8;
        //     // - //

        //     bufferOfRows[indexIntoBufferOfRows++] = string(
        //         abi.encodePacked(
        //             cursorRow.one,
        //             cursorRow.two,
        //             cursorRow.three,
        //             cursorRow.four,
        //             cursorRow.five,
        //             cursorRow.six,
        //             cursorRow.seven,
        //             cursorRow.eight
        //         )
        //     );
        //     cursor.x = 0;
        //     cursor.y += 1;

        //     console.log('GAS:: ', gasleft());

        //     if (indexIntoBufferOfRows >= 8) {
        //         blockOfEightRows[indexIntoblockOfEightRows++] = string(
        //             abi.encodePacked(
        //                 bufferOfRows[0],
        //                 bufferOfRows[1],
        //                 bufferOfRows[2],
        //                 bufferOfRows[3],
        //                 bufferOfRows[4],
        //                 bufferOfRows[5],
        //                 bufferOfRows[6],
        //                 bufferOfRows[7]
        //             )
        //         );
        //         indexIntoBufferOfRows = 0;
        //     }
        // }

        return blockOfEightRows;
    }

    // Rather than constructing each svg rect one at a time, let's save on gas and construct four at a time.
    // Unfortunately we can't construct more than four pixels at a time, otherwise we would
    // run into "stack too deep" errors at compile time.
    //
    // In order to get this to compile correctly, make sure to have the following compiler settings:
    //
    //      optimizer: {
    //          enabled: true,
    //          runs: 2000,
    //          details: {
    //              yul: true,
    //              yulDetails: {
    //                  stackAllocation: true,
    //                  optimizerSteps: "dhfoDgvulfnTUtnIf"
    //              }
    //          }
    //      }
    function fourPixels(string[48] memory coordinateLookup, SVGCursor memory pos, string[2304] memory colours) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "PHJlY3QgICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x],
                    // colours[0],
                    "JyAgeD0n",
                    coordinateLookup[pos.x],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +1],
                    // colours[0],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 1],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +2],
                    // colours[0],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 2],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +3],
                    // colours[0],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 3],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAgIC8+"
                )
            );
    }

    function twoLayer (uint256 tokenId) public view returns (string[2304] memory){
        bytes1[8] memory bitMask;
        bitMask[0] = (0x7F); // 01111111
        bitMask[1] = (0xBF); // 10111111
        bitMask[2] = (0xDF); // 11011111
        bitMask[3] = (0xEF); // 11101111
        bitMask[4] = (0xF7); // 11110111
        bitMask[5] = (0xFB); // 11111011
        bitMask[6] = (0xFD); // 11111101
        bitMask[7] = (0xFE); // 11111110
        
        // bytes32 layer1 = bytes32(uint256(tokenLayers[tokenId][0][0]));
        // bytes32 layer1P2 = bytes32(uint256(tokenLayers[tokenId][0][1]));
        // bytes32 layer1P3 = bytes32(uint256(tokenLayers[tokenId][0][2]));
        // bytes32 layer1P4 = bytes32(uint256(tokenLayers[tokenId][0][3]));


        // bytes32 layer2 = bytes32(uint256(tokenLayers[tokenId][1][0]));
        // bytes32 layer2P2 = bytes32(uint256(tokenLayers[tokenId][1][1]));
        // bytes32 layer2P3 = bytes32(uint256(tokenLayers[tokenId][1][2]));
        // bytes32 layer2P4 = bytes32(uint256(tokenLayers[tokenId][1][3]));

        string[2304] memory colours;

        uint8 bit1;
        uint8 bit2;
        
        for (uint256 l; l < 9; l++) {
            bytes32 layer1 = bytes32(uint256(tokenLayers[tokenId][0][l]));
            bytes32 layer2 = bytes32(uint256(tokenLayers[tokenId][1][l]));
            for (uint256 i; i < 32; i++) {
                for (uint256 b; b < bitMask.length; b++) {
                    bit1 = (bitMask[b] | bytes1(uint8(layer1[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
                    bit2 = (bitMask[b] | bytes1(uint8(layer2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
                    
                    uint256 cid = (l*256)+(i*8)+b;

                    if(bit1 == 0 && bit2 == 0) colours[cid] = BLACK64;
                    if(bit1 == 1 && bit2 == 1) colours[cid] = WHITE64;
                    if(bit1 == 0 && bit2 == 1) colours[cid] = RED64;
                    if(bit1 == 1 && bit2 == 0) colours[cid] = GREEN64;
                    console.log('colour', cid);
                }
            }
        }

        // for (uint256 i; i < 32; i++) {
        //     for (uint256 b; b < bitMask.length; b++) {
        //         bit1 = (bitMask[b] | bytes1(uint8(layer1[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
        //         bit2 = (bitMask[b] | bytes1(uint8(layer2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;

        //         if(bit1 == 0 && bit2 == 0) colours[(i*8)+b] = BLACK64;
        //         if(bit1 == 1 && bit2 == 1) colours[(i*8)+b] = WHITE64;
        //         if(bit1 == 0 && bit2 == 1) colours[(i*8)+b] = RED64;
        //         if(bit1 == 1 && bit2 == 0) colours[(i*8)+b] = GREEN64;
        //         console.log(i*8+b);
        //     }
        // }

        // console.log('GAS Colour Loop:: ', gasleft());

        // for (uint256 i; i < 32; i++) {
        //     for (uint256 b; b < bitMask.length; b++) {
        //         bit1 = (bitMask[b] | bytes1(uint8(layer1P2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
        //         bit2 = (bitMask[b] | bytes1(uint8(layer2P2[i])) == bytes1(uint8(0xFF))) ? 1 : 0;

        //         if(bit1 == 0 && bit2 == 0) colours[256+(i*8)+b] = BLACK64;
        //         if(bit1 == 1 && bit2 == 1) colours[256+(i*8)+b] = WHITE64;
        //         if(bit1 == 0 && bit2 == 1) colours[256+(i*8)+b] = RED64;
        //         if(bit1 == 1 && bit2 == 0) colours[256+(i*8)+b] = GREEN64;
        //     }
        // }

        // for (uint256 i; i < 32; i++) {
        //     for (uint256 b; b < bitMask.length; b++) {
        //         bit1 = (bitMask[b] | bytes1(uint8(layer1P3[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
        //         bit2 = (bitMask[b] | bytes1(uint8(layer2P3[i])) == bytes1(uint8(0xFF))) ? 1 : 0;

        //         if(bit1 == 0 && bit2 == 0) colours[512+(i*8)+b] = BLACK64;
        //         if(bit1 == 1 && bit2 == 1) colours[512+(i*8)+b] = WHITE64;
        //         if(bit1 == 0 && bit2 == 1) colours[512+(i*8)+b] = RED64;
        //         if(bit1 == 1 && bit2 == 0) colours[512+(i*8)+b] = GREEN64;
        //     }
        // }
        
        // for (uint256 i; i < 32; i++) {
        //     for (uint256 b; b < bitMask.length; b++) {
        //         bit1 = (bitMask[b] | bytes1(uint8(layer1P3[i])) == bytes1(uint8(0xFF))) ? 1 : 0;
        //         bit2 = (bitMask[b] | bytes1(uint8(layer2P3[i])) == bytes1(uint8(0xFF))) ? 1 : 0;

        //         if(bit1 == 0 && bit2 == 0) colours[768+(i*8)+b] = BLACK64;
        //         if(bit1 == 1 && bit2 == 1) colours[768+(i*8)+b] = WHITE64;
        //         if(bit1 == 0 && bit2 == 1) colours[768+(i*8)+b] = RED64;
        //         if(bit1 == 1 && bit2 == 0) colours[768+(i*8)+b] = GREEN64;
        //     }
        // }
        
        return colours;
    }

}

library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        uint256 encodedLen = 4 * ((len + 2) / 3);

        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xfff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}