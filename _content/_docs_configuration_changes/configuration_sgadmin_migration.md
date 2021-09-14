---
title: Migrating configuration files
html_title: Configuration Migration
slug: sgadmin
category: sgadmin
order: 500
layout: docs
edition: community
description: You can use sgadmin to migrate Search Guard 6 configuration files to the Search Guard 7 format automatically.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Migrating configuration files
{: .no_toc}

{% include toc.md %}

If you upgrade from Search Guard 6 to Search Guard 7, you can automatically migrate your existing configuration files to the new syntax.

## Offline migration

sgadmin can migrate existing files offline, for example after you run a [configuration backup](configuration_sgadmin_configuration_changes.md) on an OpenSearch/Elasticsearch 6.x cluster. After the files have been migrated, you can upload them to an OpenSearch/Elasticsearch 7.x cluster. 

```bash
./sgadmin.sh \
    --migrate-offline /path/to/configdirectory/  \
    -cacert /path/to/root-ca.pem \
    -cert /path/to/admin-certificate.pem \
    -key /path/to/admin-certificate-key.pem    
```

Example:

```bash
./sgadmin.sh \
    -mo ../sgconfig/  \
    -cacert ../../../root-ca.pem \
    -cert ../../../kirk.pem \
    -key ../../../kirk.key.pem    
```


| Name | Description |
|---|---|
| -mo/--migrate-offline <folder> | Migrate configuration files in <folder> from version 6 to version 7.|
{: .config-table}

## Online migration

When upgrading from Search Guard 6 to Search Guard 7, you can use sgadmin to fully automate the migration process. Search Guard for OpenSearch/Elasticsearch 7 is able to read both v6 and v7 configuration format, however, it is strongly recommended to migrate the configuration files after you upgraded your cluster. This command will:

* Connect to your running OpenSearch/Elasticsearch 7 cluster
* Download the legacy v6 Search Guard configuration
* Perform an offline migration
* Upload the migrated v7 configuration


```bash
./sgadmin.sh \
    --migrate-offline /path/to/configdirectory/  \
    -cacert /path/to/root-ca.pem \
    -cert /path/to/admin-certificate.pem \
    -key /path/to/admin-certificate-key.pem    
```

| Name | Description |
|---|---|
| -migrate | Perform configuration migration from version 6 to version 7.|
{: .config-table}

