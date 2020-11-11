FROM golang:1.13 AS builder

RUN git clone https://github.com/rakyll/hey.git
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
    go get -u github.com/rakyll/hey

FROM alpine

MAINTAINER edwin jay mendiguarin

ENV KUSTOMIZE_VERSION 3.8.6
ENV YQ_VERSION 3.1.1

COPY --from=builder /go/bin/hey /usr/local/bin

RUN apk update \
    && apk add --no-cache bash gawk sed grep bc coreutils \
    && apk add --no-cache curl \
    && apk add --no-cache wget \
    && apk add --no-cache git \
    && apk add --no-cache openssh-client
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin
RUN wget --content-disposition https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/kustomize \
    && rm kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
RUN wget --content-disposition https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
    && chmod +x ./yq_linux_amd64 \
    && mv ./yq_linux_amd64 /usr/local/bin/yq

CMD ["bash"]
