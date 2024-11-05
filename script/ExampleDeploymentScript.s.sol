// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.27;

import "forge-std/console.sol";
import {DeploymentReaderScript, DeploymentWriterScript} from "../src/DeploymentScript.sol";

contract ExampleDeploymentReaderScript is DeploymentReaderScript {
    function setUp() external {
        loadDeployment();
    }

    function run() external view {
        console.log(getContract("Foo"));
    }
}

contract ExampleDeploymentWriterScript is DeploymentWriterScript {
    function run() external {
        addContract("Foo", address(this));
        storeDeployment();
    }
}
