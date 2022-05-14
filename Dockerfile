# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y g++

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libtre-dev

## Add source code to the build stage.
ADD . /Scalpel-2.0
WORKDIR /Scalpel-2.0

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN ./configure
RUN make

#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /Scalpel-2.0/src/scalpel /
COPY --from=builder /usr/lib/x86_64-linux-gnu/libtre.so /usr/lib/x86_64-linux-gnu/libtre.so
COPY --from=builder /usr/lib/x86_64-linux-gnu/libtre.so.5 /usr/lib/x86_64-linux-gnu/libtre.so.5
