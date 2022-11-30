// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";

contract Renderer {
    struct SVGRowBuffer {
        string one; 
        string two; 
        string three;
        string four; 
        string five; 
        string six; 
        string seven; 
        string eight; 
    }

    struct SVGCursor {
        uint16 x;
        uint16 y;
    }

    string WHITE64 = "ZmZm";
    string BLACK64 = "MDAw";
    string RED64 = "ZmYwMDAw";
    string GREEN64 = "MDBmZjAw";
    string BLUE64 = "MDAwMGZm";
    string G164 = "MzMz";
    string G264 = "OTk5";
    string G364 = "ZGRk";

    constructor() {}

    mapping(uint256 => uint256[9][2]) tokenLayers;

    mapping(uint256 => uint256) intrinsicValues;

    function store (uint256 tokenId, uint256[9] calldata layer1, uint256[9] calldata layer2, uint256 intrinsicValue) public {
        tokenLayers[tokenId][0] = layer1;
        tokenLayers[tokenId][1] = layer2;
        intrinsicValues[tokenId] = intrinsicValue;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {

        string[6] memory buffer = generateSvgData(tokenId);
        string memory att = getAttributes(tokenId);
        console.log(att);
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,eyAgImltYWdlX2RhdGEiOiAiPHN2ZyB2ZXJzaW9uPScxLjEnIHZpZXdCb3g9JzAgMCA0ODAgNDgwJyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHNoYXBlLXJlbmRlcmluZz0nY3Jpc3BFZGdlcyc+",
                    buffer[0],
                    buffer[1],
                    buffer[2],
                    buffer[3],
                    buffer[4], 
                    buffer[5],
                    "PHN0eWxlPnJlY3R7d2lkdGg6MTBweDtoZWlnaHQ6MTBweDt9PC9zdHlsZT48L3N2Zz4iLCAgIm5hbWUiOiAiVHJhaXRz", //style tag + name
                    'IyAgMDAw', // need function to take uint256 -> base64 encoded string
                    "IiwgImRlc2NyaXB0aW9uIjogIlRyYWl0cyIs", // description 
                    att
                )
        );
    }
    // 
    function getAttributes(uint256 tokenid) public view returns (string memory){
        uint256 groupId = tokenid - (tokenid % 5); // base token in a group
        uint256 rarityLevel = tokenid % 5;
        string[5] memory rarity = ['common', 'uncommon', 'rare', 'ledgendary', 'unique'];
        string[8] memory iv = ['0', '1', '2', '3', '4', '5', '6', '7'];

        bytes memory attributes = abi.encodePacked(
            '"attributes": [ { "trait_type": "Rarity Level", "value": "',
            rarity[rarityLevel],
            '"},{"trait_type": "Intrinsic Value","value":',
            iv[intrinsicValues[groupId]], 
            '}]}'
        );
        return string(
            abi.encodePacked(
                Base64.encode(attributes)
            )
        );
    }

    function tokenSVG(uint256 tokenId) public view returns (string memory) {
        // 6 lots of 8 rows 
        string[6] memory buffer = generateSvgData(tokenId);

        string memory svg = 
            string.concat(
                    "PHN2ZyB2ZXJzaW9uPScxLjEnIHZpZXdCb3g9JzAgMCA0ODAgNDgwJyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHNoYXBlLXJlbmRlcmluZz0nY3Jpc3BFZGdlcyc+",
                    buffer[0],
                    buffer[1],
                    buffer[2],
                    buffer[3],
                    buffer[4], 
                    buffer[5],  
                    "PHN0eWxlPnJlY3R7d2lkdGg6MTBweDtoZWlnaHQ6MTBweDt9PC9zdHlsZT48L3N2Zz4"
            );
            console.log('GAS:: ', gasleft());
        return svg;
    }


    function generateSvgData(uint256 tokenId) private view returns (string[6] memory) {
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

        string[2304] memory colours  = getColoursFromLayers(tokenId);

        for (uint256 row = 0; row < 48; row++) {
            
            cursorRow.one = sixPixels(coordinateLookup, cursor, colours);
            cursor.x += 6;
            cursorRow.two = sixPixels(coordinateLookup, cursor, colours);
            cursor.x += 6;
            cursorRow.three = sixPixels(coordinateLookup, cursor, colours);
            cursor.x += 6;
            cursorRow.four = sixPixels(coordinateLookup, cursor, colours);
            cursor.x += 6;
            cursorRow.five = sixPixels(coordinateLookup, cursor, colours);
            cursor.x += 6;
            cursorRow.six = sixPixels(coordinateLookup, cursor, colours);
            cursor.x += 6;
            cursorRow.seven = sixPixels(coordinateLookup, cursor, colours);
            cursor.x += 6;
            cursorRow.eight = sixPixels(coordinateLookup, cursor, colours);
            
            // Stack too deep if single list og string concat
            bufferOfRows[indexIntoBufferOfRows++] = string.concat(
                    cursorRow.one,
                    cursorRow.two,
                    cursorRow.three,
                    cursorRow.four,
                    cursorRow.five,
                    cursorRow.six,
                    cursorRow.seven,
                    cursorRow.eight
            );

            cursor.x = 0;
            cursor.y += 1;
            
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
                console.log('GAS:: ', gasleft());
                indexIntoBufferOfRows = 0;
            }
        }
        console.log('GAS:: ', gasleft());
        return blockOfEightRows;
    }
    
    function sixPixels(string[48] memory coordinateLookup, SVGCursor memory pos, string[2304] memory colours) internal pure returns (string memory) {
        return
            string.concat(
                string.concat(
                    "PHJlY3QgICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x],
                    "JyAgeD0n",
                    coordinateLookup[pos.x],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +1],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 1],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +2],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 2],
                    "JyAgeT0n",
                    coordinateLookup[pos.y]
                ),
                string.concat(
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +3],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 3],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +4],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 4],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAvPjxyZWN0ICBmaWxsPScj",
                    colours[(pos.y * 48)+ pos.x +5],
                    "JyAgeD0n",
                    coordinateLookup[pos.x + 5],
                    "JyAgeT0n",
                    coordinateLookup[pos.y],
                    "JyAgIC8+"
                )
            );
    }

    function getColoursFromLayers (uint256 tokenId) public view returns (string[2304] memory){
        bytes1[8] memory bitMask;
        bitMask[0] = (0x7F); // 01111111
        bitMask[1] = (0xBF); // 10111111
        bitMask[2] = (0xDF); // 11011111
        bitMask[3] = (0xEF); // 11101111
        bitMask[4] = (0xF7); // 11110111
        bitMask[5] = (0xFB); // 11111011
        bitMask[6] = (0xFD); // 11111101
        bitMask[7] = (0xFE); // 11111110
        
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

                    if(bit1 == 0 && bit2 == 0) colours[cid] = WHITE64;
                    if(bit1 == 1 && bit2 == 1) colours[cid] = G164;
                    if(bit1 == 1 && bit2 == 0) colours[cid] = G264;
                    if(bit1 == 0 && bit2 == 1) colours[cid] = G364;

                }
            }
        }
    
        return colours;
    }

