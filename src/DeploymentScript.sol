// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";

struct Contract {
    address addr;
    string name;
}

struct Deployment {
    Contract[] contracts;
}

string constant DEPLOYMENT_PATH = "deployment.json";

contract DeploymentReaderScript is Script {
    // State variables

    mapping(string => address) private _contractAddressByName;

    // Errors

    error CouldNotFindContractWithName(string name);
    error TriedToLoadContractWithTheSameName(string name);
    error ContractHasInvalidZeroAddress(string name);

    // Internal functions

    function loadDeployment() internal {
        string memory json = vm.readFile(DEPLOYMENT_PATH);
        bytes memory data = vm.parseJson(json);
        Deployment memory deployment = abi.decode(data, (Deployment));
        Contract[] memory contrs = deployment.contracts;
        for (uint256 i; i < contrs.length; ++i) {
            Contract memory contr = contrs[i];
            require(contr.addr != address(0), ContractHasInvalidZeroAddress(contr.name));
            address oldAddr = _contractAddressByName[contr.name];
            require(oldAddr == address(0), TriedToLoadContractWithTheSameName(contr.name));
            _contractAddressByName[contr.name] = contr.addr;
        }
    }

    function getContract(string memory name) internal view returns (address) {
        address addr = _contractAddressByName[name];
        require(addr != address(0), CouldNotFindContractWithName(name));
        return addr;
    }
}

contract DeploymentWriterScript is Script {
    // State variables

    Deployment private _deployment;
    mapping(string => bool) private _isNameTaken;

    // Errors

    error TriedToAddContractWithTheSameName(string name);
    error ContractHasInvalidZeroAddress(string name);

    // Internal functions

    function addContract(string memory name, address addr) internal {
        require(!_isNameTaken[name], TriedToAddContractWithTheSameName(name));
        require(addr != address(0), ContractHasInvalidZeroAddress(name));
        _deployment.contracts.push(Contract({name: name, addr: addr}));
        _isNameTaken[name] = true;
    }

    function storeDeployment() internal {
        // forgefmt: disable-start
        string memory json = vm.serializeJsonType(
            "Deployment(Contract[] contracts)"
            "Contract(address addr,string name)",
            abi.encode(_deployment)
        );
        // forgefmt: disable-end
        vm.writeJson(json, DEPLOYMENT_PATH);
    }
}
