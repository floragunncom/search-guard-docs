---
title: Examples
permalink: sgctl-examples
layout: docs
edition: community
index: false
description: Examples for sgctl command line tool
---
<!---
Copyright 2022 floragunn GmbH
-->

# Using `sgctl` to Configure Search Guard
{: .no_toc}

{% include toc.md %}

## Modifying Search Guard configuration on the fly

Sometimes you need to modify only a single attribute of the Search Guard configuration. If you want to do so without editing files, you can use the `sgctl set` command.

A sample command looks like this:

```
./sgctl.sh set authc auth_domains.1.type "basic/ldap"
```


## Retrieving Search Guard Configuration

In order to retrieve the current configuration used by Search Guard, you can use the following command:

```shell
./sgctl.sh get-config -o sg-config
```

This will retrieve the Search Guard configuration and store it locally in a directory called `sg-config`.

## Uploading Search Guard Configuration

In order to upload Search Guard configuration from your local computer, you have several options:

If you only want to upload a single configuration file, use this command:

```shell
./sgctl.sh update-config sg-config/sg_internal_users.yml
```

You can also specify the directory to upload all Search Guard configuration files in that directory:

```
./sgctl.sh update-config sg-config
```

## Migrating legacy Search Guard Configuration

If you want to automatically migrate your legacy Search Guard configuration, you can use the `migrate-config` command:

```shell
./sgctl.sh migrate-config /path/to/legacy/sg-config.yml /path/to/legacy/kibana.yml
```

The command will the display the necessary update instructions. 

If you want to write the new configuration to local files, use the `-o` option:

```shell
./sgctl.sh migrate-config /path/to/legacy/sg-config.yml /path/to/legacy/kibana.yml -o /path/to/outputdir
```

You can choose the type of the target platform using the `--target-platform` option. Valid values are:

- `es`: Elasticsearch up to 7.10.x (default) 
- `es711`: Elasticsearch 7.11.0 and newer
- `os`: OpenSearch 

## Retrieving the Search Guard component state

The Search Guard component state can be useful when debugging issues with a cluster running Search Guard. You can retrieve it using the command.

```shell
./sgctl.sh component-state
```


## User administration

In order to get an internal user, you can use the following command:

```shell
./sgctl.sh get-user userName
```

In order to add a new internal user, you can use the following command:

```shell
./sgctl.sh add-user userName -r sg-role1,sg-role2 --backend-roles backend-role1,backend-role2 -a a=1,b.c.d=2,e=foo --password pass
```

In order to update an internal user, you can use the following command:

```shell
./sgctl.sh update-user userName -r sg-role1,sg-role2 --backend-roles backend-role1,backend-role2 -a a=1,b.c.d=2,e=foo --password pass
```

In order to delete an internal user, you can use the following command:

```shell
./sgctl.sh delete-user userName
```

## REST Client

Sgctl comes with a REST client to perform REST calls on the cluster. Supported Methods are:

| Command                | Required additional parameters                     | Description                              |
|------------------------|----------------------------------------------------|------------------------------------------|
| ./sgctl.sh rest get    | none                                               | Performs a get request on the cluster    |
| ./sgctl.sh rest put    | input via `--json`, `--input` or `--clon` needed   | Performs a put request on the cluster    |
| ./sgctl.sh rest delete | none                                               | Performs a delete request on the cluster |
| ./sgctl.sh rest post   | optional input via `--json`, `--input` or `--clon` | Performs a post request on the cluster   |
| ./sgctl.sh rest patch  | input via `--json`, `--input` or `--clon` needed   | Performs a patch request on the cluster  |

### CLON (Command Line Object Notation)

CLON is an object notation for creating e.g. JSON strings based on easy writable expressions. A CLON expression always consists of a `key` and a `value`.
 
**Key value example:**

```shell
./sgctl.sh rest put /endpoint --clon key=value
```
Result:
```json
{
  "key": "value"
}
```

#### Keys

CLON also supports array and object keys to create complex object structures in simple expressions.

**Array key example:**
```shell
./sgctl rest put /endpoint --clon names[]=kirk names[]=john
```
Result:
```json
{
  "names": [
    "kirk", "john"
  ]
}
```

**Object key example:**
```shell
./sgctl rest put /endpoint --clon person[age]=20 person[name]=max
```
Result:
```json
{
  "person": {
    "age": 20,
    "name": "max"
  }
}
```

#### Values

Supported value types are `string`, `boolean`, `number` and `null`. In order to set more complex values at once there are also array and object values available.

**Array value example:**
```shell
./sgctl rest put /endpoint --clon important_people=[philipp,daniel,ole]
```
Result:
```json
{
  "important_people": [
    "philipp", "daniel", "ole"
  ]
}
```

**Object value example:**
```shell
./sgctl rest put /endpoint --clon car=[speed=167.5,range=500,electric=true,name=speedo]
```
Result:
```json
{
  "car": {
    "speed": 167.5,
    "range": 500,
    "electric": true,
    "name": "speedo"
  }
}
```
