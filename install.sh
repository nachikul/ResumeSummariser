#!/bin/bash

docker build -t streamlit-app:latest -f Dockerfile_frontend .
docker build -t fastapi-app:latest -f Dockerfile_backend .

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# Check if the argocd-server pod is in Running state
while [[ $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath="{.items[0].status.phase}") != "Running" ]]; do
    echo "Waiting for argocd-server pod to be in Running state..."
    sleep 5
done

kubectl port-forward svc/argocd-server -n argocd 8080:443

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl apply -f k8s/argocd-app.yaml



