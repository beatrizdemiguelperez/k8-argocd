# k8/Argocd Workshop

Code to deploy all necessary tools for the k8+argocd workshop.

## Prerequisites

1. A **kubernetes cluster** to deploy all elements. You can use one of the following local clusters:

   - [Minikube](https://minikube.sigs.k8s.io/docs/start/)
   - Install MacOS Docker-Desktop and configure [Docker-Desktop Local Kubernetes Cluster](https://docs.docker.com/docker-for-mac/#kubernetes) (easiest way for MacOs Users)
   - [Kind cluster](https://kind.sigs.k8s.io/docs/user/quick-start/)

2. **kubectl** installed and pointing to local cluster context. Installation tutorial [here](https://kubernetes.io/es/docs/tasks/tools/install-kubectl/).
3. **Helm** installed locally. Installation tutorial [here](https://helm.sh/docs/intro/install/#through-package-managers).

## k8 basics

- Create examples namespace: `kubectl create namespace k8-examples`

- Install basic pod: `kubectl apply -f k8-basics/objects/basic-pod.yaml -n k8-examples`

- Install basic deployment: `kubectl apply -f k8-basics/objects/basic-deployment.yaml -n k8-examples`

- Check it: `kubectl get po -n k8-examples`, `kubectl port-forward my-nginx-<> -n k8-examples 8080:80` and then visit <http://localhost:8080/>

- Install basic helm chart: `helm upgrade --install nginx-example k8-basics/helm-charts/nginx-example --namespace=helm-examples --create-namespace`

- Check it: `kubectl get po -n helm-examples`

- Uninstall it: `helm uninstall nginx-example -n helm-examples`

## Argocd

To deploy stack use the following script:

```bash
./deploy_stack.sh
```

Check helm installation: `helm ls --all-namespaces`

Create an app in argocd

###  Create New App

In the UI, Click on + NEW APP button and enter the following values (default options if not specified):

Application Name: my-example
Project: default
Sync Policy: Automatic
Repository URL: <https://github.com/beatrizdemiguelperez/k8-argocd.git>
Revision: HEAD
Path: k8-basics/helm-charts/nginx-example
Cluster URL: <https://kubernetes.default.svc>
namespace: default
Click on Create button to install the app!

## Cleaning environment. Deleting stack

To delete all the stack use the following script:

```bash
./delete_stack.sh
```

Deployed components can be seen:

$ kubectl get pods -n argocd

Access ArgoCD UI

ArgoCD API Server can be exposed via [**port-forward**](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/) (mapping the pod application port to a local port), to access the service via `localhost:port`.

> Note: This is the easiest way to expose a service locally. Another options to expose services involve using ingresses, Nodeport/LoadBalancer services, etc. More information about accesing apps in a cluster [here](https://kubernetes.io/docs/tasks/access-application-cluster/).

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

ArgoCD will be available at <http://localhost:8080>.

Initial admin credentials are stored under the secret `argocd-initial-admin-secret` in the argocd namespace. Retrieve the `admin` password with:

```
PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) && echo $PASS
```

Once logged, ArgoCD is ready to configure Apps!
