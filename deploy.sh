#!/bin/bash

set -u
set -e

VERSION=$(node -e 'console.log(require("./package.json").version)')

gcloud \
    --account $GCLOUD_ACCOUNT \
    --project $GCLOUD_PROJECT \
    builds submit .

KEY=$(cat $GOOGLE_APPLICATION_CREDENTIALS)
docker login -u _json_key -p "${KEY}" https://gcr.io

docker pull gcr.io/${GCLOUD_PROJECT}/predator-runner:latest

docker tag gcr.io/${GCLOUD_PROJECT}/predator-runner:latest \
       gcr.io/${GCLOUD_PROJECT}/predator-runner:${VERSION}

docker push gcr.io/${GCLOUD_PROJECT}/predator-runner:${VERSION}
