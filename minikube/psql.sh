#!/bin/sh

# connect to the database from outside the cluster
psql --host=$(minikube ip) \
     --port=$(minikube service postgres --url --format={{.Port}}) \
     --username=postgres \
     --dbname=postgres
