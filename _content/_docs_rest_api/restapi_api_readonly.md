---
title: Reserved and hidden resources
slug: rest-api-reserved-hidden
category: restapi
order: 310
layout: docs
edition: enterprise
description: How to use the reserved and hidden flag to protect Search Guard resources from being overwritten.
---
<!---
Copyright 2019 floragunn GmbH
-->

# Reserved and hidden resources
{: .no_toc}

{% include toc.md %}

## Reserved resources

You can mark any user, role, action group or roles mapping as `reserced` in their respective configuration files. Resources that have this flag set to true can not be changed via the REST API and are marked as `reserved` in the Kibana Configuration GUI.

You can use this feature to give users or customers permission to add and edit their own users and roles, while making sure your own built-in resources are left untouched.

To mark a resource `readonly`, add the following flag:

```yaml
sg_my_role:
  reserved: true
  ...
```

To change the `reserved` flag you need to use sgadmin.
{: .note .js-note .green}

## Hidden resources

Any resource can be marked *hidden*. As the name implies, a hidden resource

* is removed from any API GET request result
  * when querying for a single hidden resource, a `404` is returned
  * when querying for all resources, hidden resources are filtered from the result set
* cannot be deleted
  * a `404` is returned instead
* cannot be changed
  * a `403` is returned instead 

Hidden resources are most useful if you want to give end users access to the REST API, but you want to hide some of the service users your platform is using. For example, the Kibana server user or the logstash user.

To change the `reserved` flag you need to use sgadmin.
{: .note .js-note .green}

Example:

```yaml
sg_my_role:
  hidden: true
  ...
```  

## Static resources

The Search Guard built-in roles and and action groups are marked `static` and cannot be changed.
{: .note .js-note}
