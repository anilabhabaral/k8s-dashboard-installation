#!/bin/bash

echo "Creating k8s dashboard"

#helm chart creating 
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
helm install dashboard kubernetes-dashboard/kubernetes-dashboard

sleep 20

# creating the sa
kubectl create sa admin-test

# creating ClusterRoleBinding
cat <<EOF | kubectl -n default apply -f -
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


echo -e '\n'
echo -e '\n'

sleep 40
echo "********************************** Token ***************************************"
# craeting token. Note it is valid for one hour
kubectl -n default create token admin-test
echo "********************************** Token ***************************************"

echo -e '\n'
echo -e '\n'


# strating the port-forward to access the dashboard in loacl env
kubectl port-forward service/dashboard-kong-proxy 8443:443
