# Removing Enterprise modules

If you want to deploy only the features you actually plan to use, you can remove the Enterprise jar files for all other features from your Search Guard installation.

The jar files can be found in the folder

* `<ES installation directory>/plugins/search-guard-6`

The enterprise modules start with `dlic-search-guard*`, for example

```
dlic-search-guard-authbackend-ldap-6.0.0-7.jar 
```

To disable a module, remove the respective jar file from the `search-guard-6` directory and restart the node.