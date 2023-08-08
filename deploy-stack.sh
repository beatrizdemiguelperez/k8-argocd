#!/bin/bash

echo "Checking prerequisites..."

for i in 'kubectl' 'helm'; do
  if ! command -v $i &> /dev/null; then
      echo "  [KO] $i is not available in PATH or not installed... Exit"
      exit
  else
      echo "  [OK] $i installed"
  fi
done

echo "Using `kubectl config current-context` Kubernetes cluster"
echo "Do you want to continue?([y]/n)"
read input

if [ "$input" != "y" ] && [ "$input" != "" ]; then
echo "Exit installation"
exit
fi

echo -e "\nAdding and updating helm repositories...\n"

echo -e "\nInstalling argocd helm chart in argocd namespace..."
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade argocd -i --namespace=argocd argo/argo-cd --create-namespace >> ./chart-installed-notes.txt