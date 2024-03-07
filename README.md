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

For more info about K3d please follow: https://k3d.io/v5.6.0/

## Install Kubernetes Dashboard using HELM chart

**Note these steps of "Install Kubernetes Dashboard using HELM chart" can be automated using this bash script `k8s-dashboard.sh`. To run this script using this command:**
```
chmod 755 k8s-dashboard.sh
./k8s-dashboard.sh
```



### Setps:

- Add the helm repo
```dtd
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
```
- Install and deploy the helm chart of the Kubernetes dashboard in default namespace
```dtd
helm install dashboard kubernetes-dashboard/kubernetes-dashboard
```

- Check all the resource in the default namespace
```dtd
$ kubectl get all
NAME                                                                  READY   STATUS    RESTARTS   AGE
pod/dashboard-kubernetes-dashboard-auth-5747c44dd8-9dbqp              1/1     Running   0          83s
pod/dashboard-kubernetes-dashboard-api-cc5fbcd75-blfv6                1/1     Running   0          83s
pod/dashboard-kubernetes-dashboard-api-cc5fbcd75-p78q2                1/1     Running   0          83s
pod/dashboard-kubernetes-dashboard-api-cc5fbcd75-cxmrw                1/1     Running   0          83s
pod/dashboard-kubernetes-dashboard-metrics-scraper-78c75bb898-jzbt8   1/1     Running   0          83s
pod/dashboard-kubernetes-dashboard-web-549554bddb-t8wrh               1/1     Running   0          83s
pod/dashboard-kong-86dc477466-gh7bs                                   1/1     Running   0          83s

NAME                                                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
service/kubernetes                                       ClusterIP   10.43.0.1       <none>        443/TCP                         119s
service/dashboard-kubernetes-dashboard-web               ClusterIP   10.43.94.146    <none>        8000/TCP                        83s
service/dashboard-kong-manager                           NodePort    10.43.53.80     <none>        8002:30172/TCP,8445:30700/TCP   83s
service/dashboard-kong-proxy                             ClusterIP   10.43.35.128    <none>        443/TCP                         83s
service/dashboard-kubernetes-dashboard-api               ClusterIP   10.43.21.2      <none>        8000/TCP                        83s
service/dashboard-kubernetes-dashboard-metrics-scraper   ClusterIP   10.43.129.240   <none>        8000/TCP                        83s
service/dashboard-kubernetes-dashboard-auth              ClusterIP   10.43.176.47    <none>        8000/TCP                        83s

NAME                                                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/dashboard-kubernetes-dashboard-auth              1/1     1            1           83s
deployment.apps/dashboard-kubernetes-dashboard-api               3/3     3            3           83s
deployment.apps/dashboard-kubernetes-dashboard-metrics-scraper   1/1     1            1           83s
deployment.apps/dashboard-kubernetes-dashboard-web               1/1     1            1           83s
deployment.apps/dashboard-kong                                   1/1     1            1           83s

NAME                                                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/dashboard-kubernetes-dashboard-auth-5747c44dd8              1         1         1       83s
replicaset.apps/dashboard-kubernetes-dashboard-api-cc5fbcd75                3         3         3       83s
replicaset.apps/dashboard-kubernetes-dashboard-metrics-scraper-78c75bb898   1         1         1       83s
replicaset.apps/dashboard-kubernetes-dashboard-web-549554bddb               1         1         1       83s
replicaset.apps/dashboard-kong-86dc477466                                   1         1         1       83s


```

- Create a new serviceaccount
```dtd
kubectl create sa admin-test
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
- Enable fort-forwarding for the service dashboard-kong-proxy:
```dtd
kubectl port-forward service/dashboard-kong-proxy 8443:443
```
- Access the dashboard using https://127.0.0.1:8443/
- Create sign in token and copy to clipboard to login in kubernetes dashboard
```dtd
kubectl -n default create token admin-test
```
![fig-1](https://github.com/anilabhabaral/k8s-dashboard-installation/blob/main/screenshot/login.png)
- Kubernetes Dashboard
![fig-2](https://github.com/anilabhabaral/k8s-dashboard-installation/blob/main/screenshot/dashboard.png)





