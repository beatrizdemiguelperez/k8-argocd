#!/bin/bash

echo -e "Uninstalling helm charts... Cleaning environment"
echo "Do you want to continue?([y]/n)"
read input

if [ "$input" != "y" ] && [ "$input" != "" ]; then
echo "Exit"
exit
fi


echo "uninstalling argo..."
helm uninstall argocd -n argocd
kubectl delete crd applications.argoproj.io
kubectl delete crd applicationsets.argoproj.io
kubectl delete crd appprojects.argoproj.io

echo "uninstalling example namespaces..."
kubectl delete namespace k8-examples
kubectl delete namespace helm-examples