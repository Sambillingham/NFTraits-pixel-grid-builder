const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3Utils = require('web3-utils');

let grid = [...Array(256)].map( (x,i) => {
  const evenRow = ( Math.floor(i /16)) % 2 == 0;
  if (evenRow) return i % 2 ? 1:0 
  else return i % 2 ? 0:1 ;
})

console.log(grid)


const number = new Web3Utils.BN(0); 
grid.reverse().forEach((n, i) => number.setn(i, n));
console.log(number.toString())

const grid2 = [...Array(256)].fill(0);
grid2[0] = 1
grid2[15] = 1
grid2[240] = 1
grid2[255] = 1
const number2 = new Web3Utils.BN(0); 
grid2.reverse().forEach((n, i) => number2.setn(i, n));

describe("svg", function () {
  it("run svg", async function () {
    const svgF = await hre.ethers.getContractFactory("Svg");
    const s = await svgF.deploy();
  
    await s.deployed();
  
    console.log("S -> deployed to:", s.address);
    const svg = await s.run(number.toString());
    const svg2 = await s.run2(number.toString(), number2.toString());

    
    console.log(svg2)
    expect(s.address).to.equal(s.address)
  });
});
