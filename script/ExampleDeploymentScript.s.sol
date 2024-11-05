// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.27;

import "forge-std/console.sol";
import {DeploymentReaderScript, DeploymentWriterScript} from "../src/DeploymentScript.sol";

contract HelloWorld {
    function say() external pure returns (string memory) {
        return "Hello, world!";
    }
}

contract ExampleDeploymentReaderScript is DeploymentReaderScript {
    function run() external {
        loadDeployment();
        console.log(HelloWorld(getContract("HelloWorld")).say());
    }
}

contract ExampleDeploymentWriterScript is DeploymentWriterScript {
    function run() external {
        vm.startBroadcast();
        addContract("HelloWorld", address(new HelloWorld()));
        vm.stopBroadcast();
        storeDeployment();
    }
}
