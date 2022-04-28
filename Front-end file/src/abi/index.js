import Creator from "./data/Creator.json"
import MultiSign from "./data/MultiSign.json"

const CONTRACTS = {
    Creator:{address:"0xd6BC386d072e04f2119f1Bca3bB6F61E6B0920D7",abi:Creator},
    MultiSign:{abi:MultiSign},
};

function getContractByName(name, web3) {
    return new web3.eth.Contract(CONTRACTS[name].abi, CONTRACTS[name].address, {});
}

function getContractByToken(name, address, web3) {
    return new web3.eth.Contract(CONTRACTS[name].abi, address, {});
}

function getContractAddress(name) {
    return CONTRACTS[name].address;
}

export default {
    CONTRACTS,
    getContractByName,
    getContractByToken,
    getContractAddress
};
