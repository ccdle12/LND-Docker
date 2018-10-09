# LND Docker
A project that will run an LND Node and BTCD Node using Docker.

## Background
This project is an LND deployment for my own LND fork. This is for me to quickly spin up LND Nodes and experiment with my own breaking changes. This version of LND may not be up to date or may have breaking changes USE AT YOUR OWN RISK.

If you would like to use this repository with the official LND project, replace the following in the `Dockerfile` with the following:

```
# NOTE: this is my fork, it may not be up to date or may have breaking changes.
# Replace the github address with the official address.
# USE AT YOUR OWN RISK
RUN git clone https://github.com/lightningnetwork/lnd \
    && cd lnd \
    && go get -u github.com/golang/dep/cmd/dep \
    && make && make install \
    && make btcd
```


## Setup

### 1. Clone the github project

```
$ git clone https://github.com/ccdle12/LND-Docker
```

### 2. Setup .env

Rename `.env.example` to `.env`.

Add values to the environment variables:

`DATADIR_MNT` can be left blank and will use the default path.
If you are mounting the blockchain data, specify the absolute path.

```
# BTCD
BTCD_RPCUSER=kek
BTCD_RPCPASS=kek

# Data Directory Mount Path
DATADIR_MNT=/mnt/datadir
```

### 3. Setup lnd.conf

Rename `lnd.conf.example` to `.lnd.conf`.

The variables that needs to be changed are `externalip` and `alias`:

```
# LND Node Settings
debuglevel=info
listen=0.0.0.0:9735
externalip=123.45.67.89
alias=kek
color=#FF8106
maxpendingchannels=5

# Bitcoin Node Settings
bitcoin.testnet=1
bitcoin.active=1
bitcoin.node=btcd
btcd.rpcuser=$BTCD_RPCUSER
btcd.rpcpass=$BTCD_RPCPASS

# RPC and Rest Ports
rpclisten=0.0.0.0:10009
restlisten=0.0.0.0:8080
```

### 4. Run the Dockerfile

```
$ ./run-docker.sh
```

### 5. Attach into LND Container

```
$ ./attach-lnd.sh
```

### 6. Create a wallet

```
$ lncli create
```

### 7. Check LND Node

```
$ lncli getinfo
```

## Updating the Node

```
$ ./update.sh
```
