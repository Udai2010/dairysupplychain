const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname,'build');
fs.removeSync(buildPath);

const productPath = path.resolve(__dirname,'contracts','products.sol');
const source = fs.readFileSync(productPath,'utf8');

const input = {
    language: 'Solidity',
    sources: {
        'products.sol':{
            content: source,
        },
    },
    settings: {
        outputSelection: {
            '*':{
                '*':['*']
            },
        },
    },
};

const output = JSON.parse(solc.compile(JSON.stringify(input))).contracts['products.sol'];

fs.ensureDirSync(buildPath);

for (let contract in output){
    fs.outputJsonSync(
        path.resolve(buildPath, contract + '.json'),
        output[contract]
    );
}