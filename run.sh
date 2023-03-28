#!/bin/bash

docker run -d -p 443:443 --name my-grouper \
       -e GROUPER_UI_GROUPER_AUTH=true \
       -e GROUPER_SELF_SIGNED_CERT=true \
       -e GROUPER_RUN_SHIB_SP=false \
       -e GROUPER_AUTO_DDL_UPTOVERSION='v4.0.*' \
       -e GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='0.0.0.0/0' \
       -e GROUPERSYSTEM_QUICKSTART_PASS=pass \
       -e GROUPER_UI=true \
       -e GROUPER_DATABASE_URL=jdbc:postgresql://docker.for.mac.localhost:5432/grouper_v2_6?currentSchema=public \
       -e GROUPER_DATABASE_USERNAME=grouper \
       -e GROUPER_DATABASE_PASSWORD=pass \
       -e GROUPER_LOG_TO_HOST=true \
       -e GROUPER_LOG_TO_PIPE=true \
       -e ENV="foo(2)" \
       -e USERTOKEN=myUserToken \
       my-grouper:latest ui

