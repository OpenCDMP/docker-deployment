#!/bin/bash
set -e
storage_dir=./storage
logs_dir=./logs

docker compose down
docker compose pull

sudo chmod 744 ./config-files/elk/elasticsearch/index_init.sh
sed -i -e 's/\r$//' ./config-files/elk/elasticsearch/index_init.sh

sudo chmod 744 ./config-files/keycloak/user_init.sh
sed -i -e 's/\r$//' ./config-files/keycloak/user_init.sh

sudo chmod 744 ./config-files/keycloak/health-check.sh
sed -i -e 's/\r$//' ./config-files/keycloak/health-check.sh

if [[ $1 == "-r" ]]; then
    echo "Resetting PostgreSQL and Elasticsearch storage..."
    sudo rm -rf ./storage/postgres/data
    mkdir -p ./storage/postgres/data

    sudo rm -rf ./storage/elasticsearch
    mkdir -p ./storage/elasticsearch
fi

folders_to_create=(
    $storage_dir
    $storage_dir/elasticsearch
    $storage_dir/elasticsearch/plugins
    $storage_dir/postgres
    $storage_dir/rabbitmq
    $storage_dir/opencdmp
    $storage_dir/opencdmp/backend
    $logs_dir
    $logs_dir/elasticsearch
    $logs_dir/keycloak
    $logs_dir/proxy
    $logs_dir/opencdmp
    $logs_dir/opencdmp/annotation
    $logs_dir/opencdmp/backend
    $logs_dir/opencdmp/notification
    $logs_dir/opencdmp/file-transformer-rda-json
    $logs_dir/opencdmp/file-transformer-docx
    $logs_dir/opencdmp/evaluator-rda-madmp
    $logs_dir/opencdmp/zenodo
)
echo "Creating storage and log folders if not exist"
for path in "${folders_to_create[@]}"
do
    if [ ! -d $path ]; then
        echo $path
        mkdir -p $path
    fi
done

echo "Deploying Elasticsearch Container"
docker compose up -d opencdmp.elasticsearch

function loading_icon() {
    local load_interval="${1}"
    local loading_message="${2}"
    local elapsed=0
    local loading_animation=( '—' "\\" '|' '/' )

    echo -n "${loading_message} "

    tput civis
    trap "tput cnorm" EXIT
    while [ "${load_interval}" -ne "${elapsed}" ]; do
        for frame in "${loading_animation[@]}" ; do
            printf "%s\b" "${frame}"
            sleep 0.25
        done
        elapsed=$(( elapsed + 1 ))
    done
    printf " \b\n"
}

echo "Waiting for Elasticsearch to Startup..."
until docker exec opencdmp.elasticsearch curl -XGET "http://opencdmp.elasticsearch:9200/_cluster/health?pretty&wait_for_status=green&master_timeout=-1&timeout=-1" -u elastic:elastic 2>/dev/null | grep -q "green"; do sleep 15; done;
docker compose up -d opencdmp.elasticsearch.setup

docker exec opencdmp.elasticsearch.setup /usr/share/elasticsearch/config/index_init.sh || true
docker exec opencdmp.elasticsearch elasticsearch-plugin install analysis-icu || echo "Plugin install failed, but continuing..."

docker restart opencdmp.elasticsearch
docker rm opencdmp.elasticsearch.setup

docker compose up -d opencdmp.postgres

loading_icon 20 "Waiting for PostgreSQL to Initialize..."

docker compose up -d opencdmp.keycloak

echo "Waiting for Keycloak to Startup..."
until docker exec opencdmp.keycloak /tmp/health-check.sh 2>/dev/null | grep -q "UP"; do sleep 15; done;
docker exec opencdmp.keycloak /tmp/user_init.sh

docker compose up -d

loading_icon 60 "Waiting for the Backend to Startup..."
docker rm opencdmp.elasticsearch.setup