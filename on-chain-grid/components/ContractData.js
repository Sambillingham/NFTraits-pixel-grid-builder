import { useState,useEffect } from "react";

import { ethers } from "ethers";

import {
    useAccount,
    usePrepareContractWrite,
    useContractWrite,
    useContractRead,
    useWaitForTransaction,
  } from "wagmi";

import ContractMetadata from "../TraitsMetadata.json";
import ContractInterfaceTraits from "../NFTraits.json";


const MetaForm = () => {
    const [totalSupply, setTotalSupply] = useState(0);
    const [open, setOpen] = useState(true);
    const [season, setSeason] = useState(1);
    const [price, setPrice] = useState(0);

    const metadataContract = {
        address: "0xF0B4fc4C4c8f9f45A43Cc264515D7fF471b17ca5",
        abi: ContractMetadata.abi,
    };

    const traitsContract = {
        address: '0x0a0BaB951Bc81367376c61caF2476459f9C8e9F9',
        abi: ContractInterfaceTraits.abi,
    };


    const { data: batchesMinted } = useContractRead({
        ...traitsContract,
        functionName: "batchesMinted",
        watch: true,
    });
    const { data: openState } = useContractRead({
        ...traitsContract,
        functionName: "OPEN",
        watch: true,
    });
    

    const { data: activeSeason } = useContractRead({
        ...traitsContract,
        functionName: "activeSeason",
        watch: true,
    });

    const { data: mintPrice } = useContractRead({
        ...traitsContract,
        functionName: "mintPrice",
        watch: true,
    });
    
    useEffect(() => {
        if (batchesMinted) setTotalSupply(batchesMinted.toNumber());
        if (openState) setOpen(openState)
        if (activeSeason) setSeason(activeSeason.toNumber())
        if (mintPrice) setPrice(mintPrice.toNumber()) 
        
      }, [batchesMinted, openState, activeSeason, mintPrice]);

      
    return (
      <div className="flex flex-row">
          <div>
            <p className="text-4xl">Batches Minted : {totalSupply} ({totalSupply*8} Total Traits)</p>
            <p className="text-4xl">Status: {open ? 'OPEN' : 'CLOSED'}</p>
            <p className="text-4xl">Active Season: {season} </p>
            <p className="text-4xl">Current Price: {ethers.utils.formatEther(price)} ether </p>
            <p className="text-4xl">Contract Address: 0x0a0BaB951Bc81367376c61caF2476459f9C8e9F9 </p>
          </div>
          <div>
              
          </div>
      </div>

    );
  };
  
  export default MetaForm;