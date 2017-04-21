<!---
Copryight 2017 floragunn UG (haftungsbeschränkt)
-->

# OpenSSL setup

Search Guard SSL can use Open SSL as the SSL implementation. This will result in better performance and better support for strong and modern cipher suites. With Open SSL it's also possible to use strong chipers without installing Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files. 

To enable native support for Open SSL follow these steps:

## Dynamically linked

**(Open SSL and Apache Portable Runtime needs to be installed)**

* If you are on Alpine Linux pls. refer to [this post](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/search-guard/dLr4SYeDMOE/915APogFBQAJ).
* Install latest 1.0.2 OpenSSL version on every node (1.0.1 does also work but is outdated.). OpenSSL 1.1.x is not supported currently.
 *  [https://www.openssl.org/community/binaries.html](https://www.openssl.org/community/binaries.html)
* Install APR, Apache Portable Runtime, (libapr1) on every node.
 * [https://apr.apache.org](https://apr.apache.org)
 * On Ubuntu, Apache Portable Runtime can be installed with `sudo apt-get install libapr1`.
* Download netty-tcnative for **your** platform and Search Guard version.
 * Linux (non fedora based): `_linux-x86.jar_` (Debian, Ubuntu, ...) 
 * Fedora based linux: `_64-fedora.jar_` (RHEL, CentOS)
 * Mac: `_osx-x86_64.jar_`
 * Windows: `_windows-x86_64.jar_`
 
### Search Guard 2:

 * Version: 1.1.33.Fork17
 * [http://repo1.maven.org/maven2/io/netty/netty-tcnative/1.1.33.Fork17/](http://repo1.maven.org/maven2/io/netty/netty-tcnative/1.1.33.Fork17/)
 * Choose the correct version for you platform, one of `_linux-x86.jar_`, `_64-fedora.jar_`, `_osx-x86_64.jar_`
 or `_windows-x86_64.jar_`.
 * Put it into the elasticsearch `plugins/searchguard-ssl/` folder on every node.
 
### Search Guard 5.0/5.1:

 * Version: 1.1.33.Fork23
 * [http://repo1.maven.org/maven2/io/netty/netty-tcnative/1.1.33.Fork23](http://repo1.maven.org/maven2/io/netty/netty-tcnative/1.1.33.Fork23)
 * http://repo1.maven.org/maven2/io/netty/netty-tcnative/1.1.33.Fork23/version, where version is one of `_linux-x86.jar_`, `_64-fedora.jar_`, `_osx-x86_64.jar_`
 or `_windows-x86_64.jar_`.
 
### Search Guard 5.2:

 * Version: 1.1.33.Fork25
 * [http://repo1.maven.org/maven2/io/netty/netty-tcnative/1.1.33.Fork25](http://repo1.maven.org/maven2/io/netty/netty-tcnative/1.1.33.Fork25)
 * Choose the correct version for you platform, one of `_linux-x86.jar_`, `_64-fedora.jar_`, `_osx-x86_64.jar_`.
 * Put it into the elasticsearch `plugins/search-guard-5/` folder on every node. 
* If you update the plugin (or re-install it after removal) don't forget to add netty-tcnative .jar again.
* Check that you have enabled OpenSSL in `elasticsearch.yml`.
 * `searchguard.ssl.transport.enable_openssl_if_available: true`
 * `searchguard.ssl.http.enable_openssl_if_available: true`

## Statically linked

**(Only works for non-fedora based linux, does not need Open SSL/Apache Portable Runtime to be installed)**

### Search Guard 2:

 * Download [netty-tcnative-openssl-static-1.1.33.Fork17-linux-x86_64.jar compiled with OpenSSL 1.0.2j
](https://github.com/floragunncom/sg-assets/blob/master/netty-tcnative-openssl-static-linux-x86_64/102k/netty-tcnative-openssl-static-1.1.33.Fork17-linux-x86_64.jar?raw=true). 

### Search Guard 5.0/5.1:

 * Download [netty-tcnative-openssl-static-1.1.33.Fork23-linux-x86_64.jar compiled with OpenSSL 1.0.2j
](https://github.com/floragunncom/sg-assets/blob/master/netty-tcnative-openssl-static-linux-x86_64/102k/netty-tcnative-openssl-static-1.1.33.Fork23-linux-x86_64.jar?raw=true).

### Search Guard 5.2:

 * Download [netty-tcnative-openssl-static-1.1.33.Fork25-linux-x86_64.jar compiled with OpenSSL 1.0.2k
](https://github.com/floragunncom/sg-assets/blob/master/netty-tcnative-openssl-static-linux-x86_64/102k/netty-tcnative-openssl-static-1.1.33.Fork25-linux-x86_64.jar?raw=true).

## Troubleshooting 

If you did all the steps above and start your nodes, you should see an entry similar to this in the logfile:

```
[INFO ][com.floragunn.searchguard.ssl.SearchGuardKeyStore] Open SSL OpenSSL 1.0.2d 9 Jul 2015 available
[INFO ][com.floragunn.searchguard.ssl.SearchGuardKeyStore] Open SSL available ciphers [ECDHE-RSA-AES256-GCM-SHA384,...
```

If one of the following messages OpenSSL is not available, Search Guard SSL will use the built-in Java SSL implementation:

#### java.lang.ClassNotFoundException: org.apache.tomcat.jni.SSL
* netty-tcnative jar is missing.
* Make sure you use the netty-tcnative jar **matching your platform**, either `_linux-x86.jar_` or `_64-fedora.jar_` or `_osx-x86_64.jar_` or `_windows-x86_64.jar_`. 

#### java.lang.UnsatisfiedLinkError
* OpenSSL is not installed.  See above.
* Apache Portable Runtime (APR) is not installed.  See above,

### Alpine Linux
Alpine Linux does not work out of the box. You need to compile the tc-native library yourself. Please refer to [this post](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/search-guard/dLr4SYeDMOE/915APogFBQAJ) and this github repository [https://github.com/pires/netty-tcnative-alpine](https://github.com/pires/netty-tcnative-alpine).

### Further reading
More about netty-tcnative can be found [here](http://netty.io/wiki/forked-tomcat-native.html).
