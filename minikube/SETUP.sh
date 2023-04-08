#!/bin/sh

#
# install everything to a local minikube instance
#

minikube start

helm install -n registry data bitnami/postgresql

helm install -n registry registry-server charts/registry-server
helm install -n registry registry-gateway-noauth charts/registry-gateway-noauth --set service.type=NodePort

export REGISTRY_URL=`minikube service registry-gateway-noauth --url -n registry`

echo waiting for service deployments
kubectl wait deployments --all --for condition=available --timeout=180s -n registry

helm install -n registry registry-viewer charts/registry-viewer --set registry.url=${REGISTRY_URL} --set service.type=NodePort
helm install -n registry registry-controller charts/registry-controller --set registry.project=menagerie

# run the viewer
minikube service registry-viewer -n registry
