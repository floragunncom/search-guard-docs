---
title: OpenSSL Troubleshooting
permalink: troubleshooting-openssl
category: troubleshooting
order: 150
layout: troubleshooting
description: Step-by-step instructions on how to troubleshoot OpenSSL issues for a Search Guard secured OpenSearch/Elasticsearch cluster. 
---

<!--- Copyright 2020 floragunn GmbH -->

# OpenSSL Troubleshooting

Check that you have enabled OpenSSL in `opensearch.yml`/`elasticsearch.yml` (which is the default)
  * `searchguard.ssl.transport.enable_openssl_if_available: true`
  * `searchguard.ssl.http.enable_openssl_if_available: true`

If you did all the steps above and start your nodes, you should see an entry similar to this in the logfile:

```
[INFO ][com.floragunn.searchguard.ssl.SearchGuardKeyStore] Open SSL OpenSSL 1.0.2d 9 Jul 2015 available
[INFO ][com.floragunn.searchguard.ssl.SearchGuardKeyStore] Open SSL available ciphers [ECDHE-RSA-AES256-GCM-SHA384,...
```

If you see one of those two error messages in the logfile, OpenSSL is not available and we fall back to JCE. 


## java.lang.ClassNotFoundException: org.apache.tomcat.jni.SSL
* netty-tcnative jar is missing
* make sure you use the netty-tcnative jar **matching your platform**, either `_linux-x86_64.jar_` or `_linux-x86_64-fedora.jar_` or `_osx-x86_64.jar_` or `_windows-x86_64.jar_`

## java.lang.UnsatisfiedLinkError
* OpenSSL is not installed.  See above.
* Apache Portable Runtime (APR) is not installed.  See above.
* Make sure your /tmp directory is writeable and not mounted with noexec
* If you run inside a docker container AUFS filesystem for /tmp can make trouble

## Further reading
More about netty-tcnative can be found [here](http://netty.io/wiki/forked-tomcat-native.html){:target="_blank"}.