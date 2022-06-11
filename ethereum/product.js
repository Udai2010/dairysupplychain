import web3 from "./web3";
const { abi, evm } = require("../ethereum/build/Product.json");

const instances = new web3.eth.Contract(
    abi,
    '0xEfFCfFf253FfEFBa9360FB1ECfA04c6ef36099cb'
);

export default instances;