This demo is based on the [Perform mutual TLS origination with an egress gateway](https://istio.io/latest/docs/tasks/traffic-management/egress/egress-gateway-tls-origination/#perform-mutual-tls-origination-with-an-egress-gateway)
section from Istio Documentations.

## Before you begin
- Follow [this](https://github.com/RHatDev/sm-poc/blob/main/README.md) steps to provision client and server pods.
- Install [Openshift Service Mesh 2.x](https://docs.openshift.com/container-platform/4.10/service_mesh/v2x/installing-ossm.html)
- Create project data plane and control place. 

```
oc new-project foo
oc new-project istio-system
```

- Deploy ServiceMeshControlPlace in istio-system project then **wait** for all pods to start running.
```
oc apply -f smcp-basic.yaml
```

- Add project foo to ServiceMesh Member Roll.
```
oc apply -f smmr-default.yaml
``` 

