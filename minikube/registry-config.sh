#!/bin/sh

# configure the registry tool to work with the service running in minikube
rm -f ~/.config/registry/minikube
registry config configurations create minikube
registry config set address `minikube ip`:`minikube service -n registry registry-gateway-noauth --url --format={{.Port}}`
registry config set insecure true
registry config set location global

