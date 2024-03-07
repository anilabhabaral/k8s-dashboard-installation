## k8s dashboard installation

- Install K3D in MacBook
```
brew install k3d
```
- Start the docker
- Create a cluster named mycluster with just a single server node:
```
k3d cluster create mycluster
```
- Check the node
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

## Install Kubernetes Dashboard using HELM chart
- Add the helm repo
```dtd
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
```
- Install and deploy the helm chart of the Kubernetes dashboard in default namespace
```dtd
helm install dashboard kubernetes-dashboard/kubernetes-dashboard
```

- Create a new serviceaccount
```dtd
$ kubectl create sa admin-test              
serviceaccount/admin-test created

```
- Check the serviceaccount
```dtd
$ kubectl get sa              
NAME         SECRETS   AGE
default      0         15m
admin-test   0         2m45s
```
- Create new cluster role binding and bind the above created serviceaccount
```dtd
$ cat <<EOF | kubectl -n default apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-test-cluster-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-test
    namespace: default
EOF
```
- Check the newly created serviceaccount
```dtd
$ kubectl get clusterrolebinding | grep admin-test-cluster-role-binding                    
admin-test-cluster-role-binding                        ClusterRole/cluster-admin                                          3m54s

```
- Create sign in token and copy to clipboard to login in kubernetes dashboard
```dtd
kubectl -n default create token admin-test
```


