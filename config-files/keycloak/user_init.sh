#!/bin/bash

/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth/ --realm master --user keycloak-admin --password admin --client admin-cli
/opt/keycloak/bin/kcadm.sh add-roles -r OpenCDMP --uusername dmp-keycloak-api --cclientid realm-management --rolename realm-admin
