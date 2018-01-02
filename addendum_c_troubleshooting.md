---
redirect_to:
  - http://docs.search-guard.com/latest/troubleshooting-openssl
---


## Troubleshooting

Start Elasticsearch as normal, and watch the logfile. The nodes should start up without error. You can safely ignore the following infos and warnings in the logfile:

```
INFO: Open SSL not available because of java.lang.ClassNotFoundException:
 org.apache.tomcat.jni.SSL
```

By default, OpenSSL support is enabled, and Search Guard tries to use

This means that you use JCE (Java Cryptography extensions) as your TLS implementation. On startup, SG looks for OpenSSL support on your system. Since we have not installed it yet, SG falls back to the built-in Java SSL implementation.

```
WARN: AES 256 not supported, max key length for AES is 128.
To enable AES 256 install 'Java Cryptography Extension (JCE)
Unlimited Strength Jurisdiction Policy Files'
```

If you use Oracle JDK, the length of the cryptographic keys is is limited for judical reasons. You'll have to install the [Java Cryptography Extension (JCE)
Unlimited Strength Jurisdiction Policy Files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) to use longer keys. For our quickstart tutorial, you can ignore this warning for the moment.

**Congrats. Your ES nodes now talk TLS to each other on the transport layer!**

We have not configured HTTPS for the REST-API yet, so you can still access ES via a browser (or curl for that matter) as usual by typing

```
http://127.0.0.1:9200/
```

You can display some configuration information from SG SSL directly by visiting:

```
http://127.0.0.1:9200/_searchguard/sslinfo?pretty
```

Which should display something like this:

![SSL infos 1](images/sg_ssl_infos_1.png)


