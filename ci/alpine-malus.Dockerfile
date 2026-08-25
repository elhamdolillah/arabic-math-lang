FROM python:3.12-alpine3.20@sha256:25849f9599e06dfe4d11b552e06f5ac4cc2ad342054eb81f7877e611f6f87c66

# Dependencies are installed while the image is built; the audit container
# itself runs with --network none so source analysis remains network-isolated.
RUN apk add --no-cache bash coreutils git

WORKDIR /work