// library Base64 {
//     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//     function encode(bytes memory data) internal pure returns (string memory) {
//         uint256 len = data.length;
//         if (len == 0) return "";

//         uint256 encodedLen = 4 * ((len + 2) / 3);

//         bytes memory result = new bytes(encodedLen + 32);

//         bytes memory table = TABLE;

//         assembly {
//             let tablePtr := add(table, 1)
//             let resultPtr := add(result, 32)

//             for {
//                 let i := 0
//             } lt(i, len) {

//             } {
//                 i := add(i, 3)
//                 let input := and(mload(add(data, i)), 0xfff)

//                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
//                 out := shl(8, out)
//                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
//                 out := shl(8, out)
//                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
//                 out := shl(8, out)
//                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
//                 out := shl(224, out)

//                 mstore(resultPtr, out)

//                 resultPtr := add(resultPtr, 4)
//             }

//             switch mod(len, 3)
//             case 1 {
//                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
//             }
//             case 2 {
//                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
//             }

//             mstore(result, encodedLen)
//         }

//         return string(result);
//     }
// }

library Base64 {
    /**
     * @dev Base64 Encoding/Decoding Table
     */
    string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /**
     * @dev Converts a `bytes` to its Bytes64 `string` representation.
     */
    function encode(bytes memory data) internal pure returns (string memory) {
        /**
         * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
         * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
         */
        if (data.length == 0) return "";

        // Loads the table into memory
        string memory table = _TABLE;

        // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
        // and split into 4 numbers of 6 bits.
        // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
        // - `data.length + 2`  -> Round up
        // - `/ 3`              -> Number of 3-bytes chunks
        // - `4 *`              -> 4 characters for each chunk
        string memory result = new string(4 * ((data.length + 2) / 3));

        /// @solidity memory-safe-assembly
        assembly {
            // Prepare the lookup table (skip the first "length" byte)
            let tablePtr := add(table, 1)

            // Prepare result pointer, jump over length
            let resultPtr := add(result, 32)

            // Run over the input, 3 bytes at a time
            for {
                let dataPtr := data
                let endPtr := add(data, mload(data))
            } lt(dataPtr, endPtr) {

            } {
                // Advance 3 bytes
                dataPtr := add(dataPtr, 3)
                let input := mload(dataPtr)

                // To write each character, shift the 3 bytes (18 bits) chunk
                // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
                // and apply logical AND with 0x3F which is the number of
                // the previous character in the ASCII table prior to the Base64 Table
                // The result is then added to the table to get the character to write,
                // and finally write it in the result pointer but with a left shift
                // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits

                mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance

                mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance

                mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance

                mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance
            }

            // When data `bytes` is not exactly 3 bytes long
            // it is padded with `=` characters at the end
            switch mod(mload(data), 3)
            case 1 {
                mstore8(sub(resultPtr, 1), 0x3d)
                mstore8(sub(resultPtr, 2), 0x3d)
            }
            case 2 {
                mstore8(sub(resultPtr, 1), 0x3d)
            }
        }

        return result;
    }
}