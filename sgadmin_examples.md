---
redirect_to:
  - http://docs.search-guard.com/latest/sgadmin-examples
---

# sgadmin Examples

#### Apply default configuration with Keystore and Truststore files
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

#### Apply default configuration with PEM certificates
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

#### Apply single file to cluster named "myclustername"
```
./sgadmin.sh \ \
   -f /path/to/sg_internal_users.yml \
   -t internalusers \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks \
   -tspass changeit
   -cn myclustername \
   -nhnv
```

#### Apply single file, ignoring clustername but specifying host and port
```
./sgadmin.sh \
   -h esnode1.mycompany.com \
   -p 9301 \
   -f /path/to/updated_internal_users.yml \
   -t internalusers \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks \
   -tspass changeit
   -icl
```
#### Retrieving the current active Search Guard configuration from a cluster
```
./sgadmin.sh \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks  \
   -tspass changeit
   -r
```

#### Reload the current configuration, thus flushing the Search Guard user caches

```
plugins/search-guard-2/tools/sgadmin.sh \
   -ks plugins/search-guard-2/sgconfig/keystore.jks \
   -kspass changeit
   -ts plugins/search-guard-2/sgconfig/truststore.jks  \
   -tspass changeit
   -r  
```

#### Setting the number of replica shards to 5
```
./sgadmin.sh \
   -ks /path/to/keystore.jks \
   -kspass changeit
   -ts /path/to/truststore.jks \
   -tspass changeit
   -us 5
```

#### Enabling replica auto expansion
```
plugins/search-guard-2/tools/sgadmin.sh \
   -ks plugins/search-guard-2/sgconfig/keystore.jks \
   -kspass changeit
   -ts plugins/search-guard-2/sgconfig/truststore.jks \
   -tspass changeit
   -era
```
