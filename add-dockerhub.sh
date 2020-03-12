#!/bin/bash

GO_SERVER=$1
REGISTRY_URI=$2
REGISTRY_USER=$3
REGISTRY_PASS=$4

curl  "$GO_SERVER/go/api/admin/artifact_stores" \
      -H 'Accept: application/vnd.go.cd+json' \
      -H 'Content-Type: application/json' \
      -X POST -d '{
	  "id": "dockerhub",
	  "plugin_id": "cd.go.artifact.docker.registry",
	  "properties": [
	    {
	      "key": "RegistryType",
	      "value": "other"
	    },
	    {
	      "key": "RegistryURL",
	      "value": "'$REGISTRY_URL'"
	    },
	    {
	      "key": "RegistryID"
	    },
	    {
	      "key": "AWSAccessKeyId"
	    },
	    {
	      "key": "AWSSecretAccessKey"
	    },
	    {
	      "key": "AWSRegion"
	    },
	    {
	      "key": "Username",
	      "value": "'$REGISTRY_USER'"
	    },
	    {
	      "key": "Password",
	      "value": "'$REGISTRY_PASS'"
	    }
	  ]
	}'
