#!/bin/sh

# This is for my local cluster, which is using microk8s and Helm3.
# Everything is installing to a "registry" namespace.
# YMMV.

microk8s helm3 uninstall --namespace registry registry-gateway-noauth
microk8s helm3 uninstall --namespace registry registry-server
microk8s helm3 uninstall --namespace registry data

kubectl delete secrets/grpc-tls --namespace registry
kubectl delete pvc/data-data-postgresql-0 -n registry

