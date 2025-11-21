# List Critical Services

## CDK

Generate the list of critical Polygon CDK services.

> File outputs are based on the results of the kurtosis-cdk CI at commit [6168ba5](https://github.com/0xPolygon/kurtosis-cdk/commit/6168ba5717a26b8bc88e4da399cef1cb2865d6e4).

```bash
export LOG_LEVEL="error"
pushd cdk > /dev/null
echo '{}' > critical_services.json
for file in *.txt;do
  base_name=$(basename "$file" .txt)
  services=$(./list_critical_services.sh "$file")
  jq --arg env "$base_name" --argjson services "$services" '. + {($env): $services}' critical_services.json > tmp.json
  mv tmp.json critical_services.json
done
popd > /dev/null
jq . cdk/critical_services.json
```

This will create a `critical_services.json` file, in the `cdk/` folder, with the critical services for each environment.

We can determine patterns to target all the critical services:
- `aggkit*`
- `agglayer*`
- `cdk-erigon*`
- `cdk-node*`
- `op-succinct-proposer*`
- `postgres*`
- `zkevm*`

## PoS

Same thing for critical Polygon PoS services.

> Based on commit [14a86f4](https://github.com/0xPolygon/kurtosis-pos/commit/14a86f4f7b453cd73ff845e37f5b179c44e704ef).

```bash
export LOG_LEVEL="error"
pushd pos > /dev/null
echo '{}' > critical_services.json
for file in *.txt;do
  base_name=$(basename "$file" .txt)
  services=$(./list_critical_services.sh "$file")
  jq --arg env "$base_name" --argjson services "$services" '. + {($env): $services}' critical_services.json > tmp.json
  mv tmp.json critical_services.json
done
popd > /dev/null
jq . pos/critical_services.json
```

We can determine patterns to target all the critical services:
- `l2-cl*` - L2 consensus layer services
- `l2-el*` - L2 execution layer services
- `rabbitmq-l2-cl*` - RabbitMQ messaging services
