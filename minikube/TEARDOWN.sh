#!/bin/sh


helm uninstall -n registry registry-controller
helm uninstall -n registry registry-viewer
helm uninstall -n registry registry-gateway
helm uninstall -n registry registry-server
helm uninstall -n registry data

kubectl delete pvc/data-data-postgresql-0 -n registry
