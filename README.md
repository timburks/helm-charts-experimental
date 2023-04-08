# Helm Charts

This repo contains Helm charts for the
[Apigee Registry API](https://github.com/apigee/registry) and related tools.

## Charts

The [charts](/charts) directory contains Helm charts for the parts of an API
Registry.

- [registry-server](/charts/registry-server) installs the Registry API gRPC
  service.

- [registry-gateway](/charts/registry-gateway) installs an Envoy proxy
  configured to provide grpc-web and grpc-transcoding support.

- [registry-viewer](/charts/registry-viewer) installs the
  [Registry Viewer](https://github.com/apigee/registry-viewer).

- [registry-controller](/charts/registry-controller) installs an instance of
  the `registry` tool configured to run as a
  [controller](https://github.com/apigee/registry/wiki/registry-resolve) with
  built-in support for running a small set of default linters and similar
  tools.

## Installation

Users familiar with Helm can install these charts directly and we also include
scripts supporting common environments.

### [minikube](/minikube)

This directory contains scripts for installing these charts in
[minikube](https://minikube.sigs.k8s.io/docs/). It starts a local installation
suitable for exploration.

- `minikube/SETUP.sh` will start minikube and install the charts. It should be
  run from the directory containing this README.
- `minikube/TEARDOWN.sh` will delete everything and stop minikube.
- `minikube/dash.sh` will open the Kubernetes dashboard in a local browser.
- `minikube/viewer.sh` will open the Registry Viewer in a local browser.
- `minikube/registry-config.sh` will configure the `registry` tool to work with
  the minikube installation.

### [microk8s](/microk8s)

This directory contains scripts for installing the charts in
[microk8s](https://microk8s.io/). This sets up a registry for more persistent
usage. We have used them to run the API Registry in a local "bare-metal"
cluster.

- `microk8s/SETUP.sh` will start minikube and install the charts. It should be
  run from the directory containing this README.
- `microk8s/TEARDOWN.sh` will delete everything and stop minikube.

Connections to the API and viewer use SSL, so two hostnames are required along
with an SSL certificate that can be used for both. These should be set as
environment variables.

```
export REGISTRY_HOST registry.example.com
export VIEWER_HOST apis.example.com
```

The `SETUP.sh` script also expects a file named `secret.yaml` at the root of
this repo. It should contain a YAML description of a Kubernetes secret named
`registry-tls` in the `registry` namespace. For example:

```
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: registry-tls
  namespace: registry
data:
  tls.crt: <base64-encoded certificate>
  tls.key: <base64-encoded key>
```

Alternately, this secret could be created from local credentials:

```
kubectl create secret tls registry-tls --namespace=registry --cert=fullchain.pem --key=privkey.pem
```

## Exploration

To directly call the registry server, expose the `registry-server` using one of
the following methods:

```
# expose the pod for local testing (your pod name will vary)
kubectl port-forward -n registry pods/registry-server-d67c558c8-g9rmz 8080:8080

# expose the deployment for local testing
kubectl port-forward -n registry deployments/registry-server 8080:8080

# expose the service for local testing
kubectl port-forward -n registry services/registry-server 8080:80
```

Since these commands run for the lifetime of the connection, change to a
different shell to call the API.

```
# first configure the registry tool
registry config configurations create helm
registry config set address localhost:8080
registry config set insecure true
registry config set location global

# verify the registry-server and its database connection
registry rpc admin get-storage --json
```

## PostgreSQL

The `registry-server` requires PostgreSQL, and the chart currently expects an
installation of the
[bitnami/postgresql](https://bitnami.com/stack/postgresql/helm) chart in the
`registry` namespace. Future chart revisions might support
[Cloud SQL](https://cloud.google.com/sql) and other database hosting services.

Quoting the `bitnami/postgresql` installation notes:

> PostgreSQL can be accessed via port 5432 on the following DNS names from within your cluster:

    data-postgresql.registry.svc.cluster.local - Read/Write connection

> To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace registry data-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

> To connect to your database run the following command:

    kubectl run data-postgresql-client --rm --tty -i --restart='Never' --namespace registry --image docker.io/bitnami/postgresql:15.2.0-debian-11-r14 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host data-postgresql -U postgres -d postgres -p 5432

    > NOTE: If you access the container using bash, make sure that you execute "/opt/bitnami/scripts/postgresql/entrypoint.sh /bin/bash" in order to avoid the error "psql: local user with ID 1001} does not exist"

> To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace registry svc/data-postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432

> WARNING: The configured password will be ignored on new installation in case when previous Posgresql release was deleted through the helm command. In that case, old PVC will have an old password, and setting it through helm won't take effect. Deleting persistent volumes (PVs) will solve the issue.

## Resources

- https://helm.sh/docs/howto/chart_repository_sync_example/
- https://opensource.com/article/20/5/helm-charts
- https://docs.vmware.com/en/VMware-Application-Catalog/services/tutorials/GUID-create-first-helm-chart-index.html

## License and Copyright

Contents are copyrighted and licensed identically to the contents of
[apigee/registry-experimental](https://github.com/apigee/registry-experimentally).
This repo is intended to be merged into `registry-experimental`.
