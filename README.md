# Helm Charts

This repo contains experimental Helm charts.

It is an effort to create charts for the [Apigee Registry API](https://github.com/apigee/registry) and related tools.

## Contents

This is aspirational, but here's a rough sketch of what I hope to include:

### postgres

A PostgreSQL server for use by a registry, probably just reusing an existing chart like [bitnami/postgresql](https://bitnami.com/stack/postgresql/helm) (This may move into the dependencies of `registry-server`).

### registry-server

The Registry API gRPC service.

### registry-gateway-noauth

An Envoy proxy configured to provide grpc-web and grpc-transcoding support.

### registry-gateway-auth

An Envoy proxy configured to provide grpc-web and grpc-transcoding support with simple authz provided by a lightweight filter running alongside envoy.

### registry-viewer

The [Registry Viewer](https://github.com/apigee/registry-viewer).

### registry-controller

An instance of the `registry` tool configured to run as a [controller](https://github.com/apigee/registry/wiki/registry-resolve) with built-in support for running a small set of default linters and similar tools.

## Resources

- https://helm.sh/docs/howto/chart_repository_sync_example/
- https://opensource.com/article/20/5/helm-charts

## License and Copyright

Contents are copyrighted and licensed identically to the contents of [apigee/registry-experimental](https://github.com/apigee/registry-experimentally). This repo may eventually be merged into `registry-experimental`.
