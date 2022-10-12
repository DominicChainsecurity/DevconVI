# Secure DeFi smart contract development on Ethereum

## Setup

### Alchemy

* Go to [Alchemy](ttps://dashboard.alchemyapi.io/).
* Create an API key for Alchemy by creating a new app.

### Docker or install Foundry

For Docker:

``docker pull ghcr.io/foundry-rs/foundry:latest``

``docker run --rm -v $PWD:/shared/ -it --entrypoint /bin/sh ghcr.io/foundry-rs/foundry``

For [Foundry](https://github.com/foundry-rs/foundry):

``curl -L https://foundry.paradigm.xyz | bash``

and then restart your terminal and run ``foundryup``.

### Last Step

You should be able to run successfully the following command:

``forge test --fork-url https://eth-mainnet.alchemyapi.io/v2/<API_KEY> --match Fork``

## Foundry Cheatsheet

* ``vm.prank(address)``: execute the next call as an arbitrary address
* ``vm.startPrank(address)``
* ``vm.stopPrank()``

### Fuzzing

* ``function foo(fuzzedValue)``
* ``vm.assume(bool)``

### Mainnet fork

* ``forge test --fork-url https://eth-mainnet.alchemyapi.io/v2/<API_KEY> --match <test_name>``
