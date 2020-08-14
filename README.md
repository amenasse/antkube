# AntKube

Artifacts for my personal Kubernetes cluster.

# Architecture

Plan is to run on a small self hosted Rasberry Pi cluster.

Routing to services from outside the cluster is performed using [Traefik][Traefik] deployed as an ingress controller. This is automatically deployed by k3 as an Auto-Deploying Manifest.

# Getting Started

k3s is currently manually curl installed as per the docs. [Ephemeral Containers][Ephemeral] feature gate is enabled to aid debugging Pods.  The script configures a systemd service which will start on boot.

```
curl -Ls https://get.k3s.io | INSTALL_K3S_EXEC="--kube-apiserver-arg=feature-gates=EphemeralContainers=true" sh -
```

Plan is to eventually be installed as part of the OS images cloud-init script or baked into the image.

# TLS

Currently using self signed cert for development purposes.

1) Generated using:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certs/dev.crt -out certs/dev.crt -subj "/CN=*.dev.fullbacksystems.com/O=Fullback Systems"
```


openssl x509 -in hello-dev.crt -text

2) Store the Certs as a secret:

  kubectl create secret tls dev-cert --key=certs/dev.pem --cert=certs/dev.crt


# Applications

## Hello World

https://hello.dev.fullbacksystems.com

## Fullback Systems Website

The Fullback Systems website (https://fullbacksystems.com) is deployed for development / staging purposes.

https://website.dev.fullbacksystems.com



## Docker Registry

https://registry.dev.fullbacksystems.com

As an experiment Docker registry is installed using Helm:

  helm [install|upgrade] -f helm/docker-registry.yml  docker-registry stable/docker-registry

Registry is hosted at registry.dev.fullbacksystems.com

Since the Cert is self signed the local Docker Daemon needs to be configured to trust the cert (https://docs.docker.com/registry/insecure/#use-self-signed-certificates). If using podman  you just need to add the cert to the OS to trust the cert:

    sudo cp certs/dev.fullbacksystems.com.crt /usr/local/share/ca-certificates/dev.fullbacksystems.com.crt
    sudo update-ca-certificates 


A filesystem mounted on the Node (/mnt/docker-registry/<disk-uuid>) is used for storage. This is represented on the Kubernetes side by a PersistentVolume using the StorageClass of 'docker-registry'. This is currently created manually (static provisioning). A PersistentVolumeClaim matching this StorageClass is used as the Pods Volume.

[Traefik]: https://rancher.com/docs/k3s/latest/en/networking/#traefik-ingress-controller
[Ephemeral]: https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#ephemeral-container
