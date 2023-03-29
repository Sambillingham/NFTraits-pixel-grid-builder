import { useState } from "react";

import {
    useAccount,
    usePrepareContractWrite,
    useContractWrite,
    useContractRead,
    useWaitForTransaction,
  } from "wagmi";

import ContractMetadata from "../TraitsMetadata.json";


const MetaForm = ({layerData}) => {
    const [traitName, setTraitName] = useState('');
    const [traitId, setTraitId] = useState(0);
    const [traitIntrinsic, setTraitIntrinsic] = useState(0);

    const metadataContract = {
        addressOrName: "0xF0B4fc4C4c8f9f45A43Cc264515D7fF471b17ca5",
        contractInterface: ContractMetadata.abi,
    };


    const { config: configMetadata } = usePrepareContractWrite({
        ...metadataContract,
        abi: ContractMetadata.abi,
        address: "0xF0B4fc4C4c8f9f45A43Cc264515D7fF471b17ca5",
        functionName: "store",
        args: [
            traitId,
            layerData,
            traitIntrinsic,
            btoa(traitName)
        ],
        overrides: {
            gasLimit: 400000,
        },
      });

    const {
        write: storeTrait,
        data: result,
        error,
        isError,
        isLoading,
      } = useContractWrite(configMetadata);

    const emitStore = () => {
        console.log('EMIT STORE', metadataContract)
        storeTrait()
    }
      
    return (
      <div className="border-2 border-slate-800 bg-slate-50">
          <label className="block py-2">
              <h3 className="text-lg px-2">Name (base 64 encode)</h3>
              <input
              className="w-full py-2 px-2 border-slate-800 border border-x-0" type="text" 
              value={traitName} onChange={ (e) => setTraitName(e.target.value)}></input>
              <span className="inline-block w-full py-2 px-2">{ btoa(traitName) }</span>
          </label>

          <label className="block py-2">
              <h3 className="text-lg px-2">Group ID</h3>
              <input
              value={traitId} onChange={ (e) => setTraitId(e.target.value)}
              className="w-full py-2 px-2 border-slate-800 border border-x-0" min="0" type="number"></input>
          </label>

          <label className="block py-2">
              <h3>Intrinsic Value (0-10)</h3>
              <input
              value={traitIntrinsic} onChange={ (e) => setTraitIntrinsic(e.target.value)}
              className="w-full py-2 px-2 border-slate-800 border border-x-0" min="0" max="10" type="number"></input>
          </label>

          <label className="block py-2">
              <h3 className="text-lg px-2">Layer Data</h3>
              <textarea 
              className="w-full py-2 px-2 border-slate-800 border border-x-0"
              readOnly
              value={`['${layerData.join("','")}']`}
              />
          </label>
        <button
            onClick={() => emitStore()}
            className="block w-full bg-slate-800 px-8 py-4 text-center uppercase text-white shadow-solid shadow-slate-400">
            Submit
        </button>
      </div>


    );
  };
  
  export default MetaForm;