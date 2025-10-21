# Kurtosis Dependencies Issues

Kurtosis includes a feature to list the dependencies of a package, including images and packages it depends on. This POC demonstrates that some images are missing when listing dependencies for the [kurtosis-cdk](https://github.com/0xPolygon/kurtosis-cdk) package.

## Steps to reproduce

For the purpose of this PoC, we will use the latest version of the kurtosis-cdk package ([v0.5.6](https://github.com/0xPolygon/kurtosis-cdk/releases/tag/v0.5.6)).

First, list the dependencies of the package:

```bash
kurtosis run --dependencies github.com/0xPolygon/kurtosis-cdk@v0.5.6
```

Truncated output containing only the image dependencies:

```bash
badouralix/curl-jq
ethereum/client-go:v1.16.5
ethpandaops/ethereum-genesis-generator:5.1.0
europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/agglayer-contracts:v0.0.0-rc.3.aggchain.multisig
europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/agglayer-dashboard:v4fixed
europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/agglogger:bf1f8c1
europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/op-deployer:v0.4.3-cdk
europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/toolbox:0.0.12
ghcr.io/0xpolygon/zkevm-bridge-service:v0.6.2-RC5
ghcr.io/agglayer/aggkit-prover:1.5.0
ghcr.io/agglayer/agglayer:0.4.0-rc.12
ghcr.io/agglayer/e2e:7c0d950
mslipper/deployment-utils@sha256:4506b112e4261014329152b161997129e7ca577f39c85e59cfdfdcb47ab7b5cf
postgres:16.2
protolambda/eth2-val-tools:latest
sigp/lighthouse:v8.0.0-rc.1
us-docker.pkg.dev/oplabs-tools-artifacts/images/op-batcher:v1.16.0
us-docker.pkg.dev/oplabs-tools-artifacts/images/op-geth:v1.101603.1
us-docker.pkg.dev/oplabs-tools-artifacts/images/op-node:v1.14.1
us-docker.pkg.dev/oplabs-tools-artifacts/images/op-proposer:v1.10.0
us-docker.pkg.dev/oplabs-tools-artifacts/images/proxyd:v4.14.5
```

Here are the actual images used by `kurtosis run`:

```bash
Container images used in this run:
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/toolbox:0.0.12 - remotely downloaded
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/op-deployer:v0.4.3-cdk - remotely downloaded
> us-docker.pkg.dev/oplabs-tools-artifacts/images/op-proposer:v1.10.0 - remotely downloaded
> mslipper/deployment-utils@sha256:4506b112e4261014329152b161997129e7ca577f39c85e59cfdfdcb47ab7b5cf - remotely downloaded
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/virtual/postgres:16.2 - locally cached
> ghcr.io/agglayer/aggkit:0.7.0-beta8 - remotely downloaded
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/agglayer-dashboard:v4fixed - remotely downloaded
> ghcr.io/0xpolygon/zkevm-bridge-service:v0.6.2-RC5 - remotely downloaded
> us-docker.pkg.dev/oplabs-tools-artifacts/images/op-node:v1.14.1 - remotely downloaded
> protolambda/eth2-val-tools:latest - locally cached
> badouralix/curl-jq - locally cached
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/agglogger:bf1f8c1 - remotely downloaded
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/virtual/ethereum/client-go:v1.16.5 - locally cached
> us-docker.pkg.dev/oplabs-tools-artifacts/images/op-geth:v1.101603.1 - remotely downloaded
> ghcr.io/agglayer/e2e:7c0d950 - remotely downloaded
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/public/agglayer-contracts:v0.0.0-rc.3.aggchain.multisig - remotely downloaded
> ethpandaops/ethereum-genesis-generator:5.1.0 - remotely downloaded
> europe-west2-docker.pkg.dev/prj-polygonlabs-devtools-dev/virtual/sigp/lighthouse:v8.0.0-rc.1 - locally cached
> ghcr.io/agglayer/aggkit-prover:1.5.0 - remotely downloaded
> us-docker.pkg.dev/oplabs-tools-artifacts/images/op-batcher:v1.16.0 - remotely downloaded
> us-docker.pkg.dev/oplabs-tools-artifacts/images/proxyd:v4.14.5 - remotely downloaded
> ghcr.io/agglayer/agglayer:0.4.0-rc.12 - remotely downloaded
```

Source: <https://github.com/0xPolygon/kurtosis-cdk/actions/runs/18654332706/job/53179660542>

The dependency list is missing an image: `ghcr.io/agglayer/aggkit:0.7.0-beta8`.

## Diffs

I compared the dependencies listed by kurtosis against the actual images used during execution across different configurations we run in antithesis. The results are available as YAML artifacts in the current folder. These configurations are maintained in the [antithesis repository](https://github.com/0xPolygon/antithesis) (private - please reach out if you need access).

The analysis reveals that all missing images originate from the kurtosis-cdk package itself, not from downstream dependencies like ethereum-package or optimism-package. These images are typically deployed conditionally based on factors such as consensus contract type or deployment stage, as shown in the [main.star](https://github.com/0xPolygon/kurtosis-cdk/blob/main/main.star#L261-L283) implementation.
