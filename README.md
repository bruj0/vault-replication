- [What](#what)
  - [Infrastructure](#infrastructure)
    - [Docker-compose](#docker-compose)
      - [Integrated Storage](#integrated-storage)
        - [Regions](#regions)
        - [Zones](#zones)
          - [Region A](#region-a)
          - [Region B](#region-b)
          - [Region C](#region-c)
      - [Consul](#consul)
        - [Regions](#regions-1)
        - [Zones](#zones-1)
- [Why](#why)
- [How](#how)
  - [Requirements](#requirements)
  - [Networks](#networks)
    - [Communication between Regions](#communication-between-regions)
  - [Initial configuration](#initial-configuration)
    - [Install yapi](#install-yapi)
    - [Docker Infrastructure](#docker-infrastructure)
      - [Primary Cluster](#primary-cluster)
      - [Secondary Cluster](#secondary-cluster)
      - [DR Cluster](#dr-cluster)
    - [Docker Operations](#docker-operations)
      - [Integrated Storage](#integrated-storage-1)
      - [Docker Consul](#docker-consul)
      - [Replication](#replication)
  - [Check that replication is up](#check-that-replication-is-up)
    - [Commands supported](#commands-supported)
  - [How `dc.sh` works](#how-dcsh-works)
  - [How to manually configure performance replication](#how-to-manually-configure-performance-replication)
    - [View the full compose template for a given cluster](#view-the-full-compose-template-for-a-given-cluster)
    - [Initialization of Vault](#initialization-of-vault)
    - [Unsealing](#unsealing)
  - [Troubleshooting](#troubleshooting)
  - [Useful commands](#useful-commands)
  - [Exposed ports: local -> container](#exposed-ports-local---container)
    - [Primary](#primary)
    - [Secondary (DR primary)](#secondary-dr-primary)
    - [DR Secondary](#dr-secondary)
    - [Proxy](#proxy)
- [TODO](#todo)
- [Done](#done)
# What
A way to create multiple Vault clusters and setup different types of Replication between them as close as possible to the "Vault reference architecture" https://learn.hashicorp.com/vault/operations/ops-reference-architecture

## Infrastructure
### Docker-compose
#### Integrated Storage
##### Regions

Using the 3 Region setup architecture:

![3 regions](https://d33wubrfki0l68.cloudfront.net/f4320f807477cdda5df25f904eaf3d7c9cfd761d/e6047/static/img/vault-ra-full-replication_no_region.png)
  
They can only communicate between regions using a `proxy` (sometimes incorrectly called Load Balancer) in this case `HAProxy`.
- Region 1 contains the `Primary` Vault cluster, configured following the [Deployment Guide](https://learn.hashicorp.com/vault/day-one/ops-deployment-guide)  
- Region 2 contains the `Secondary` Vault cluster, configured as [Performance Replication](https://learn.hashicorp.com/vault/operations/ops-replication)
- Region 3 will contain a `DR` Vault cluster configured as [Disaster Recovery](https://learn.hashicorp.com/vault/operations/ops-disaster-recovery)
  
##### Zones 

Each `Region` is composed of 3  networks (zones A,B,C) and has a set of Vault nodes.

![3 Zones](Vault-Integrated-RA-3_AZ.png)

###### Region A
* vault_primaryA
* vault_primaryB
* vault_primaryC
  
###### Region B
* vault_secondaryA
* vault_secondaryB
* vault_secondaryC
###### Region C
* vault_drA
* vault_drB
* vault_drC
  
#### Consul
##### Regions
The regions are the same as in Integrated Storage but only one network per Zone.

* vault_primary
* vault_secondary
* vault_dr
  
##### Zones
![1 zone](vault-ra-1-az.png)

# Why 
To be able to easily setup and test different configuration and features of a full fledge Vault and Consul cluster setup.

# How 

## Requirements 
* Docker 
* Docker-compose:
  *  Scheduling of containers
  *  Overlaying of configuration to avoid duplication
* [Yapi-ci](https://github.com/bruj0/yapi)
  * Initialization
  * API management
* Access to Premium or Pro version of Vault
* `vault` and `jq` binaries installed in the $PATH
      
To talk to Vault we will use `Yapi-ci`, this is a yaml file where we define how the API call will look like.

## Networks

### Communication between Regions

It uses an HAProxy instance in TCP mode by accessing the IP trough consul SRV DNS record but this can be changed to any type of service discovery supported by HAProxy.

(The Load Balancer in this diagram)
![proxy](https://d33wubrfki0l68.cloudfront.net/b2d787641bf2dda0a8a1abf691cd9723a9c0ed8c/7b419/static/img/vault-ref-arch-9.png)


## Initial configuration
### Install yapi

```bash
$ pip install -U yapi-ci
$ yapi --version
0.1.6
```
### Docker Infrastructure 
- Set Storage to use
```bash
$ export STORAGE=raft
```
- Create the docker networks
```bash
$ infra/docker/networks.sh
```
#### Primary Cluster
```bash
$ infra/docker/p up
```
#### Secondary Cluster
```bash
$ infra/docker/s up
```
#### DR Cluster
```bash
$ infra/docker/dr up
```

### Docker Operations
#### Integrated Storage
* Init unsealer
```bash
$ ops/p init_unsealer
```
* Unseal unsealer and wait 3 seconds
```bash
$ ops/p unseal_unsealer
$ wait 3
```
* Configure unsealer Vault instance
```bash
$ ops/p config_unsealer
```
* Restart Vault nodes
```bash
$ infra/docker/p restart
```
* Init vault01
```bash
$ ops/p init_recovery
```
* Check status of Node 01
```bash
$ ops/p 1 status
```
* Join nodes 01 and 02
```bash
$ ops/p 2 operator raft join http://primary_vault01_1:820
Using storage: raft
VAULT_ADDR=http://127.0.0.1:9302
Key       Value
---       -----
Joined    true
$ ops/p 3 operator raft join http://primary_vault01_1:8200
Using storage: raft
VAULT_ADDR=http://127.0.0.1:9303
Key       Value
---       -----
Joined    true

```
* Check raft status
```bash
$ ops/p 1 operator raft list-peers
Node       Address                   State       Voter
----       -------                   -----       -----
vault01    primary_vault01_1:8201    leader      true
vault02    primary_vault02_1:8201    follower    true
vault03    primary_vault03_1:8201    follower    true
```
#### Docker Consul
TODO

#### Replication

## Check that replication is up
```bash
$ env CLUSTER=primary ./dc.sh cli vault read sys/replication/performance/status
Key                     Value
---                     -----
cluster_id              2cc7aad6-026a-9620-6f0d-1e8fa939a11e
known_secondaries       [secondary]
last_reindex_epoch      0
last_wal                247
merkle_root             d85e48c2ec44b1e6ba6671773ea26d836b64ed09
mode                    primary
primary_cluster_addr    https://172.25.0.2:8201
state                   running

$ env CLUSTER=secondary ./dc.sh cli vault read sys/replication/performance/status
Key                            Value
---                            -----
cluster_id                     2cc7aad6-026a-9620-6f0d-1e8fa939a11e
known_primary_cluster_addrs    [https://172.24.0.8:8201 https://172.24.0.9:8201 https://172.24.0.10:8201]
last_reindex_epoch             1574351423
last_remote_wal                0
merkle_root                    d85e48c2ec44b1e6ba6671773ea26d836b64ed09
mode                           secondary
primary_cluster_addr           https://172.25.0.2:8201
secondary_id                   secondary
state                          stream-wals
```

### Commands supported
All the commands read the `CLUSTER` variable to determine where is the operation going to run on.

Example:
```bash
$ env CLUSTER=primary ./dc.sh cli vars                                                                                        Exporting variables for primary
export VAULT_ADDR="http://127.0.0.1:9201"
export VAULT_DATA="./vault/api"
export VAULT_TOKEN="s.YFfiUgyPCZAtJIQ55NtvVa2K"
```
- `help` : This help
- `config`: Will execute `docker-compose config` with the proper templates 
- `up`: This will start the Vault and Consul cluster up for the specified type of cluster by doing a `docker-compose up -d`

- `down`: It will do a `docker-compose down` with the correct template

- `wipe`: Will wipe ALL the consul data files, make sure to do it after `down`

- `restart`
  - vault
  - consul
  - proxy

- `cli`: This will set the variables `VAULT_TOKEN` from `vault/api/init.json` and `VAULT_ADDR` to the port of the first node of the selected cluster.
  - `vars`: Prints variables for the given cluster 
  - `vault <command>`
  - `yapi <template file>[--debug]`

- `unseal`
  - replication: if this argument is given the primary unseal key will be used instead

- `proxy`
  - start

## How `dc.sh` works
*This is all automated with the `up` command and its here for documentation purposes.*

- Each cluster has its own directory:
  * Primary -> /
  * Secondary -> secondary
  * DR -> dr
- Each directory has this structure:
  - `consul`
    - `data`

This will contain the directories where each consul server will store its data:
`consul01 consul02 consul03`.

Each of this directories are mount at `/consul/data` inside the respective container

  - `config` : This is mounted inside the containers as /consul/config
  - `vault`
    - `config`: Mounted at `/vault/config` 
    - `api`: Where the response from the API is stored, ie unseal keys and root token
    - `logs`: Where the audit logs will be stored.

## How to manually configure performance replication

1. Set the correct environmental variables, you can get them from the output of this command.
```bash
$ env CLUSTER=primary ./dc.sh cli vars
Exporting variables for primary
export VAULT_ADDR="http://127.0.0.1:9201"
export VAULT_DATA="./vault/api"
export VAULT_TOKEN="s.YFfiUgyPCZAtJIQ55NtvVa2K"
```
2. Enable replication
  
`SECONDARY_HAPROXY_ADDR` is the IP of the network card in the `proxy` container that is connected to the network `vault_secondary`.

We need this IP so that the secondary cluster can contact the primary trough the proxy.

It will be configured as the `primary_cluster_addr` variable in Vault.

```bash
$ export SECONDARY_HAPROXY_ADDR=(docker network inspect vault_secondary | jq -r '.[] .Containers | with_entries(select(.value.Name=="haproxy"))| .[] .IPv4Address' | awk -F "/" '{print $1}')
$ CLUSTER=primary ./dc.sh cli yapi yapi/vault/03-replication_enable_primary.yaml
```
3. Check that the replication was configured correctly:

```json
$ CLUSTER=primary ./dc.sh cli vault read sys/replication/status -format=json
{
  "request_id": "c2e75241-9d82-7d32-41dc-f68998d58610",
  "lease_id": "",
  "lease_duration": 0,
  "renewable": false,
  "data": {
    "dr": {
      "mode": "disabled"
    },
    "performance": {
      "cluster_id": "2cc7aad6-026a-9620-6f0d-1e8fa939a11e",
      "known_secondaries": [
        "secondary"
      ],
      "last_reindex_epoch": "0",
      "last_wal": 63,
      "merkle_root": "ef70ddb8948f4dbbd90980f418195d30acddb0d2",
      "mode": "primary",
      "primary_cluster_addr": "https://172.25.0.2:8201",
      "state": "running"
    }
  },
  "warnings": null
}
```

4. Create secondary token
  
This will save the token to `vault/api/secondary-token.json` and create it with the `id=secondary`

```bash
$ CLUSTER=primary ./dc.sh cli yapi yapi/vault/04-replication_secondary_token.yaml
```

5. Enable replication on the secondary cluster

We dont use `cli yapi` because we are mixing the Vault address of the secondary with the data of the primary.

```bash
$ export VAULT_TOKEN=$(cat secondary/vault/api/init.json | jq -r '.root_token')
$ export VAULT_DATA="vault/api"
$ export VAULT_ADDR="http://127.0.0.1:9301"
$ yapi yapi/vault/05-replication_activate_secondary.yaml
```
This will save the response to `vault/api/enable-secondary-resp.json`

6. Check that the replication is working on the secondary

```json
$ env DEBUG=false CLUSTER=secondary ./dc.sh cli vault read sys/replication/status -format=json
{
  "request_id": "af4cd82c-9b57-0061-1fe1-09f06166bed7",
  "lease_id": "",
  "lease_duration": 0,
  "renewable": false,
  "data": {
    "dr": {
      "mode": "disabled"
    },
    "performance": {
      "cluster_id": "2cc7aad6-026a-9620-6f0d-1e8fa939a11e",
      "known_primary_cluster_addrs": [
        "https://172.24.0.8:8201",
        "https://172.24.0.9:8201",
        "https://172.24.0.10:8201"
      ],
      "last_reindex_epoch": "1573144926",
      "last_remote_wal": 0,
      "merkle_root": "ef70ddb8948f4dbbd90980f418195d30acddb0d2",
      "mode": "secondary",
      "primary_cluster_addr": "https://172.25.0.2:8201",
      "secondary_id": "secondary",
      "state": "stream-wals"
    }
  },
  "warnings": null
}
```

### View the full compose template for a given cluster
```bash
$ export CLUSTER=primary|secondary|dr
$ export VAULT_CLUSTER=${CLUSTER}
$ export CONSUL_CLUSTER=${CLUSTER}
$ export COMPOSE_PROJECT_NAME=${CLUSTER}
$ docker-compose -f docker-compose.${CLUSTER}.yml -f docker-compose.yml up -d 
```

### Initialization of Vault
This will save the unseal keys and root token under the directory ```$CLUSTER_DIR}/vault/api```  as json files.

```bash
$ export VAULT_ADDR=http://127.0.0.1:XXXX
$ export VAULT_data=$CLUSTER_DIR}/vault/api
$ yapi yapi/vault/01-init.yaml
```

### Unsealing
```bash
$ export VAULT_ADDR=http://127.0.0.1:XXXX
$ export VAULT_data=$CLUSTER_DIR}/vault/api
$ yapi yapi/vault/02-unseal.yaml
```
## Troubleshooting

- Make sure the consul cluster is up and running:
```bash
$ CONSUL_HTTP_ADDR=http://127.0.0.1:8500 consul members
$ CONSUL_HTTP_ADDR=http://127.0.0.1:8500 consul operator raft list-peers
$ docker logs -f primary_consul_server_bootstrap_1
```
- Check `haproxy` logs
```bash
$ docker logs -f haproxy
```

## Useful commands

* How to use set the correct VAULT_TOKEN

```bash
$ export VAULT_TOKEN=(cat $CLUSTER_DIR}/vault/api/init.json | jq -r '.root_token')
```

* How to get the network IP of a container

```bash
$ docker network inspect vault_${CLUSTER} | jq -r '.[] .Containers | with_entries(select(.value.Name=="CONTAINER_NAME"))| .[] .IPv4Address' | awk -F "/" '{print $1}'
```


## Exposed ports: local -> container
### Primary
- 8500 -> 8500 (Consul bootstrap server UI)
- 9201 -> 8200 (Vault01 API and UI)
- 9202 -> 8200 (Vault02 API and UI)
- 9203 -> 8200 (Vault03 API and UI)
- 9204 -> 9090 (Prometheus)
- 9205 -> 3000 (Grafana)
### Secondary (DR primary)
- 8502 -> 8500 (Consul bootstrap server UI)
- 9301 -> 8200 (Vault01 API and UI)
- 9302 -> 8200 (Vault02 API and UI)
- 9303 -> 8200 (Vault03 API and UI)
### DR Secondary
- 8503 -> 8500 (Consul bootstrap server UI)
- 9401 -> 8200 (Vault01 API and UI)
- 9402 -> 8200 (Vault01 API and UI)
- 9403 -> 8200 (Vault01 API and UI)
### Proxy
- 8801 -> 8200 ( Primary cluster, Active Vault node API )
- 8901 -> 8200 ( DR Primary, Secondary cluster, Active Vault node API)
- 8819 -> 1936 (HAProxy stats)

# TODO
- [ ] Docker image build documentation
- [ ] Configure Monitoring
- [ ] Generate PKI certificates and use them
- [ ] HSM auto unsealing

# Done
- [X] Add Vault container for PKI
- [X] Configure DR cluster
- [x] Initialization and Unsealing with `yapi`
- [X] Configure primary as Performance replication
- [X] Create replacement for Tavern
- [X] Better startup handling
