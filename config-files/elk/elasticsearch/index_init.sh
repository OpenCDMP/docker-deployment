#!/bin/bash
set -e

echo "Creating Elasticsearch indexes, roles, and users..."

# Command to create the "plans" index
curl -XPUT "http://opencdmp.elasticsearch:9200/opencdmp-plans-test/" -u elastic:elastic -H 'Content-Type: application/json' -d '{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "properties": {
      "title": { "type": "text" },
      "description": { "type": "text" },
      "price": { "type": "float" },
      "date_added": { "type": "date" }
    }
  }
}' || { echo "Failed to create the 'plans' index"; exit 1; }

# Command to create the "descriptions" index
curl -XPUT "http://opencdmp.elasticsearch:9200/opencdmp-descriptions-test/" -u elastic:elastic -H 'Content-Type: application/json' -d '{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "properties": {
      "product_id": { "type": "keyword" },
      "description_text": { "type": "text" },
      "language": { "type": "keyword" }
    }
  }
}' || { echo "Failed to create the 'descriptions' index"; exit 1; }

# Command to create the role
curl -XPOST "opencdmp.elasticsearch:9200/_security/role/opencdmp-api-test/" -u elastic:elastic -H 'Content-Type: application/json' -d '{
  "cluster": ["monitor"],
  "indices": [
    {
      "names": [ "opencdmp-plans-test", "opencdmp-descriptions-test" ],
      "privileges": [ "all" ]
    }
  ]
}' || { echo "Failed to create the role"; exit 1; }

# Command to create the user
curl -XPOST "opencdmp.elasticsearch:9200/_security/user/opencdmp-api-test/" -u elastic:elastic -H 'Content-Type: application/json' -d '
{
  "password" : "opencdmp",
  "roles" : [ "opencdmp-api-test" ]
}' || { echo "Failed to create the user"; exit 1; }

echo "Initialization complete."
