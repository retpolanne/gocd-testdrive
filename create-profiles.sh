#!/bin/bash

GO_SERVER=$1
echo "Creating dind-agent"
curl  "$GO_SERVER/go/api/elastic/profiles" \
      -H 'Accept: application/vnd.go.cd+json' \
      -H 'Content-Type: application/json' \
      -X POST -d '{
        "id": "dind-agent",
        "cluster_profile_id": "k8-cluster-profile",
        "properties": [
          {
            "key": "Image",
            "value": "gocd/gocd-agent-docker-dind:v20.1.0"
          },
          {
            "key": "PodConfiguration",
            "value": "apiVersion: v1\nkind: Pod\nmetadata:\n  name: gocd-agent-{{ POD_POSTFIX }}\n  labels:\n    app: web\nspec:\n  serviceAccountName: default\n  containers:\n    - name: gocd-agent-container-{{ CONTAINER_POSTFIX }}\n      image: gocd/gocd-agent-docker-dind:v20.1.0\n      securityContext:\n        privileged: true\n      volumeMounts:\n      - name: ssh-secrets\n        readOnly: true\n        mountPath: /home/go/.ssh\n  volumes:\n  - name: ssh-secrets\n    secret:\n      defaultMode: 420\n      secretName: gocd-agent-ssh"
          },
          {
            "key": "PodSpecType",
            "value": "yaml"
          },
          {
            "key": "Privileged",
            "value": "true"
          }
        ]
      }'
echo "Creating kubectl-agent"
curl  "$GO_SERVER/go/api/elastic/profiles" \
      -H 'Accept: application/vnd.go.cd+json' \
      -H 'Content-Type: application/json' \
      -X POST -d '{
        "id": "kubectl-agent",
        "cluster_profile_id": "k8-cluster-profile",
        "properties": [
          {
            "key": "Image",
            "value": "docker.io/sucymanbaravan/gocd-agent-kubectl:latest"
          },
          {
            "key": "PodConfiguration",
            "value": "apiVersion: v1\nkind: Pod\nmetadata:\n  name: gocd-agent-{{ POD_POSTFIX }}\n  labels:\n    app: web\nspec:\n  serviceAccountName: gocd-deploy\n  containers:\n    - name: gocd-agent-container-{{ CONTAINER_POSTFIX }}\n      image: docker.io/sucymanbaravan/gocd-agent-kubectl:latest\n      env:\n      securityContext:\n        privileged: true\n      volumeMounts:\n      - name: ssh-secrets\n        readOnly: true\n        mountPath: /home/go/.ssh\n  volumes:\n  - name: ssh-secrets\n    secret:\n      defaultMode: 420\n      secretName: gocd-agent-ssh"
          },
          {
            "key": "PodSpecType",
            "value": "yaml"
          },
          {
            "key": "Privileged",
            "value": "true"
          }
        ]
      }'
echo "Creating python-agent"
curl  "$GO_SERVER/go/api/elastic/profiles" \
      -H 'Accept: application/vnd.go.cd+json' \
      -H 'Content-Type: application/json' \
      -X POST -d '{
        "id": "python-agent",
        "cluster_profile_id": "k8-cluster-profile",
        "properties": [
          {
            "key": "Image",
            "value": "docker.io/sucymanbaravan/gocd-agent-python:latest"
          },
          {
            "key": "PodConfiguration",
            "value": "apiVersion: v1\nkind: Pod\nmetadata:\n  name: gocd-agent-{{ POD_POSTFIX }}\n  labels:\n    app: web\nspec:\n  serviceAccountName: gocd-deploy\n  containers:\n    - name: gocd-agent-container-{{ CONTAINER_POSTFIX }}\n      image: docker.io/sucymanbaravan/gocd-agent-python:latest\n      env:\n      securityContext:\n        privileged: true\n      volumeMounts:\n      - name: ssh-secrets\n        readOnly: true\n        mountPath: /home/go/.ssh\n  volumes:\n  - name: ssh-secrets\n    secret:\n      defaultMode: 420\n      secretName: gocd-agent-ssh"
          },
          {
            "key": "PodSpecType",
            "value": "yaml"
          },
          {
            "key": "Privileged",
            "value": "true"
          }
        ]
      }'
