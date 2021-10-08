---
title: Docker demo installation
slug: docker-installation
category: quickstart
order: 600
layout: docs
edition: community
description: Search Guard is also as a Docker image available
---

<!--- Copyright 2017 floragunn GmbH -->

# Docker demo installation

To quickly set up a Search Guard secured Elasticsearch cluster inside Docker:

 1. Install Docker
 2. Pull the Search Guard Docker image
 3. Create a docker-compose.yml to organize your Docker container
 4. Start your Docker container

Optional: Install Kibana:

 1. Pull the Search Guard Kibana Docker image
 2. Add Kibana configuration to your docker-compose.yml
 3. Add a kibana.yml with minimal configuration
 4. Start your Docker

## Install Search Guard with Elasticsearch on Docker

### Install Docker

If you haven't already installed Docker visit <https://www.docker.com/get-started> and follow the instructions to install Docker on your system.

### Pulling the Search Guard Docker image

To make the Search Guard image available to Docker on your system issue a `docker pull` command to pull the Search Guard image from Docker Hub.

```bash
docker pull floragunncom/search-guard-elasticsearch:6.5.4-24.0
```

### Creating a docker-compose.yml

To setup your Docker container configuration create a `docker-compose.yml` file and copy the following configuration in.

```yml
version: '2.2'
services:
  elasticsearch:
    image: "floragunncom/search-guard-elasticsearch:6.5.4-24.0"
    container_name: elasticsearch
    ports:
      - 9200:9200
```

If you want to add the Kibana plugin to your installation jump to "Install Kibana with Search Guard on Docker" else continue with "Starting the Docker container".

### Starting the Docker container

Now your setup is ready to run. `cd` into your project folder with the `docker-compose.yml` inside and issue the following command.

```bash
docker-compose up
```

Your docker container starts and the Elasticsearch cluster should be available under `https://localhost:9200`.

## Install Kibana with Search Guard on Docker

If you have done the first two steps of the Elasticsearch with Search Guard installation you can add the Kibana plugin to your installation.

### Pulling the Search Guard Kibana Docker image

To make the Search Guard Kibana plugin available to your Docker installation issue the `docker pull` command again for the Kibana docker file.

```bash
docker pull floragunncom/search-guard-kibana:6.5.4-17
```

### Add Kibana configuration to the docker-compose.yml

Now add the following Kibana configuration to your existing `docker-compose.yml` under your elasticsearch configuration.

```yml
  kibana:
  image: "floragunncom/search-guard-kibana:6.5.4-17"
  ports:
    - 5601:5601
  volumes:
    - ./kibana.yml:/usr/share/kibana/config/kibana.yml
```

After that your `docker-compose.yml` should look like this:

```yml
version: '2.2'
services:
  elasticsearch:
    image: "floragunncom/search-guard-elasticsearch:6.5.4-24.0"
    container_name: elasticsearch
    ports:
      - 9200:9200
  kibana:
    image: "floragunncom/search-guard-kibana:6.5.4-17"
    volumes:
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml
    ports:
      - 5601:5601
```

### Create a kibana.yml

Kibana needs additional configuration to run with Search Guard. To add these create a `kibana.yml` file inside your project folder and put the following configuration in.

```yml
server.host: "0.0.0.0"
elasticsearch.url: "https://elasticsearch:9200"
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"
elasticsearch.ssl.verificationMode: none
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant" ]
xpack.security.enabled: false
```

#### Changing the kibana.yml path

If you don't want to have the `kibana.yml` file in the same location of the `docker-compose.yml` simply adjust the path that is configured inside the `docker-compose.yml` under `kibana: volumes:` that is given in front of the colon to for exsample:

```yml
kibana:
  volumes:
    - ./kibana/config-files/kibana.yml:/usr/share/kibana/config/kibana.yml
```

### Start your Docker container

To start your installation just `cd` in your project folder and issue the following command. Make sure that you allocated enough memory (8gb or more) for your docker installation.

```bash
docker-compose up
```

Your docker container starts and Kibana should now be available at `http://localhost:5601`.