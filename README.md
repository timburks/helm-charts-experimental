# Helm Charts

This repo contains Helm charts for the
[Apigee Registry API](https://github.com/apigee/registry) and related tools.

## Charts

The `charts` directory contains Helm charts for the parts of an API Registry.

### registry-server

The Registry API gRPC service.

### registry-gateway

An Envoy proxy configured to provide grpc-web and grpc-transcoding support.

### registry-viewer

The [Registry Viewer](https://github.com/apigee/registry-viewer).

### registry-controller

An instance of the `registry` tool configured to run as a
[controller](https://github.com/apigee/registry/wiki/registry-resolve) with
built-in support for running a small set of default linters and similar tools.

## Usage

### The `minikube` directory contains scripts for installing these charts in minikube.

This starts a local installation suitable for exploration.

- `minikube/SETUP.sh` will start minikube and install the charts.
- `minikube/TEARDOWN.sh` will delete everything and stop minikube.
- `minikube/dash.sh` will open the Kubernetes dashboard in a local browser.
- `minikube/viewer.sh` will open the Registry Viewer in a local browser.
- `minikube/registry-config.sh` will configure the `registry` tool to work with
  the minikube installation.

### The `microk8s` directory contains scripts for installing these charts in microk8s.

This sets up a registry for more persistent usage. They have been used with
[microk8s](https://microk8s.io/), which we use to run the API Registry in a
local "bare-metal" cluster.

- `minikube/SETUP.sh` will start minikube and install the charts.
- `minikube/TEARDOWN.sh` will delete everything and stop minikube.

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

## Resources

- https://helm.sh/docs/howto/chart_repository_sync_example/
- https://opensource.com/article/20/5/helm-charts
- https://docs.vmware.com/en/VMware-Application-Catalog/services/tutorials/GUID-create-first-helm-chart-index.html

## License and Copyright

Contents are copyrighted and licensed identically to the contents of
[apigee/registry-experimental](https://github.com/apigee/registry-experimentally).
This repo may eventually be merged into `registry-experimental`.
