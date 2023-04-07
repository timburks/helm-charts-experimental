#!/bin/sh

# This is for my local cluster, which is using microk8s and Helm3.
# Everything is installing to a "registry" namespace.
# YMMV.

# Install the TLS certificate for the registry service host.
kubectl apply -f secret.yaml --namespace registry

# Install postgres with the bitnami chart.
microk8s helm3 install --namespace registry data bitnami/postgresql

# Install the registry-server with a local chart.
microk8s helm3 install --namespace registry registry-server registry-server

# Install registry-gateway-noauth with a local chart.
microk8s helm3 install --namespace registry registry-gateway-noauth registry-gateway-noauth --set ingress.host=${REGISTRY_HOST}
