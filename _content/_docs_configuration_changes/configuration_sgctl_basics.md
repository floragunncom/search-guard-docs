---
title: Basic Usage
permalink: sgctl
category: sgctl
order: 100
layout: docs
edition: community
index: false
description: Use the powerful and easy-to-use sgctl command line tool to manage and configure  everything in Search Guard.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Using `sgctl` to Configure Search Guard
{: .no_toc}

{% include toc.md %}


The `sgctl` tool provides you a broad set of tools to achieve administrative task on your cluster secured by Search Guard. The most important task is probably uploading the Search Guard configuration to the Search Guard configuration index. [Here you can find the source code alongside with a comprehensive readme](https://git.floragunn.com/search-guard/sgctl){:target="_blank"}.

You have to download `sgctl` separately at [https://maven.search-guard.com/search-guard-flx-release/com/floragunn/sgctl/](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/sgctl/).

The `sgctl` tool provides a set of commands. To get an overview of all commands, just execute `sgctl.sh` on the command line:

```
$ ./sgctl.sh

Usage: sgctl [COMMAND]
Remote control tool for Search Guard
Commands:
  connect          Tries to connect to a cluster and persists this connection
                     for subsequent commands
  get-config       Retrieves Search Guard configuration from the server to
                     local files
  update-config    Updates Search Guard configuration on the server from local
                     files
  migrate-config   Converts old-style sg_config.yml and kibana.yml into
                     sg_authc.yml and sg_frontend_authc.yml
  component-state  Retrieves Search Guard component status information
  sgctl-licenses   Displays license information for sgctl
  sgctl-version    Shows the version of this sgctl command
  add-user-local   Adds a new user to a local sg_internal_users.yml file
  add-user         Adds a new user
  update-user      Updates a user
  delete-user      Deletes a user
  add-var          Adds a new configuration variable
  update-var       Updates an existing configuration variable
  delete-var       Deletes an existing configuration variable
  set              Modifies a property in the Search Guard Configuration
  update-license   Updates the SG license
  rest             REST client for administration
  special          Commands for special circumstances
```

To get help for a particular command just append the `--help` option to the command:

```
$ ./sgctl.sh connect --help

Usage: sgctl connect [-v] [--debug] [--skip-connection-check] [-k[=<insecure>]]
                     [--key-pass[=<clientKeyPass>]] [-c=<clusterIdOption>]
                     [--ca-cert=<caCert>] [-E=<clientCert>] [-h=<host>]
                     [--key=<clientKey>] [-p=<serverPort>]
                     [--sgctl-config-dir=<customConfigDir>] [--tls=<tls>]
                     [--ciphers[=<ciphers>...]]... [<server>]
Tries to connect to a cluster and persists this connection for subsequent
commands
      [<server>]            Name of the server to connect to.
  -c, --cluster=<clusterIdOption>
                            The ID of the cluster configuration to be used by
                              this command
      --ca-cert=<caCert>    Trusted certificates
      --ciphers[=<ciphers>...]
                            The ciphers to be allowed for the TLS connection to
                              the cluster
      --debug               Print debug information
  -E, --cert=<clientCert>   Client certificate for admin authentication
  -h, --host=<host>         Hostname of the node to connect to
  -k, --insecure[=<insecure>]
                            Do not verify the hostname when connecting to the
                              cluster
      --key=<clientKey>     Private key for admin authentication
      --key-pass[=<clientKeyPass>]
                            Password for private key
  -p, --port=<serverPort>   REST port to connect to. Default: 9200
      --sgctl-config-dir=<customConfigDir>
                            The directory where sgctl reads from and writes to
                              its configuration
      --skip-connection-check
                            Skips initial REST API call to check the connection
      --tls=<tls>           The TLS version to use when connecting to the
                              cluster
  -v, --verbose             Print more information
```



You can find sample sgctl calls in the [examples chapter](sgctl-examples)


## Connection Settings

`sgctl` is able to store and automatically re-use the basic connection settings for a cluster. In order to initially set up a connection to a cluster, execute `sgctl` this way:

```bash
$ ./sgctl.sh connect localhost --ca-cart /path/to/root-ca.pem --cert /path/to/admin-cert.pem --key /path/to/admin-cert-private-key.pem
```

You need to replace the path specifications by paths to the certificate of the root CA which signed the TLS certificates by your cluster (`--ca-cert`)  and by an admin 
certificate and its corresponding private key (`--cert` and `--key`). If the private key is password protected, specify `--key-pass` to be get a request for the password on the command line.

By default, `sgctl` will check that the host name of the target host matches the name specified in its TLS certificate. If you want to disable this check - for example because you are just on a test system with test certificates - specify the option `--insecure` on the command line.

If the Elasticsearch REST port is not the default 9200, you also need to specify the port using the `-p` parameter.

If the connection is successful, the command should print `Connected as CN=kirk,OU=client,O=client,L=test,C=de` and store the connection configuration for future
use. The connection settings are stored in the `.searchguard` directory inside your home directory. You can test this by just executing:

```bash
$ ./sgctl.sh connect
```

### Managing Connection Settings for Several Clusters

`sgctl` makes it easy to manage several clusters at once. To connect to another cluster, just type:

```bash
$ ./sgctl.sh connect another-cluster-host.example.com --ca-cart /another/path/to/root-ca.pem --cert /another/path/to/admin-cert.pem --key /another/path/to/admin-cert-private-key.pem
```

This will now connect to this cluster and store the connection settings separately. From now on, in order to switch between both clusters, just type:


```bash
$ ./sgctl.sh connect localhost
```

or


```bash
$ ./sgctl.sh connect another-cluster-host.example.com
```

**Note:** By default, `sgctl` uses the host name as identifier of the cluster. If you want to use your own identifiers, you can use the `-c` option to specify it:

```bash
$ ./sgctl.sh connect -c my-cluster 2001:0db8:85a3:0000:0000:8a2e:0370:7334 --ca-cart /another/path/to/root-ca.pem --cert /another/path/to/admin-cert.pem --key /another/path/to/admin-cert-private-key.pem
```

Reconnect with:

```bash
$ ./sgctl.sh connect -c my-cluster
```

## Uploading Search Guard configuration

The most important command of `sgctl` is probably `sgctl update-config`. This command is used to upload Search Guard YAML configuration files to Search Guard. 

You can specify single files to be uploaded:

```bash
$ ./sgctl.sh update-config path/to/config/dir/sg_internal_users.yml path/to/config/dir/sg_roles.yml
```

... or also or a whole directory:

```bash
$ ./sgctl.sh update-config path/to/config/dir/
```
<!--
Modifying Search Guard configuration on the fly

Sometimes you need to modify only a single attribute of the Search Guard configuration. If you want to do so without editing files, you can use the `sgctl set` command.

A sample command looks like this:

```
$ ./sgctl.sh set 
```

--->