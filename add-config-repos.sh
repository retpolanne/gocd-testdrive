#!/bin/bash

GO_SERVER=$1

curl  "$GO_SERVER/go/api/admin/config_repos" \
      -H 'Accept: application/vnd.go.cd+json' \
      -H 'Content-Type: application/json' \
      -X POST -d '{
	  "id": "gocd-testdrive",
	  "plugin_id": "yaml.config.plugin",
	  "material": {
	    "attributes": {
	      "url": "https://github.com/vinicyusmacedo/gocd-testdrive.git",
	      "password": ""
	    },
	    "type": "git"
	  },
	  "can_administer": false,
	  "material_update_in_progress": false,
	  "configuration": [
	    {
	      "key": "file_pattern",
	      "value": "config-yamls"
	    }
	  ]
	}'
