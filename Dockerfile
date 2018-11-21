FROM golang:1.11-alpine

# Set up OS envrinment.
RUN apk update \
    && apk add git \
    && apk add --no-cache make gcc musl-dev linux-headers \
    && apk add net-tools

# Set Go Env Variables.
ENV GOPATH=/root/gocode
ENV PATH=$PATH:$GOPATH/bin

# Expose Ports.
## LND RPC Port, REST Port, P2P Port.
EXPOSE 10009 8080 9735

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

# Get the LND project.
RUN git clone https://github.com/lightningnetwork/lnd.git \
    && cd lnd \
    && go get -u github.com/golang/dep/cmd/dep \
    && make && make install \
    && make btcd

# Set WORKDIR to root and run setup env variables.
WORKDIR /root
COPY ./scripts ./scripts

# Setup environment to run LND and BTCD.
CMD [ "./scripts/setup-env.sh" ]
