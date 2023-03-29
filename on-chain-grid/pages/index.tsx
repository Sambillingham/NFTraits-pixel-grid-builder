import type { NextPage } from 'next';
import Head from 'next/head';
import styles from '../styles/Home.module.css';
import React from 'react';
import { ConnectButton } from "@rainbow-me/rainbowkit";

const Web3Utils = require('web3-utils');

import MetaForm from '../components/MetaForm';
import ContractData from '../components/ContractData';

const Home: NextPage = () => {
  const [layer, setLayer] = React.useState<string[]>([]);
  const [drawing, setDrawing] = React.useState<boolean>(false);
  const [grid, setGrid] = React.useState<number[]>([...Array(1024)].fill(0));
  const [currentColour, setCurrentColour] = React.useState<number>(1);
  const [rarityChoice, setRarityChoice] = React.useState<number>(4);
  const [gridBorder, setGridBorder] = React.useState<boolean>(true);
  const [pasteGrid, setPasteGrid] = React.useState<string>('');

  const colourOptions = ['#C8C8C8', '#999', '#666', '#111']

  const rarityPreview = [1,2,3,4,5]
  const rarityColours = ['#19983f','#2679ff','#ff4718','#ffb22d','rgba(131,58,180,1)']

  const clickPixel = (event: any, i: number) => {
    let g = grid;
    g[i] = currentColour;
    setGrid(g);
    setLayer([])
  }

  const fillPixel = (event: any, i: number) => {
    if(drawing) {
      let g = grid;
      g[i] = currentColour;
      setGrid(g);
      setLayer([])
    }
  }
  const pasteGridOn = () => {
    const newGrid = pasteGrid.split(',').map( (x:string) => parseInt(x))
    setGrid( newGrid )
  }
  
  const generate = () => {
    let layers = calcLayers(grid)
    
    layers[0] = spliceIntoChunks(layers[0], 256)
    layers[1] = spliceIntoChunks(layers[1], 256)
    
    const BigNumbersAsStrings = layers.map( layer => {
      return layer.map(layerChunk => {
        const bn = new Web3Utils.BN(0);
        layerChunk.reverse().forEach((n:number, i:number) => bn.setn(i, n));
        return bn.toString();
      })
    })
    
    setLayer([...BigNumbersAsStrings[0], ...BigNumbersAsStrings[1]])
  }

  const calcLayers = (arr: number[]) => {
    let l1 = [...Array(1024)].fill(0);
    let l2 = [...Array(1024)].fill(0);

    for (let i = 0; i < arr.length; i++) {
      const colour = arr[i];
      switch (colour) {
      case 0:
        l1[i] = 0;
        l2[i] = 0;
        // console.log(i, 'WHITE');
        break;
      case 1:
        l1[i] = 1;
        l2[i] = 1;
        // console.log(i, 'G1');
        break;
      case 2:
        l1[i] = 1;
        l2[i] = 0;
        // console.log(i,'G2');
        break;
      case 3:
        l1[i] = 0;
        l2[i] = 1;
        // console.log(i,'G3');
        break;
      }
    }
    
    return [l1, l2]
  }
  const spliceIntoChunks = (arr: number[], chunkSize: number) => {
    const res = [];
    console.log(arr.length)
    while (arr.length > 0) {
        const chunk = arr.splice(0, chunkSize);
        res.push(chunk);
    }
    console.log(res)
    return res;
  }
  return (
    <div className={styles.container}>
      <Head>
        <title>Traits Builder</title>
        <meta
          name="Traits Builder"
          content="From SB X Blergs DAO"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <div className="absolute top-5 right-5">
        <ConnectButton />
      </div>

      <main className="container mx-auto min-h-screen px-4">
        <section className="my-8 border-2 border-slate-800 bg-slate-50 px-4 py-4 shadow-solid shadow-slate-800">
          <h1 className="text-6xl font-bold ">NFTraits</h1>
          <ContractData />
        </section>
        
        <section className="flex flex-row border-2 border-slate-800 bg-slate-50 px-4 py-4 shadow-solid shadow-slate-800">
          <div className="basis-1/4 px-8 py-8">
            <h2 className="text-6xl">Trait Builder</h2>

              <div className={`${styles.options}`}>
                {colourOptions.map((colour, i) => 
                  <div
                    onClick={() => setCurrentColour(i)}
                    className={styles.colorChoice}
                    style={{ 
                      backgroundColor: colour,
                      boxShadow: '0 0 5px rgba(33,33,33,0.4)',
                      border: currentColour === i ? 'solid 2px red' : 'dotted 1px black'
                    }}
                    key={i}
                  >
                  </div>
                )}
              </div>

              <h2 className="mt-32 text-2xl">Rarity Preview</h2>
              <div className={`${styles.options}`}>
                {rarityPreview.map((colour, i) => 
                  <div
                    onClick={() => setRarityChoice(i)}
                    className={styles.colorChoice}
                    style={{ 
                      backgroundColor: rarityColours[i],
                      boxShadow: '0 0 5px rgba(33,33,33,0.4)',
                      border: rarityChoice === i ? 'solid 2px red' : 'dotted 1px black'
                    }}
                    key={i}
                  >
                  </div>
                )}
              </div>
              <div>
              <button
                onClick={ () => setGridBorder(gridBorder => !gridBorder)}
                className="mb-8 block w-full bg-slate-800 px-8 py-4 text-center uppercase text-white shadow-solid shadow-slate-400">
                Show/Hide Grid
                </button>

                <button onClick={() => generate()} className="mb-8 block w-full bg-slate-800 px-8 py-4 text-center uppercase text-white shadow-solid shadow-slate-400">
                generate
                </button>
              </div>
              <h1 className="text-2xl font-bold ">Trait Builder</h1>

              <MetaForm 
                layerData={layer}
              />

            </div>

            <div className={`basis-3/4 px-8 py-8 relative`}>
                
                {rarityChoice == 0 && <div className={`${styles.overlay} ${styles.overlay1}`}></div>}
                {rarityChoice == 1 && <div className={`${styles.overlay} ${styles.overlay2}`}></div>}
                {rarityChoice == 2 && <div className={`${styles.overlay} ${styles.overlay3}`}></div>}
                {rarityChoice == 3 && <div className={`${styles.overlay} ${styles.overlay4}`}></div>}
                {rarityChoice == 4 && <div className={`${styles.overlay} ${styles.overlay5}`}></div>}

                <div className={`border-2 border-slate-800 ${styles.grid}`}>
                  {grid.map((x, i) => 
                      <div
                        onClick={(event) => clickPixel?.(event, i )}
                        onMouseDown={() => setDrawing(true) }
                        onMouseUp={() => setDrawing(false) }
                        onMouseEnter={(event) => fillPixel?.(event, i ) }
                        key={i}
                        style={{background: colourOptions[grid[i]] }}
                        className={`${styles.gridItem} ${gridBorder ? styles.gridItemBorder : ''}`}></div>
                  )}
                </div>
                <div>
                  <h2 className="mt-4">Current Grid:</h2>
                  <input className="border-2 border-slate-800" disabled value={grid.join(',')} />
                  <h2>New:</h2>
                  <input className="border-2 border-slate-800" value={pasteGrid} onChange={ (e) => setPasteGrid(e.target.value)}/>
                  <button onClick={() => pasteGridOn()} className="mt-4 mb-4 block w-32 bg-slate-800 px-8 py-4 text-center uppercase text-white shadow-solid shadow-slate-400">
                    update
                  </button>
                </div>
            </div>

        </section>

        {/* <section className="mt-8 flex flex-col border-2 border-slate-800 bg-slate-50 px-4 py-4 shadow-solid shadow-slate-800">
          <h2 className="text-2xl">Edit/Add Season</h2>
          
          <div className="basis-2/4 w-2/4 border-2 border-slate-800 bg-slate-50">
              <label className="block py-2">
                  <h3 className="text-lg px-2">Season Number</h3>
                  <input
                  className="w-full py-2 px-2 border-slate-800 border border-x-0" type="number" ></input>
              </label>
              <label className="block py-2">
                  <h3 className="text-lg px-2">Metadata contract address </h3>
                  <input
                  className="w-full py-2 px-2 border-slate-800 border border-x-0" type="text" ></input>
              </label>

            <button
                className="block w-full bg-slate-800 px-8 py-4 text-center uppercase text-white shadow-solid shadow-slate-400">
                Submit
            </button>
          </div>

        </section>

        <section className="mt-8 flex flex-col border-2 border-slate-800 bg-slate-50 px-4 py-4 shadow-solid shadow-slate-800">
          <h2 className="text-2xl">Set Active Season</h2>
          
          <div className="basis-2/4 w-2/4 border-2 border-slate-800 bg-slate-50">
              <label className="block py-2">
                  <h3 className="text-lg px-2">Season Number</h3>
                  <input
                  className="w-full py-2 px-2 border-slate-800 border border-x-0" type="number" ></input>
              </label>
   

            <button
                className="block w-full bg-slate-800 px-8 py-4 text-center uppercase text-white shadow-solid shadow-slate-400">
                Submit
            </button>
          </div>

        </section> */}
      </main>
    </div>
  );
};

export default Home;
