import Web3 from "web3";

let web3;

if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
  // If browser has metamask installed
  window.ethereum.request({ method: "eth_requestAccounts" });
  web3 = new Web3(window.ethereum);
} else {
    // We are on the server *OR* the user is not running metamask
    const provider = new Web3.providers.HttpProvider(
        "https://rinkeby.infura.io/v3/169110c33a7e44f3aa4356d00a406d86"
    );
    web3 = new Web3(provider);
}

export default web3;
