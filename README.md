# AntKube

Artifacts for my personal Kubernetes cluster.

# Architecture

Currently being developed on Minikube, plan is to move to small self hosted Rasberry Pi cluster.

Routing to services is performed using the Kubernetes ingress-nginx Controller (not to be confused with the Nginx Ingress Controller for Kubernetes !). For now this is installed as a minikube addon which should be enabled by default.

# Getting Started

  minikube start --vm-driver=virtualbox


# TODO

- [ ] Frontend Load Balancing (MetalLB ?)
- [X] TLS
- [X] tutum/hello-world
- [ ] Fullback systems website

# TLS

Currently using self signed cert for development purposes.

1) Generated using:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout hello-dev.pem -out hello-dev.crt -subj "/CN=*.dev.fullbacksystems.com/O=Fullback Systems"
```
TODO: Add an Alt name for dev.fullbacksystems.com for the cert


openssl x509 -in hello-dev.crt -text

2) Store the Certs as a secret:

  kubectl create secret tls hello-dev --key hello-dev.pem --cert hello-dev.crt

# Applications

## Hello World


Usage:

  curl -k  -v --resolve hello.dev.fullbacksystems.com:443:192.168.99.101  https://hello.dev.fullbacksystems.com/

