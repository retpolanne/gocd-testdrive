# GoCD Test Drive

This repo shows steps for testing GoCD with an example project.

# PreReqs

- `kubectl`
- `minikube`
- `helm` - 2.16.1

# Steps

## 1. Create a minikube cluster

## 2. Deploy GoCD using Helm

Run this:

```sh
helm init
helm install --name gocd-app --namespace gocd stable/gocd
```

Then follow the steps shown to get the public ingress IP.

## 3. Create ssh keys for github deployment

Follow this [guide](https://github.com/helm/charts/tree/master/stable/gocd#ssh-keys-1) from the official Helm chart.

## 4. Config pipelines, elastic agent profiles and Dockerhub

```sh
# Use the server IP you got on the step 2
export SERVER_IP=
# Create elastic agent profiles
./create-profiles.sh $SERVER_IP
# Add config repos
./add-config-repos.sh $SERVER_IP
# Add dockerhub
./add-dockerhub.sh $SERVER_IP docker.io username "password"
```

## 5. Create gocd-deploy service account

```sh
kubectl apply -f gocd-deploy-rbac.yaml
```
