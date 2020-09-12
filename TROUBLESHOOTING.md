# Problems Encountered and Solutions

## Persistent Volume Claim is not being bound to a released Volume

A Persistent Volume (PV) using the `Retain` reclaim policy will be released after the PersistentVolumeClaim (PVC) that's bound to it is deleted. Using this policy the data  on the underlying volume is retained when the PV is released. Once released the PV can't be claimed again and needs to be recreated.

From the docs:

> The Retain reclaim policy allows for manual reclamation of the resource. When the PersistentVolumeClaim is deleted, the PersistentVolume still exists and the volume is considered "released". But it is not yet available for another claim because the previous claimant's data remains on the volume. An administrator can manually reclaim the volume with the following steps.

>    1. Delete the PersistentVolume. The associated storage asset in external infrastructure (such as an AWS EBS, GCE PD, Azure Disk, or Cinder volume) still exists after the PV is deleted.
>    2. Manually clean up the data on the associated storage asset accordingly.
>    3. Manually delete the associated storage asset, or if you want to reuse the same storage asset, create a new PersistentVolume with the storage asset definition.
https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes


## Traefik Ingress Controller can't configure TLS due to missing cert secret

```
{"level":"error","msg":"Error configuring TLS for ingress kube-system/ingress-fullback-website: secret kube-system/dev-cert does not exist","time":"2020-09-11T05:37:08Z"}
```

The ingress rule had  been incorrectly created in the kube-system namespace but the cert secret was present in the default namespace. Solution was to recreate ingress rule in the correct namespace.
