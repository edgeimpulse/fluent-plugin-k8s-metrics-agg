#!/usr/bin/env bash
set -e
TAG=$1

# Install dependecies
gem install bundler
bundle update --bundler
bundle install

# Build Gem
rake build -t -v
cp pkg/fluent-plugin-*.gem docker

# Build Docker Image
FLUENTD_HEC_GEM_VERSION=`cat docker/FLUENTD_HEC_GEM_VERSION`
echo "Copying licenses to be included in the docker image..."
mkdir licenses
cp -rp LICENSE licenses/
docker build --build-arg VERSION=$FLUENTD_HEC_GEM_VERSION --no-cache -t splunk/k8s-metrics-aggr:$TAG ./docker
