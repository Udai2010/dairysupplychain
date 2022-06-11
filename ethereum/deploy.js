const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const { abi, evm } = require("../ethereum/build/Product.json");

const provider = new HDWalletProvider(
  "YOUR_MNEMONIC",
  "YOUR_INFURA_URL"
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log("Attempting to deploy in account ", accounts[1]);

  const result = await new web3.eth.Contract(abi)
    .deploy({ data: evm.bytecode.object, arguments: [accounts[0]] })
    .send({ gas: "10000000", from: accounts[1] });

  console.log(JSON.stringify(abi));
  console.log("Contract deployed to ", result.options.address);
  provider.engine.stop();
};

deploy();
