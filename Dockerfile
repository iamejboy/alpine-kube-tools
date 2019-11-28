FROM alpine

MAINTAINER edwin jay mendiguarin

ENV KUSTOMIZE_VERSION 3.4.0

RUN apk add --no-cache bash gawk sed grep bc coreutils
RUN apk update \
    && apk add --no-cache curl \
    && apk add wget
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin
RUN wget --content-disposition https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/kustomize \
    && rm kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

CMD ["bash"]
