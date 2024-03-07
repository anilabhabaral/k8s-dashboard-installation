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
$ kubectl get all -n default                
NAME                                                                  READY   STATUS    RESTARTS   AGE
pod/dashboard-kubernetes-dashboard-auth-5f7969b95c-4nxgj              1/1     Running   0          27m
pod/dashboard-kubernetes-dashboard-api-65dd9fcc5f-qhxq2               1/1     Running   0          27m
pod/dashboard-kubernetes-dashboard-api-65dd9fcc5f-fl2pz               1/1     Running   0          27m
pod/dashboard-kubernetes-dashboard-api-65dd9fcc5f-rn2ct               1/1     Running   0          27m
pod/dashboard-kubernetes-dashboard-metrics-scraper-54bd5c86cc-j4wf7   1/1     Running   0          27m
pod/dashboard-kubernetes-dashboard-web-79bbd9c596-lnrxt               1/1     Running   0          27m
pod/dashboard-kong-86dc477466-xmm7k                                   1/1     Running   0          27m

NAME                                                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
service/kubernetes                                       ClusterIP   10.43.0.1       <none>        443/TCP                         52m
service/dashboard-kong-manager                           NodePort    10.43.146.112   <none>        8002:31027/TCP,8445:30964/TCP   27m
service/dashboard-kubernetes-dashboard-metrics-scraper   ClusterIP   10.43.143.225   <none>        8000/TCP                        27m
service/dashboard-kubernetes-dashboard-auth              ClusterIP   10.43.60.125    <none>        8000/TCP                        27m
service/dashboard-kubernetes-dashboard-web               ClusterIP   10.43.67.131    <none>        8000/TCP                        27m
service/dashboard-kubernetes-dashboard-api               ClusterIP   10.43.80.236    <none>        8000/TCP                        27m
service/dashboard-kong-proxy                             NodePort    10.43.146.244   <none>        443:31372/TCP                   27m <------- Previously it was ClusterIP but to access the dashboard change it to NodePort type using `$ kubectl edit service/dashboard-kong-proxy`  

NAME                                                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/dashboard-kubernetes-dashboard-auth              1/1     1            1           27m
deployment.apps/dashboard-kubernetes-dashboard-api               3/3     3            3           27m
deployment.apps/dashboard-kubernetes-dashboard-metrics-scraper   1/1     1            1           27m
deployment.apps/dashboard-kubernetes-dashboard-web               1/1     1            1           27m
deployment.apps/dashboard-kong                                   1/1     1            1           27m

NAME                                                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/dashboard-kubernetes-dashboard-auth-5f7969b95c              1         1         1       27m
replicaset.apps/dashboard-kubernetes-dashboard-api-65dd9fcc5f               3         3         3       27m
replicaset.apps/dashboard-kubernetes-dashboard-metrics-scraper-54bd5c86cc   1         1         1       27m
replicaset.apps/dashboard-kubernetes-dashboard-web-79bbd9c596               1         1         1       27m
replicaset.apps/dashboard-kong-86dc477466                                   1         1         1       27m

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
- kubernetes DashBoard
![fig-2](https://github.com/anilabhabaral/k8s-dashboard-installation/blob/main/screenshot/dashboard.png)





