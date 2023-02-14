import '../styles/globals.css';
import '@rainbow-me/rainbowkit/styles.css';
import type { AppProps } from 'next/app';
import { RainbowKitProvider, getDefaultWallets } from '@rainbow-me/rainbowkit';
import { chain, configureChains, createClient, WagmiConfig } from 'wagmi';
import { mainnet, goerli } from "wagmi/chains";
import { alchemyProvider } from 'wagmi/providers/alchemy';
import { publicProvider } from 'wagmi/providers/public';

import { VT323 } from "@next/font/google";

const VT323Font = VT323({ weight: "400", subsets: ["latin"] });

const { chains, provider, webSocketProvider } = configureChains(
  [mainnet, goerli],
  [
    // alchemyProvider({
    //   // This is Alchemy's default API key.
    //   // You can get your own at https://dashboard.alchemyapi.io
    //   apiKey: '_gg7wSSi0KMBsdKnGVfHDueq6xMB9EkC',
    // }),
    publicProvider(),
  ]
);

const { connectors } = getDefaultWallets({
  appName: 'Traits Builder',
  chains,
});

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
  webSocketProvider,
});

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <>
    <style jsx global>{`
    html {
      font-family: ${VT323Font.style.fontFamily};
    }
  `}</style>
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider chains={chains}>
        <Component {...pageProps} />
      </RainbowKitProvider>
    </WagmiConfig>
    </>
  );
}

export default MyApp;
