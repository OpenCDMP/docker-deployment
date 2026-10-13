#!/bin/bash
set -e

echo "Creating Elasticsearch indexes, roles, and users..."

# Command to create the role
curl -XPOST "opencdmp.elasticsearch:9200/_security/role/opencdmp-api-test/" -u "elastic:$ELASTIC_PASSWORD" -H 'Content-Type: application/json' -d '{
  "cluster": ["monitor"],
  "indices": [
    {
      "names": [ "opencdmp-plans-test", "opencdmp-descriptions-test" ],
      "privileges": [ "all" ]
    }
  ]
}' || { echo "Failed to create the role"; exit 1; }

# Command to create the user
curl -XPOST "opencdmp.elasticsearch:9200/_security/user/opencdmp-api-test/" -u "elastic:$ELASTIC_PASSWORD" -H 'Content-Type: application/json' -d '
{
  "password" : "'"$ELASTIC_API_PASSWORD"'",
  "roles" : [ "opencdmp-api-test" ]
}' || { echo "Failed to create the user"; exit 1; }

echo "Initialization complete."
