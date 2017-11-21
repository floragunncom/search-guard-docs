# Search Guard Community Edition

The Community Edition of Search Guard is free, and you can use it for production and non-production systems. It includes TLS encryption on REST and on transport layer, HTTP Basic Authentication, the Internal User Database authentication backend and Kibana session management.

The Community Edition does not require a license. To use it, simply disable all enterprise features by adding the following line to `elasticsearch.yml` and restart the node:

```
searchguard.enterprise_modules_enabled: false
```

By setting this flag you can be sure to run the free features of Search Guard only. It will disable any Enterprise module or custom authentication domain.

In addition, you can also remove the jar files containing the Enterprise modules from your Search Guard installation.

The jar files can be found in the folder

* `<ES installation directory>/plugins/search-guard-6`

The enterprise modules start with `dlic-search-guard`, for example

```
dlic-search-guard-authbackend-ldap-6.0.0-7.jar 
```
To disable the modules, remove the respective jar file(s) from the `search-guard-6` directory and restart the nodes.