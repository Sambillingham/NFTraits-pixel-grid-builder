const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3Utils = require('web3-utils');

let checkerGrid = [...Array(256)].map( (x,i) => {
  const evenRow = ( Math.floor(i /16)) % 2 == 0;
  if (evenRow) return i % 2 ? 1:0 
  else return i % 2 ? 0:1 ;
})

const checkerNumber = new Web3Utils.BN(0); 
checkerGrid.reverse().forEach((n, i) => checkerNumber.setn(i, n));

const grid = [...Array(256)].fill(0);
const grid2 = [...Array(256)].fill(0);
grid[0] = 0 // Black
grid2[0] = 0

grid[1] = 1 // White
grid2[1] = 1 //

grid[2] = 0 // Red
grid2[2] = 1 //

grid[3] = 1 // Green
grid2[3] = 0 //

grid[4] = 0 // Black
grid2[4] = 0

grid[5] = 1 // White
grid2[5] = 1 //

grid[6] = 0 // Red
grid2[6] = 1 //

grid[7] = 1 // Green
grid2[7] = 0 //


const number = new Web3Utils.BN(0); 
grid.reverse().forEach((n, i) => number.setn(i, n));

const number2 = new Web3Utils.BN(0); 
grid2.reverse().forEach((n, i) => number2.setn(i, n));

describe("svg", async function () {

  // it("run single layer", async function () {
  //   const svgF = await hre.ethers.getContractFactory("Svg");
  //   const s = await svgF.deploy();
  
  //   await s.deployed();
  
  //   console.log("S -> deployed to:", s.address);
  //   const svg = await s.singleLayer(checkerNumber.toString());
  //   console.log(svg)
  // });

  // it("run two layer", async function () {
  //   const svgF = await hre.ethers.getContractFactory("Svg");
  //   const s = await svgF.deploy();
  
  //   await s.deployed();
  
  //   console.log("S -> deployed to:", s.address);

  //   await s.store( 0,[number.toString(), number.toString() ], [number2.toString(), number2.toString() ]);

  //   const svg = await s.twoLayer(0);

  //   console.log('svg', svg)
  // });

  // it("run two layer", async function () {
  //   const svgF = await hre.ethers.getContractFactory("Svg");
  //   const s = await svgF.deploy();
  
  //   await s.deployed();
  
  //   console.log("S -> deployed to:", s.address);

  //   await s.store( 0,[number.toString(), number.toString() ], [number2.toString(), number2.toString() ]);

  //   const svg = await s.draw2();

  //   console.log('svg', svg)
  // });



  // it("run two layer", async function () {
  //   const svgF = await hre.ethers.getContractFactory("Renderer");
  //   const s = await svgF.deploy();
  
  //   await s.deployed();
  
  //   console.log("S -> deployed to:", s.address);

  //   await s.store( 0,[number.toString(), number.toString(), number.toString(), number.toString(), number.toString(), number.toString(), number.toString(), number.toString(),  number.toString() ], [number2.toString(), number2.toString(), number2.toString(), number2.toString(), number2.toString(), number2.toString(), number2.toString(), number2.toString(),  number2.toString() ]);


  //   const svg = await s.tokenSVG(0);

  //   // console.log('svg', svg)
  // });

  it("run two layer", async function () {
    const svgF = await hre.ethers.getContractFactory("Renderer");
    const s = await svgF.deploy();
  
    await s.deployed();
  
    console.log("S -> deployed to:", s.address);

    await s.store( 0,
      [
        '86844066927987455099782736483744961174672399085325514818239763022828703629312',
        
        '20219960000363051681728739404060170327935460741940307155772988456960',
        
        '1325135298583792955013774665584487322611578355183799969760738571515330560',
        
        '86844066927987455099782736483744961174672399085325514818239763022828703629312',
        
        '20219960000363051681728739404060170327935460741940307155772988456960',
        
        '1325135298583792955013774665584487322611578355183799969760738571515330560',
        
        '86844066927987455099782736483744961174672399085325514818239763022828703629312',
        
        '20219960000363051681728739404060170327935460741940307155772988456960',
        
        '1325135298583792955013774665573336950012313023805991482058329992376352768',
        
        ] ,[
        '72370142045152214335675936980918049284343642892151693660279690520952983035904',
        
        '16849966666969209734773949503383475273279550618283589296477490380800',
        
        '1104279415486494129178145554653739435509648629319833308133948809596108800',
        
        '72370055773322879249818947069787467645560332571104595681866469185690586357760',
        
        '16849966666969209734773949503383475273279550618283589296477490380800',
        
        '1104279415486494129178145554653739435509648629319833308133948809596108800',
        
        '72370055773322879249818947069787467645560332571104595681866469185690586357760',
        
        '16849966666969212727929302757072651754426088021231213551827338395648',
        
        '1104292895459827704545933373813690591433594313753955059169480793353355264',
        
        ]
    );


    const svg64 = await s.tokenSVG(0);
    const buffer = Buffer.from(svg64, 'base64');

    console.log('svg',buffer.toString('ascii'))
  });

});
