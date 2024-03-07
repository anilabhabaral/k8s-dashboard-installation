## k8s dashboard installation

- Install K3D
```
brew install k3d
```
- Start the docker
- Create a cluster named mycluster with just a single server node:
```
k3d cluster create mycluster
```
- check the node
```dtd
$ kubectl get node                                                                                                                  
NAME                     STATUS   ROLES                  AGE   VERSION
k3d-mycluster-server-0   Ready    control-plane,master   79s   v1.27.5+k3s1

```
- Check the available namespace
```dtd
$ kubectl get ns      
NAME              STATUS   AGE
default           Active   2m24s
kube-system       Active   2m24s
kube-public       Active   2m24s
kube-node-lease   Active   2m24s

```

### Install Kubernetes Dashboard using HELM chart

- 
