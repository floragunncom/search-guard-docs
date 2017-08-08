<!---
Copryight 2017 floragunn GmbH
-->

# Index alias handling

Search Guard will resolve any aliases on any index to their underlying index name. This makes sure that all security related checks apply in all situations. The same is true for 

* Index wildcards, also with multiple index names
  * e.g. `https://localhost:9200/i*ex*,otherindex/_search` 
* Date math index names
  * e.g.  `https://localhost:9200/<logstash-{now/d}>/_search/_search`
* Filtered index aliases 

## Handling multiple filtered index aliases

Filtered index aliases can be used to filter some documents from the underlying index. However, **using filteres aliases is not a secure way to restrict access to certain documents**. In order to do that, please use the [Document Level Security](dlsfls.md) feature of Search Guard.

Because of this potential security leak, Search Guard detects and treats multiple filtered index aliases in a special way. You can either disallow them completely, or issue a warning message on `WARN` or `DEBUG` level.

The following entry in sg_config can be used to configure this:

```
 searchguard:
    dynamic:		    
      filtered_alias_mode: <warn|nowarn|disallow
```

| Name  | Description  |
|---|---|
| disallow | forbids multiple filtered index aliases completely |
| warn | default, logs a warning message if multiple filtered index aliases are detected on `WARN` level |
| nowarn | logs a warning message if multiple filtered index aliases are detected on `DEBUG` level |      