import { ethers, utils } from 'ethers';

export default async function payWithMetamask(ethAmount) {
    // console.log(`payWithMetamask(ethAmount=${ethAmount})`);

    const CONTRACT_ADDRESS = "0x167BCF26751dC5dAafeA9dbe7cb761ca2fCc7920";
    const metaMask = window.ethereum;

    // Request account access if needed
    await metaMask.enable();

    const provider = new ethers.providers.Web3Provider(metaMask);
    const signer = provider.getSigner();
    const params = {
        to: CONTRACT_ADDRESS,
        value: utils.parseUnits(ethAmount, 'ether').toHexString()
    };

    // Send the tx
    await signer.sendTransaction(params).then((tx) => { console.log(tx) });

}
































// const contract = new ethers.Contract(contractAddress, abi, provider);
// const constant = contract.connect(signer);
// let tx = await signer.sendTransaction(tx);
// let signature = await signer.signMessage("Hello world");

// // Running on the page, in the browser
// // This API will go live in Q1 2020
// // It will be the only API available after a 6-week deprecation period

//   if (!window.ethereum || !window.ethereum.isMetaMask) {
//     throw new Error('Please install MetaMask.')
//   }

//   /*********************************************************/
//   /* Handle chain (network) and chainChanged, per EIP 1193 */
//   /*********************************************************/

//   let currentChainId = null
//   window.ethereum.send('eth_chainId')
//     .then(handleChainChanged)
//     .catch(err => console.error(err)) // This should never happen

//   window.ethereum.on('chainChanged', handleChainChanged)

//   function handleChainChanged (chainId) {

//     if (currentChainId !== chainId) {

//       currentChainId = chainId
//       // Run any other necessary logic...
//     }
//   }

//   /**********************************************************/
//   /* Handle user accounts and accountsChanged, per EIP 1193 */
//   /**********************************************************/

//   let currentAccount = null
//   window.ethereum.send('eth_accounts')
//     .then(handleAccountsChanged)
//     .catch(err => {
//       // In the future, maybe in 2020, this will return a 4100 error if
//       // the user has yet to connect
//       if (err.code === 4100) { // EIP 1193 unauthorized error
//         console.log('Please connect to MetaMask.')
//       } else {
//         console.error(err)
//       }
//     })

//   // Note that this event is emitted on page load.
//   // If the array of accounts is non-empty, you're already
//   // connected.
//   window.ethereum.on('accountsChanged', handleAccountsChanged)

//   // For now, 'eth_accounts' will continue to always return an array
//   function handleAccountsChanged (accounts) {

//     if (accounts.length === 0) {

//       // MetaMask is locked or the user has not connected any accounts
//       console.log('Please connect to MetaMask.')

//     } else if (accounts[0] !== currentAccount) {

//       currentAccount = accounts[0]
//       // Run any other necessary logic...
//     }
//   }

//   /***********************************/
//   /* Handle connecting, per EIP 1102 */
//   /***********************************/

//   // You should only attempt to connect in response to user interaction,
//   // such as a button click. Otherwise, you're popup-spamming the user
//   // like it's 1999.
//   // If you can't retrieve the user's account(s), you should encourage the user
//   // to initiate a connection attempt.
//   document.getElementById('connectButton', connect)

//   function connect () {

//     // This is equivalent to ethereum.enable()
//     window.ethereum.send('eth_requestAccounts')
//       .then(handleAccountsChanged)
//       .catch(err => {
//         if (err.code === 4001) { // EIP 1193 userRejectedRequest error
//           console.log('Please connect to MetaMask.')
//         } else {
//           console.error(err)
//         }
//       })
//   }
