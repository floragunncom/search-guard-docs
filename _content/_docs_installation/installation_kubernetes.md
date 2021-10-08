---
title: Kubernetes Helm Charts
html_title: Kubernetes Helm Charts
permalink: search-guard-kubernetes-helm
category: installation
order: 390
layout: docs
description: Use our Helm charts to set up Elasticsearch and Kibana on a Kubernetes cluster, secured by Search Guard.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Search Guard Helm Charts for Kubernetes

## Requirements

* Kubernetes 1.16 or later (Minikube and kops managed AWS Kubernetes cluster are tested)
* Helm (v.3.2.4 or later). Please, follow [Helm installation steps](https://helm.sh/docs/intro/install/) for your OS.
* kubectl. Please check [kubectl installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* Optional: Minikube. Please, follow [Minikube installation steps](https://minikube.sigs.k8s.io/docs/start/).
* Optional: [Docker](https://docs.docker.com/engine/install/), if you like to build and push customized images

If you use Minikube make sure that the VM has enough memory and CPUs assigned.
We recommend at least 8 GB and 4 CPUs. By default, we deploy 5 pods (includes also Kibana).

To change Minikube resource configuration:

```
minikube config set memory 8192
minikube config set cpus 4
minikube delete
minikube start
```

If Minikube is already configured/running, make sure it has at least 8 GB and 4 CPUs assigned:

```
minikube config view
```

If not, then execute the steps above (Warning: `minikube delete` will delete your Minikube VM).

## Deploying with Helm

By default, you get an Elasticsearch cluster with self-signed certificates for transport communication, and Elasticsearch and Kibana service access via ingress nginx.
The default Elasticsearch cluster has 4 nodes, including master, ingest, data and kibana nodes.
Be aware that this Elasticsearch cluster configuration should be used only for testing purposes.

### Deploy via repository

```
helm repo add search-guard https://helm.search-guard.com
helm repo update
helm search "search guard"
helm install sg-elk search-guard/search-guard-helm
```

Please refer to the [Helm Documentation](https://helm.sh/docs/intro/using_helm/) on how to override the chart default
settings. See `values.yaml` for the documented set of settings you can override.

Note that if you are using any other Kubernetes distribution except Minikube,
check if [Storage type](https://kubernetes.io/docs/concepts/storage/storage-classes/) "standard" is available in the distribution.
If not, please, specify available [Storage type](https://kubernetes.io/docs/concepts/storage/storage-classes/) for `data.storageClass` and
`master.storageClass` in [values.yaml](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/values.yaml) or by providing them in helm installation command.

Example usage for AWS EBS:

```
helm install --set data.storageClass=gp2 --set master.storageClass=gp2  sg-elk search-guard/search-guard-helm
```

### Deploy via GitLab

To deploy from this GitLab repository, you should clone the project, update helm dependencies and install it in your cluster.
Optionally read the comments in `values.yaml` and customize them to suit your needs.

```
$ git clone git@git.floragunn.com:search-guard/search-guard-helm.git
$ helm dependency update search-guard-helm
$ helm install sg-elk search-guard-helm
```

Please refer to the [Helm Documentation](https://helm.sh/docs/intro/using_helm/) on how to override the chart default
settings. See `values.yaml` for the documented set of settings you can override.

Please note that if you are using any other Kubernetes distribution except Minikube,
check if [Storage type](https://kubernetes.io/docs/concepts/storage/storage-classes/) "standard" is available in the distribution.
If not, please, specify available [Storage type](https://kubernetes.io/docs/concepts/storage/storage-classes/) for `data.storageClass` and `master.storageClass` in
[values.yaml](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/values.yaml) or by providing them in helm installation command.

Example usage for AWS EBS:
```
helm install --set data.storageClass=gp2 --set master.storageClass=gp2 sg-elk search-guard-helm
```

### Deploy on AWS (optional)

This option provides the possibility to set up Kubernetes cluster on AWS while having the `awscli` installed and configured, and install Search Guard Helm charts in the cluster.
This script is provided for demo purposes. Please consider the required AWS resources and Helm chart configuration in the [./tools/sg_aws_kops.sh](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/tools/sg_aws_kops.sh).

Setup the Kubernetes AWS cluster with installed Search Guard Helm charts:

```
./tools/sg_aws_kops.sh -c mytestcluster
```

Delete the cluster when you finished with testing Search Guard

```
./tools/sg_aws_kops.sh -d mytestcluster
```

## Usage Tips

### Accessing Kibana and Elasticsearch

Check that all pods are running and green.

If you use Minikube, run in separate window:

```
minikube tunnel
```

### Get Ingress address:

```
kubectl get ing --namespace default sg-elk-search-guard-helm-ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}{.status.loadBalancer.ingress[0].ip}'
```

### Create records in local etc/hosts

```
<Ingress address IP>   kibana.sg-helm.example.com
<Ingress address IP>   es.sg-helm.example.com
```

### Get Admin user 'admin' password:

```
kubectl get secrets sg-elk-search-guard-helm-passwd-secret -o jsonpath="{.data.SG_ADMIN_PWD}" | base64 -d
```

Access Kibana `https://kibana.sg-helm.example.com` with `admin/<admin user password>`
Access Elasticsearch  `https://es.sg-helm.example.com/_searchguard/health`

### Random passwords and certificates

Passwords for admin user (`admin`), kibana user (`kibanaro`), kibana server (`kibanaserver`) and custom users specified in [values.yaml](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/values.yaml) are generated randomly on initial deployment.
They are stored in a secret named `<installation-name>-search-guard-helm-passwd-secret`.

To get user related password:

```
kubectl get secrets sg-elk-search-guard-helm-passwd-secret -o jsonpath="{.data.SG_<USERNAME_UPPERCASE>_PWD}" | base64 -d
```

You can find the root ca in a secret named `<installation-name>-search-guard-helm-root-ca-secret`, the Admin certificate in `<installation-name>-search-guard-helm-admin-cert-secret` and the node certificates in `<installation-name>-search-guard-helm-nodes-cert-secret`.
Whenever a node pod restarts we create a new certificate and remove the old one from `<installation-name>-search-guard-helm-nodes-cert-secret`.

### Use custom images

We provide our Dockerfiles and build script in [docker folder](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/docker)
that we use to create Docker images. By default, the script can upload OSS version of Elasticsearch with Search Guard plugin installed,
Kibana with Search Guard Kibana plugin installed and Search Guard Admin image to you Docker hub account:

```
./build.sh push <your-dockerhub-account>
```

Please, make sure you have exported your `$DOCKER_PASSWORD` in your environment beforehand.

When you are ready with custom Docker images, please refer to `common.images` and `common.docker_registry` in [values.yaml](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/values.yaml)
to point to your custom docker images location.

### Install plugins
You can install all required plugins for your Elasticsearch nodes
by providing plugins as a list in `common.plugins` section in [values.yaml](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/values.yaml)
The plugins from this list will be passed to `elasticsearch-plugin install -b {line here}`.
Do not add the Search Guard plugins to the list as they are already installed by default in the images.

### Custom configuration for Search Guard, Elasticsearch and Kibana
You can modify default configuration of Elasticsearch, Kibana and Search Guard Suite plugin
by providing necessary changes in [values.yaml](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/values.yaml)
Please check this [example with custom configuration](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_sg_config)
for more details.

### Custom domains for Elasticsearch and Kibana services

Default service domain names exposed by the cluster are: `es.sg-helm.example.com` and `kibana.sg-helm.example.com`.
You can change this by providing custom domain names and corresponding certificates.
Please, follow the [example with custom domains](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_service_certs) for more details.

### Security configuration

We provide different PKI approaches for security configuration in Elasticsearch cluster
including self-signed and CA signed solutions. Please, refer to following examples for more details:

* [setup with custom CA certificate](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_ca)
* [setup with custom Elasticsearch cluster nodes certificates](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_elasticsearch_certs)
* [setup with single certificates for Elasticsearch cluster nodes](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_single_elasticsearch_cert)

## Modify the configuration

* The nodes are automatically initialized and configured
* To change the configuration of SG
    * Edit `values.yaml` and run `helm upgrade`. The job with SG Admin image will be restarted and new Search Guard configuraiton will be applied to the cluster.
      Please, be aware that with disabled parameter `debug_job_mode`, the job will be removed in 5 minutes after completion.
* To change the configuration of Kibana and Elasticsearch: pods will be reconfigured or restarted if necessary
    * Edit `values.yaml` and run `helm upgrade` or run `helm upgrade --values` or `helm upgrade --set`. The pods will be reconfigured or restarted if necessary.
      If you want to disable sharding during Elasticsearch cluster restart, please, use `helm upgrade --set common.disable_sharding=true`
* To upgrade the version of Elasticseacrh, Kibana, Search Guard plugins:
    * Edit `values.yaml` and run `helm upgrade` or run `helm upgrade --values` or `helm upgrade --set` with new version of the products.
      To meet the requirements of Elasticsearch rolling upgrade procedure, please, add these parameters to the upgrade command: `helm upgrade --set common.es_upgrade_order=true --set common.disable_sharding=true`.
      We recommend to specify custom timeout for upgrade command `helm upgrade --timeout 1h` to provide enough time for Helm to upgrade all cluster nodes.

Do not use ``common.es_upgrade_order=true`` when your master.replicas=1 because in this case master node and non-master node dependency conditions block each over and upgrade fails.

## Configuration parameters

### Client

| Parameter | Description | Default |
|------|------|------|
| client.annotation |  Metadata to attach to client nodes | null |
| client.antiAffinity | Affinity policy for master nodes: 'hard' for pods scheduling only on the different nodes, 'soft' pods scheduling on the same node possible  | soft |
| client.heapSize | HeapSize limit for client nodes | 1g |
| client.labels | Metadata to attach to client nodes | null |
| client.processors | Elasticsearch processors configuration on client nodes | 1|
| client.replicas | Stable number of client replica Pods running at any given time  | 1 |
| client.resources.limits.cpu | CPU limits for client nodes | 500m |
| client.resources.limits.memory | Memory limits for client nodes | 1500Mi |
| client.resources.requests.cpu | CPU resources requested on cluster start | 100m |
| client.resources.requests.memory | Memory resources requested on cluster start | 1500Mi |
| client.storage | Storage size for client nodes | 2Gi |
| client.storageClass | Storage class for client nodes if you use non-default storage class | default |
{: .config-table}

### Common

| Parameter | Description | Default |
|------|------|------|
| common.admin_dn | DN of certificate with admin privileges | CN=sgadmin,OU=Ops,O=Example Com\\, Inc.,DC=example,DC=com |
| common.ca_certificates_enabled | Feature that enables possibility to upload customer CA and use it to sign cluster certificates | false |
| common.certificates_directory | Directory with customer certificates that are used in ES cluster | secrets |
| common.cluster_name | cluster.name parameter in elasticsearch.yml | searchguard |
| common.config.* | Additional configuration that will be added to elasticsearch.yml | null |
| common.debug_job_mode | Feature to disable removal process of completed jobs | false |
| common.disable_sharding | Feature to disable Elasticsearch cluster sharding during Helm upgrade procedure | false | 
| common.do_not_fail_on_forbidden | With this mode enabled Search Guard filters all indices from a query a user does not have access to. Thus not security exception is raised. See https://docs.search-guard.com/latest/kibana-plugin-installation#configuring-elasticsearch-enable-do-not-fail-on-forbidden | false |
| common.docker_registry.email | Email information for Docker account in docker registry | null |
| common.docker_registry.enabled | Enable docker login procedure to docker registry before downloading docker images | false |
| common.docker_registry.imagePullSecret | The existing secret name with all required data to authenticate to docker registry | null |
| common.docker_registry.password | Password of docker registry account | null |
| common.docker_registry.server | Docker registry address | null |
| common.docker_registry.username | Login of docker registry account | null |
| common.elkversion | Version of Elasticsearch and Kibana in ES cluster | 7.9.1 |
| common.es_upgrade_order | Feature to enable rolling upgrades of Elasticsearch cluster: upgrading Client and Data nodes, then upgrading Master nodes and then Kibana nodes | false |
| common.external_ca_certificates_enabled | Feature that enables possibility to upload customer ca signed certificates for each node in the ES cluster | false |
| common.external_ca_single_certificate_enabled | Feature that enables possibility to upload single customer ca signed certificate for all nodes in the ES cluster | false |
| common.images.elasticsearch_base_image | Docker image name with Elasticsearch and Search Guard plugin installed | sg-elasticsearch |
| common.images.kibana_base_image | Docker image name with Kibana and Search Guard plugin installed | sg-kibana |
| common.images.repository | Docker registry repository for docker images in the ES cluster | docker.io |
| common.images.provider | Docker registry provider of docker images in the ES cluster | floragunncom |
| common.images.sgadmin_base_image | Docker image name with Elasticsearch, Search Guard plugin and Search Guard TLS tool installed | sg-sgadmin |
| common.ingressNginx.enabled | Enabling NGINX Ingress that exposes Elasticsearch and Kibana services outside the ES cluster | true |
| common.ingressNginx.ingressCertificates | Ingress Certificates types: "self-signed" for auto-generated with TLS tool self-signed certificates, "external" for customer ca signed certificates | self-signed |
| common.ingressNginx.ingressElasticsearchDomain | Elasticsearch service domain that is exposed outside the ES cluster | es.sg-helm.example.com |
| common.ingressNginx.ingressKibanaDomain | Kibana service domain that is exposed outside the ES cluster | kibana.sg-helm.example.com |
| common.nodes_dn | Certificate DN of the nodes in the ES cluster | CN=*-esnode,OU=Ops,O=Example Com\\, Inc.,DC=example,DC=com |
| common.plugins | List of additional Elasticsearch plugins to be installed on the nodes of the ES cluster | null |
| common.pod_disruption_budget_enable | Enable Pod Disruption budget feature for ES and Kibana pods. | false |
| common.restart_pods_on_config_change | Feature to restart pods automatically when their configuration was changed | true |
| common.roles | Additional roles configuration in sg_roles.yml | null |
| common.rolesmapping | Additional roles mapping configuration in sg_roles_mapping.yml | null |
| common.serviceType | Type of Elasticsearch services exposing in the ES cluster | ClusterIP |
| common.sg_enterprise_modules_enabled | Enable or disable Search Guard enterprise modules | false |
| common.sgadmin_certificates_enabled | Feature to use self-signed certificates generated by Search Guard TLS tool in the cluster | true |
| common.sgkibanaversion | Search Guard Kibana plugin version to use in the cluster | 45.0.0 |
| common.sgversion |  Search Guard Kibana plugin version to use in the cluster | 45.0.0 |
| common.update_sgconfig_on_change | Run automatically sgadmin whenever neccessary  | true |
| common.users | Additional users configuration in sg_internal_users.yml | null |
| common.xpack_basic | Enable/Disable X-Pack in the ES cluster | false |
{: .config-table}

### Data

| Parameter | Description | Default |
|------|------|------|
| data.annotations | Metadata to attach to data nodes | null |
| data.antiAffinity | Affinity policy for master nodes: 'hard' for pods scheduling only on the different nodes, 'soft' pods scheduling on the same node possible | soft |
| data.heapSize | HeapSize limit for data nodes | 1g |
| data.labels | Metadata to attach to data nodes | null |
| data.processors | Elasticsearch processors configuration on data nodes | null |
| data.replicas |  Stable number of data replica Pods running at any given time  | 1 | 
| data.resources.limits.cpu | CPU limits for data nodes | 1 |
| data.resources.limits.memory |  Memory limits for data nodes | 2Gi |
| data.resources.requests.cpu | CPU resources requested on cluster start for kibana nodes | 1 |
| data.resources.requests.memory | Memory resources requested on cluster start for kibana nodes | 1500Mi |
| data.storage | Storage size for data nodes | 4Gi |
| data.storageClass | Storage type for data nodes if you use non-default storage class | default |
{: .config-table}

### Kibana

| Parameter | Description | Default |
|------|------|------|
| kibana.annotations | Metadata to attach to kibana nodes | null |
| kibana.antiAffinity | Affinity policy for master nodes: 'hard' for pods scheduling only on the different nodes, 'soft' pods scheduling on the same node possible | soft |
| kibana.heapSize | HeapSize limit for kibana nodes | 1g |
| kibana.httpPort | Port to be exposed by Kibana service in the cluster | 5601 |
| kibana.labels | Metadata to attach to kibana nodes | null |
| kibana.processors | Kibana processors configuration on Kibana nodes | 1 |
| kibana.replicas | Stable number of kibana replica Pods running at any given time | 1 |
| kibana.resources.limits.cpu | CPU limits for kibana nodes | 500m |
| kibana.resources.limits.memory | Memory limits for kibana nodes | 1500Mi |
| kibana.resources.requests.cpu | CPU resources requested on cluster start for kibana nodes | 100m |
| kibana.resources.requests.memory | Memory resources requested on cluster start for kibana nodes | 2500Mi |
| kibana.serviceType | Type of Kibana service exposing in the ES cluster | ClusterIP |
| kibana.storage | Storage size for client nodes | 2Gi |
| kibana.storageClass | Storage class for client nodes if you use non-default storage class | default |
{: .config-table}

### Master 

| Parameter | Description | Default |
|------|------|------|
| master.annotations | Metadata to attach to master nodes | null |
| master.antiAffinity | Affinity policy for master nodes: 'hard' for pods scheduling only on the different nodes, 'soft' pods scheduling on the same node possible | soft |
| master.heapSize | HeapSize limit for master nodes | 1g |
| master.labels |  Metadata to attach to master nodes | null |
| master.processors | Elasticsearch processors configuration for master nodes | null |
| master.replicas | Stable number of master replica Pods running at any given time | 1 |
| master.resources.limits.cpu | CPU limits for master nodes | 500m |
| master.resources.limits.memory | Memory limits for data nodes | 1500Mi |
| master.resources.requests.cpu | CPU resources requested on cluster start for kibana nodes | 100m |
| master.resources.requests.memory | Memory resources requested on cluster start for kibana nodes | 2500Mi |
| master.storage | Storage size for master nodes | 2Gi |
| master.storageClass | Storage class for master nodes if you use non-default storage class | default |
{: .config-table}

### Other

| Parameter | Description | Default |
|------|------|------|
| pullPolicy | Kubernetes image pull policy | IfNotPresent |
| rbac.create | Feature to create Kubernetes entities for Role-based access control in the Kubernetes cluster | true |
| service.httpPort | Port to be exposed by Elasticsearch service in the cluster | 9200 |
| service.transportPort | Port to be exposed by Elasticsearch service for transport communication in the cluster | 9300 |
{: .config-table}

## Credits

* [https://github.com/lalamove/helm-elasticsearch](https://github.com/lalamove/helm-elasticsearch)
* [https://github.com/pires/kubernetes-elasticsearch-cluster](https://github.com/pires/kubernetes-elasticsearch-cluster)
* [https://github.com/kubernetes/charts/tree/master/incubator/elasticsearch](https://github.com/kubernetes/charts/tree/master/incubator/elasticsearch)
* [https://github.com/clockworksoul/helm-elasticsearch](https://github.com/clockworksoul/helm-elasticsearch)

## Useful Links

### Kubernetes and Docker

* [Docker](https://docs.docker.com/engine/install/)
* [Minikube installation steps](https://minikube.sigs.k8s.io/docs/start/)
* [kubectl installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm Documentation](https://helm.sh/docs/intro/using_helm/)
* [Helm installation steps](https://helm.sh/docs/intro/install/)
* [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)

### Search Guard Helm Charts

* [docker folder](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/docker)
* [Search Guard Helm Charts values.yaml](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/values.yaml)
* [Example with custom configuration](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_sg_config)
* [Example with custom domains](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_service_certs)
* [Setup with custom CA certificate](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_ca)
* [Setup with custom Elasticsearch cluster nodes certificates](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_custom_elasticsearch_certs)
* [Setup with single certificates for Elasticsearch cluster nodes](https://git.floragunn.com/search-guard/search-guard-helm/-/tree/master/examples/setup_single_elasticsearch_cert)
* [./tools/sg_aws_kops.sh](https://git.floragunn.com/search-guard/search-guard-helm/-/blob/master/tools/sg_aws_kops.sh)
