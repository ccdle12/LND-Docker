FROM ubuntu:latest

# Set up OS envrinment.
RUN apt-get update \
    && apt-get -y upgrade \
    && apt install make \
    && apt-get install git -y \
    && apt-get install golang-1.10-go -y \
    && ln -s /usr/lib/go-1.10/bin/go /usr/local/bin/go

# Set Go Env Variables.
ENV GOPATH=/root/gocode
ENV PATH=$PATH:$GOPATH/bin

# Expose Ports.
## LND RPC Port, REST Port.
EXPOSE 10009 8080

## BTCD Ports.
EXPOSE 8334 8337

# Copy btcd.conf.
WORKDIR /root/.btcd
COPY ./configs/btcd.conf ./btcd.conf

# Copy lnd.conf.
WORKDIR /root/.lnd
COPY ./configs/lnd.conf ./lnd.conf

# Set lightning network directory.
WORKDIR /root/gocode/src/github.com/lightningnetwork

# NOTE: this is my fork, it may not be up to date or may have breaking changes.
# Replace the github address with the official address.
# USE AT YOUR OWN RISK
RUN git clone https://github.com/ccdle12/lnd.git \
    && cd lnd \
    && go get -u github.com/golang/dep/cmd/dep \
    && make && make install \
    && make btcd

# Set WORKDIR to root and run setup env variables.
WORKDIR /root
COPY ./scripts ./scripts

# Setup environment to run LND and BTCD.
CMD [ "./scripts/setup-env.sh" ]
