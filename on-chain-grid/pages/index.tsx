import type { NextPage } from 'next';
import Head from 'next/head';
import styles from '../styles/Home.module.css';
import React from 'react';

const Web3Utils = require('web3-utils');

const Home: NextPage = () => {
  const [bn, setBn] = React.useState('');

  let grid = [...Array(256)].map( (x,i) => {
    const evenRow = (Math.floor(i /16)) % 2 == 0;
    if (evenRow) return i % 2 ? 1:0 
    else return i % 2 ? 0:1 ;
  })


  React.useEffect(() => {
    if (grid) {
      const number = new Web3Utils.BN(0); 
      grid.forEach((n, i) => number.setn(i, n));
      setBn(number.toString())
    }
  }, [grid]);

  return (
    <div className={styles.container}>
      <Head>
        <title>RainbowKit App</title>
        <meta
          name="description"
          content="Generated by @rainbow-me/create-rainbowkit"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <div className={styles.grid}>
          {grid.map((x, i) => 
              <div
                style={{ backgroundColor: x == 1 ? '#fafafa' : '#333'}}
                key={i}
                className={styles.gridItem}>{x }</div>
          )}
        </div>
        <div>
          <p>{bn}</p>
        </div>
      </main>
    </div>
  );
};

export default Home;
