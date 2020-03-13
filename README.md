# GoCD Test Drive

This repo shows steps for testing GoCD with an example project.

# Known limitations

- Using git tags seems kind of hard and non-straightforward, so I'm just building from the master and always trusting the `latest` tag on Docker
- Running kubernetes-related steps seems like a black-box (you run, but you don't know if it worked)

# PreReqs

- `kubectl`
- `minikube`
- Virtualbox
- `helm` - 2.16.1

# Steps

## 1. Create a minikube cluster

```sh
minikube start --memory 4086 --kubernetes-version v1.15.0 --vm-driver=virtualbox
minikube addons enable ingress
```

## 2. Deploy GoCD using Helm

Run this:

```sh
helm init
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm install --name gocd-app --namespace gocd stable/gocd
```

Then get the public IP (you may have to do it twice, for some reason the ingress got another IP at some times).

```sh
echo "GoCD server public IP: http://$(kubectl get ingress gocd-app-server --namespace=gocd  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
```

## 3. Create ssh keys for github deployment

Follow this [guide](https://github.com/helm/charts/tree/master/stable/gocd#ssh-keys-1) from the official Helm chart, don't forget to specify the namespace.

```sh
ssh-keygen -t rsa -b 4096 -C "user@example.com" -f gocd-agent-ssh -P ''
kubectl create secret generic gocd-agent-ssh \
   --from-file=id_rsa=gocd-agent-ssh \
   --from-file=id_rsa.pub=gocd-agent-ssh.pub \
   -n gocd
```

## 4. Config pipelines, elastic agent profiles and Dockerhub

```sh
# Use the server IP you got on the step 2
export SERVER_IP=http://$(kubectl get ingress gocd-app-server --namespace=gocd  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
# Create elastic agent profiles
./create-profiles.sh $SERVER_IP
# Add config repos
# If no pipeline shows, go to Admin > Config Repositories and refresh the gocd-testdrive config repo
./add-config-repos.sh $SERVER_IP
# Add dockerhub
./add-dockerhub.sh $SERVER_IP docker.io username "password"
```

## 5. Create gocd-deploy service account

```sh
kubectl create serviceaccount gocd-deploy -n gocd
kubectl apply -f gocd-deploy-rbac.yaml
```

## 6. Run deploy

You can trigger a deploy by either clicking the Play button on the pipeline, which can be found on the GoCD Dashboard, or push some changes to the flask-celery-sample repo.

To get the flask-celery-sample IP, run:

```sh
APP_IP=$(kubectl get ingress flask-celery-sample-ingress --namespace=flask-celery-sample  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -H "Host: flask-celery-sample.io" $APP_IP/healthcheck
```
