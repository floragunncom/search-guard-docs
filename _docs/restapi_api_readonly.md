---
title: Readonly / reserved resources
slug: rest-api-readonly-reserved
category: restapi
order: 310
layout: docs
edition: enterprise
description: How to use the readonly flag to protect Search Guard resources from being overwritten.
---
<!---
Copyright 2017 floragunn GmbH
-->

# Reserved / readonly resources

You can mark any user, role, action group or roles mapping as `readonly` in their respective configuration files. Resources that have this flag set to true can not be changed via the REST API and are marked as `reserved` in the Kibana Configuration GUI.

You can use this feature to give users or customers permission to add and edit their own users and roles, while making sure your own built-in resources are left untouched. For example, it makes sense to mark the Kibana server user as `readonly`.

To mark a resource `readonly`, add the following flag:

```yaml
sg_kibana_user:
  readonly: true
  ...
```

To add or remove the readonly flag, you need to use `sgadmin`. 