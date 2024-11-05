# Forge deployment library

Check `script` for usage examples.

## Tests

1. Run `anvil`.

2. On another terminal, run the following command. It will deploy a contract and writes its name and address to `deployment.json`

```sh
forge script \
    --fork-url http://127.0.0.1:8545 \
    --broadcast \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    ExampleDeploymentWriterScript
```

3. You can take a peek at the `deployment.json` file if you want.

```json
{
  "contracts": [
    {
      "addr": "0x5FbDB2315678afecb367f032d93F642f64180aa3",
      "name": "HelloWorld"
    }
  ]
}
```

4. Now, run the following command, which will call the function `say()` on the `HelloWorld` contract.

```sh
forge script \
    --fork-url http://127.0.0.1:8545 \
    ExampleDeploymentReaderScript
```

5. You should see a "Hello, world!" in the logs!
