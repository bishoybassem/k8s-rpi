#!/bin/bash

ARCH=arm
ETCD_VERSION=3.2.25
FLANNEL_VERSION=0.10.0
KUBERNETES_VERSION=1.12.3

CURRENT_PATH=$(pwd)

TEMP_DIR=$(mktemp -d)
mkdir -p ${CURRENT_PATH}/roles/etcd/files/downloads
cd ${CURRENT_PATH}/roles/etcd/files/downloads
docker run --interactive -v ${TEMP_DIR}:/etcdbin golang:1.8.7 /bin/bash -c \
	"git clone https://github.com/coreos/etcd /go/src/github.com/coreos/etcd \
	&& cd /go/src/github.com/coreos/etcd \
	&& git checkout v${ETCD_VERSION} \
	&& GOARM=7 GOARCH=${ARCH} ./build \
	&& cp -f bin/etcd* /etcdbin; echo 'done'"
cp $TEMP_DIR/etcd .
cp $TEMP_DIR/etcdctl .

mkdir -p ${CURRENT_PATH}/roles/flannel/files/downloads
cd ${CURRENT_PATH}/roles/flannel/files/downloads
wget "https://github.com/coreos/flannel/releases/download/v${FLANNEL_VERSION}/flanneld-${ARCH}" -O flanneld

mkdir -p ${CURRENT_PATH}/roles/kube-node/files/downloads
cd ${CURRENT_PATH}/roles/kube-node/files/downloads
wget "https://dl.k8s.io/v${KUBERNETES_VERSION}/kubernetes-server-linux-${ARCH}.tar.gz" -O kubernetes-server.tar.gz
tar -xf kubernetes-server.tar.gz --wildcards "*hyperkube"
find . -name hyperkube | xargs -i mv {} .
rm -rf kubernetes*

mkdir -p ${CURRENT_PATH}/roles/kube-master/files/downloads
cd ${CURRENT_PATH}/roles/kube-master/files/downloads
wget "https://dl.k8s.io/v${KUBERNETES_VERSION}/kubernetes-client-linux-${ARCH}.tar.gz" -O kubernetes-client.tar.gz
tar -xf kubernetes-client.tar.gz --wildcards "*kubectl"
find . -name kubectl | xargs -i mv {} .
rm -rf kubernetes*