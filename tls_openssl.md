<!---
Copryight 2015-2017 floragunn GmbH
-->

# OpenSSL setup

Search Guard supports OpenSSL. Using OpenSSL will result in better performance and better support for strong and modern cipher suites when compared JCE. We recommend to use OpenSSL for production systems.

# Enabling OpenSSL

## Dynamically linked

**(Open SSL and Apache Portable Runtime (apr) needs to be installed)**

* If you are on Alpine Linux please refer to [this post](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/search-guard/dLr4SYeDMOE/915APogFBQAJ). We recommend to use our statically linked version below because Alpine comes normally with LibreSSL instead of OpenSSL installed. LibreSSL may work but is not officially supported and untested. Also make sure you have installed 'libuuid' on Alpine accoring to [this post](https://groups.google.com/forum/#!msg/search-guard/dLr4SYeDMOE/Eai_oWmBBwAJ)

* Open SSL on Windows may work but is not officially supported and untested. Refer to [netty-tcnative wiki](http://netty.io/wiki/forked-tomcat-native.html) for more infos.

* Install latest 1.0.2 OpenSSL version on every node (1.0.1 does also work but is outdated and may lack hostname validation functionality). OpenSSL 1.1.x is not supported currently.
  * [https://www.openssl.org/community/binaries.html](https://www.openssl.org/community/binaries.html)
* Install APR - Apache Portable Runtime on every node
  * [https://apr.apache.org](https://apr.apache.org)
  * On Debian/Ubuntu, Apache Portable Runtime can be installed with `sudo apt-get install libapr1`
  * On RHEL/CentOS/Fedora, Apache Portable Runtime can be installed with `sudo yum install apr`
* Download netty-tcnative for **your** platform and Search Guard version
  * Linux (non fedora based): `_linux-x86_64.jar_` (Debian, Ubuntu, ...)
  * Fedora based linux: `_linux-x86_64-fedora.jar_` (RHEL, CentOS, Fedora)
  * Mac: `_osx-x86_64.jar_`
  * Windows: `_windows-x86_64.jar_`
  * Alpine: Compile it yourself (or use statically linked version below)

* **Search Guard 6.0.0 and higher (Open SSL 1.0.2):**  
  * Version: 2.0.5.Final (compiled against Open SSL 1.0.2 which supports hostname validation)
  * [Download for Debian/Ubuntu](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2-dynamic-2.0.5.Final-non-fedora-linux-x86_64.jar)
  * [Download for CentOS/RHEL/Fedora](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2-dynamic-2.0.5.Final-fedora-linux-x86_64.jar)
  * Put it into the elasticsearch `plugins/search-guard-5/` folder on every node

* **Search Guard 6.0.0 and higher (Open SSL 1.0.1):**
  * Version: 2.0.5.Final (compiled against Open SSL 1.0.1 which lacks hostname validation)
  * [http://repo1.maven.org/maven2/io/netty/netty-tcnative/2.0.5.Final](http://repo1.maven.org/maven2/io/netty/netty-tcnative/2.0.5.Final)
  * Choose the correct version for you platform, one of `_linux-x86_64.jar_`, `_linux-x86_64-fedora.jar_`, `_osx-x86_64.jar_` or `_windows-x86_64.jar_`
  * Put it into the elasticsearch `plugins/search-guard-5/` folder on every node

If you update the plugin (or re-install it after removal) don't forget to add netty-tcnative .jar again

## Statically linked (Linux only)

**(Does not need Open SSL/Apache Portable Runtime (apr) to be installed on the server)**

* **Search Guard 6.0.0 and higher:**
  * [Alpine (2.0.5.Final compiled with OpenSSL 1.0.2l)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2l-static-2.0.5.Final-alpine-linux-x86_64.jar)
  * [Debian/Ubuntu (2.0.5.Final compiled with OpenSSL 1.0.2l)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2l-static-2.0.5.Final-non-fedora-linux-x86_64.jar)
  * [CentOS/RHEL/Fedora (2.0.5.Final compiled with OpenSSL 1.0.2l)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2l-static-2.0.5.Final-fedora-linux-x86_64.jar)
Put it into the elasticsearch `plugins/search-guard-ssl/` or `plugins/search-guard-5/` folder on every node

If you update the plugin (or re-install it after removal) don't forget to add netty-tcnative .jar again

## LibreSSL

May work well but not officially supported. We have a few static builds here https://dl.bintray.com/floragunncom/netty-tcnative/ but only consider to use them if you run in trouble with OpenSSL.

## BoringSSL

May work well but not officially supported. Binaries are provided [here](http://search.maven.org/#search%7Cga%7C1%7Ca%3A%22netty-tcnative-boringssl-static%22) by the netty project. 

## Troubleshooting

Check that you have enabled OpenSSL in `elasticsearch.yml` (which is the default)
  * `searchguard.ssl.transport.enable_openssl_if_available: true`
  * `searchguard.ssl.http.enable_openssl_if_available: true`

If you did all the steps above and start your nodes, you should see an entry similar to this in the logfile:

```
[INFO ][com.floragunn.searchguard.ssl.SearchGuardKeyStore] Open SSL OpenSSL 1.0.2d 9 Jul 2015 available
[INFO ][com.floragunn.searchguard.ssl.SearchGuardKeyStore] Open SSL available ciphers [ECDHE-RSA-AES256-GCM-SHA384,...
```

If you see one of those two error messages in the logfile, OpenSSL is not available and we fall back to JCE. 


### java.lang.ClassNotFoundException: org.apache.tomcat.jni.SSL
* netty-tcnative jar is missing
* make sure you use the netty-tcnative jar **matching your platform**, either `_linux-x86_64.jar_` or `_linux-x86_64-fedora.jar_` or `_osx-x86_64.jar_` or `_windows-x86_64.jar_`

### java.lang.UnsatisfiedLinkError
* OpenSSL is not installed.  See above.
* Apache Portable Runtime (APR) is not installed.  See above.
* Make sure your /tmp directory is writeable and not mounted with noexec
* If you run inside a docker container AUFS filesystem for /tmp can make trouble

### Further reading
More about netty-tcnative can be found [here](http://netty.io/wiki/forked-tomcat-native.html).
