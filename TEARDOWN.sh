#!/bin/sh

# This is for my local cluster, which is using microk8s and Helm3.
# Everything is installing to a "registry" namespace.
# YMMV.

helm uninstall -n registry registry-controller
helm uninstall -n registry registry-viewer
helm uninstall -n registry registry-gateway-noauth
helm uninstall -n registry registry-server
helm uninstall -n registry data

kubectl delete secrets/registry-tls -n registry
kubectl delete pvc/data-data-postgresql-0 -n registry

