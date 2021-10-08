---
title: OpenSSL
slug: openssl
category: tls
order: 400
layout: docs
edition: community
description: Search Guard supports native OpenSSL for superior performance and most modern cipher suites for production systems.
---
<!---
Copyright 2017 floragunn GmbH
-->

# OpenSSL setup
{: .no_toc}

{% include_relative _includes/toc.md %}

Search Guard supports OpenSSL. Using OpenSSL will result in better performance and better support for strong and modern cipher suites when compared JCE. We recommend to use OpenSSL for production systems.

## Dynamically linked

**(Open SSL and Apache Portable Runtime (apr) needs to be installed)**

* If you are on Alpine Linux please refer to [this post](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/search-guard/dLr4SYeDMOE/915APogFBQAJ){:target="_blank"}. We recommend to use our statically linked version below because Alpine comes normally with LibreSSL instead of OpenSSL installed. LibreSSL may work but is not officially supported and untested. Also make sure you have installed 'libuuid' on Alpine accoring to [this post](https://groups.google.com/forum/#!msg/search-guard/dLr4SYeDMOE/Eai_oWmBBwAJ){:target="_blank"}.

* Open SSL on Windows may work but is not officially supported and untested. Refer to [netty-tcnative wiki](http://netty.io/wiki/forked-tomcat-native.html){:target="_blank"} for more infos.

* Install latest 1.0.2 OpenSSL version on every node (1.0.1 does also work but is outdated and may lack hostname validation functionality). OpenSSL 1.1.0 is supported for ES >= 6.5.0. OpenSSL 1.1.1 is not supported currently.
  * [https://www.openssl.org/community/binaries.html](https://www.openssl.org/community/binaries.html){:target="_blank"}
* Install APR - Apache Portable Runtime on every node
  * [https://apr.apache.org](https://apr.apache.org){:target="_blank"}
  * On Debian/Ubuntu, Apache Portable Runtime can be installed with `sudo apt-get install libapr1`
  * On RHEL/CentOS/Fedora, Apache Portable Runtime can be installed with `sudo yum install apr`
* Download netty-tcnative for **your** platform and Search Guard version
  * Linux (non fedora based): `_linux-x86_64.jar_` (Debian, Ubuntu, ...)
  * Fedora based linux: `_linux-x86_64-fedora.jar_` (RHEL, CentOS, Fedora)
  * Mac: `_osx-x86_64.jar_`
  * Windows: `_windows-x86_64.jar_`
  * Alpine: Compile it yourself (or use statically linked version below)

* **Search Guard 6.6.x and higher (Open SSL 1.1.0):**
  * Version: 2.0.20.Final (compiled against Open SSL 1.1.0 which supports hostname validation)
  * [Download for Debian/Ubuntu](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-dynamic-2.0.20.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [Download for CentOS/RHEL/Fedora](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-dynamic-2.0.20.Final-fedora-linux-x86_64.jar){:target="_blank"}
  * Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node


* **Search Guard 6.5.x and higher (Open SSL 1.1.0):**
  * Version: 2.0.15.Final (compiled against Open SSL 1.1.0 which supports hostname validation)
  * [Download for Debian/Ubuntu](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-dynamic-2.0.15.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [Download for CentOS/RHEL/Fedora](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-dynamic-2.0.15.Final-fedora-linux-x86_64.jar){:target="_blank"}
  * Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

* **Search Guard 6.2.x,6.3.x,6.4.x (Open SSL 1.0.1):**
  * Version: 2.0.7.Final (compiled against Open SSL 1.0.1 which lacks hostname validation)
  * [http://repo1.maven.org/maven2/io/netty/netty-tcnative/2.0.7.Final](http://repo1.maven.org/maven2/io/netty/netty-tcnative/2.0.7.Final){:target="_blank"}
  * Choose the correct version for you platform, one of `_linux-x86_64.jar_`, `_linux-x86_64-fedora.jar_`, `_osx-x86_64.jar_` or `_windows-x86_64.jar_`
  * Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

* **Search Guard 6.2.x,6.3.x,6.4.x (Open SSL 1.0.2):**  
  * Version: 2.0.7.Final (compiled against Open SSL 1.0.2 which supports hostname validation)
  * [Download for Debian/Ubuntu](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2-dynamic-2.0.7.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [Download for CentOS/RHEL/Fedora](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2-dynamic-2.0.7.Final-fedora-linux-x86_64.jar){:target="_blank"}
  * Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

* **Search Guard 6.1.x (Open SSL 1.0.2):**  
  * Version: 2.0.5.Final (compiled against Open SSL 1.0.2 which supports hostname validation)
  * [Download for Debian/Ubuntu](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2-dynamic-2.0.5.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [Download for CentOS/RHEL/Fedora](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2-dynamic-2.0.5.Final-fedora-linux-x86_64.jar){:target="_blank"}
  * Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

* **Search Guard 6.1.x (Open SSL 1.0.1):**
  * Version: 2.0.5.Final (compiled against Open SSL 1.0.1 which lacks hostname validation)
  * [http://repo1.maven.org/maven2/io/netty/netty-tcnative/2.0.5.Final](http://repo1.maven.org/maven2/io/netty/netty-tcnative/2.0.5.Final){:target="_blank"}
  * Choose the correct version for you platform, one of `_linux-x86_64.jar_`, `_linux-x86_64-fedora.jar_`, `_osx-x86_64.jar_` or `_windows-x86_64.jar_`
  * Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

If you update the plugin (or re-install it after removal) don't forget to add netty-tcnative .jar again

## Statically linked (Linux only)

**(Does not need Open SSL/Apache Portable Runtime (apr) to be installed on the server)**

* **Search Guard 6.6.x and higher:**
  * [Debian/Ubuntu (2.0.20.Final compiled with OpenSSL 1.1.0j)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-static-2.0.20.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [CentOS/RHEL/Fedora (2.0.20.Final compiled with OpenSSL 1.1.0j)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-static-2.0.20.Final-fedora-linux-x86_64.jar){:target="_blank"}
Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node


* **Search Guard 6.5.x and higher:**
  * [Debian/Ubuntu (2.0.15.Final compiled with OpenSSL 1.1.0j)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-static-2.0.15.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [CentOS/RHEL/Fedora (2.0.15.Final compiled with OpenSSL 1.1.0j)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.1.0j-static-2.0.15.Final-fedora-linux-x86_64.jar){:target="_blank"}
Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

* **Search Guard 6.2.x,6.3.x,6.4.x:**
  * [Alpine (2.0.7.Final compiled with OpenSSL 1.0.2n)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2n-static-2.0.7.Final-alpine-linux-x86_64.jar){:target="_blank"}
  * [Debian/Ubuntu (2.0.7.Final compiled with OpenSSL 1.0.2n)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2n-static-2.0.7.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [CentOS/RHEL/Fedora (2.0.7.Final compiled with OpenSSL 1.0.2n)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2n-static-2.0.7.Final-fedora-linux-x86_64.jar){:target="_blank"}
Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

* **Search Guard 6.1.x:**
  * [Alpine (2.0.5.Final compiled with OpenSSL 1.0.2n)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2n-static-2.0.5.Final-alpine-linux-x86_64.jar){:target="_blank"}
  * [Debian/Ubuntu (2.0.5.Final compiled with OpenSSL 1.0.2n)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2n-static-2.0.5.Final-non-fedora-linux-x86_64.jar){:target="_blank"}
  * [CentOS/RHEL/Fedora (2.0.5.Final compiled with OpenSSL 1.0.2n)](https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2n-static-2.0.5.Final-fedora-linux-x86_64.jar){:target="_blank"}
Put it into the elasticsearch `plugins/search-guard-{{site.searchguard.esmajorversion}}/` folder on every node

If you update the plugin (or re-install it after removal) don't forget to add netty-tcnative .jar again

## LibreSSL

May work well but not officially supported. We have a few static builds [here](https://dl.bintray.com/floragunncom/netty-tcnative/) but only consider to use them if you run in trouble with OpenSSL.

## BoringSSL

May work well but not officially supported. Binaries are provided [here](http://search.maven.org/#search%7Cga%7C1%7Ca%3A%22netty-tcnative-boringssl-static%22){:target="_blank"} by the netty project. 
