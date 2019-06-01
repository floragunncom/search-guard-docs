---
title: sgadmin Examples
slug: sgadmin-examples
category: configuration
order: 200
layout: docs
edition: community
description: Example sgadmin calls to manage the Search

---
<!---
Copyright 2019 floragunn GmbH
-->
# sgadmin Examples
{: .no_toc}

{% include toc.md %}


## Apply default configuration with PEM certificates
```
./sgadmin.sh \
   -cd /path/to/sgconfig/ \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -nhnv
   -icl
```
## Apply default configuration with Keystore and Truststore files
```
./sgadmin.sh \
   -cd /path/to/sgconfig/ \
   -ks /path/to/keystore.jks \
   -kspass changeit \
   -ts /path/to/truststore.jks \
   -tspass changeit
   -nhnv
   -icl
```

## Apply single file to cluster named "myclustername"
```
./sgadmin.sh \
   -f /path/to/sg_internal_users.yml \
   -t internalusers \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -cn myclustername \
   -nhnv
```

## Apply single file, ignoring clustername but specifying host and port
```
./sgadmin.sh \
   -h esnode1.mycompany.com \
   -p 9301 \
   -f /path/to/updated_internal_users.yml \
   -t internalusers \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -icl
```
## Retrieving the current active Search Guard configuration from a cluster
```
./sgadmin.sh \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -r
```

## Reload the current configuration and flushing the Search Guard user caches

```
./sgadmin.sh \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -rl
```

## Setting the number of replica shards to 5
```
./sgadmin.sh \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -us 5
```

## Enabling replica auto expansion
```
./sgadmin.sh \
   -cacert /path/to/root-ca.pem \
   -cert /path/to/kirk.crt.pem \
   -key /path/to/kirk.key.pem  \
   -keypass changeit
   -era
```
