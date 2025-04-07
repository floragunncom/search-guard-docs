---
title: Reserved and hidden resources
html_title: Reserved resources
permalink: rest-api-reserved-hidden
layout: docs
edition: enterprise
description: How to use the reserved and hidden flag to protect Search Guard resources
  from being overwritten.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Reserved and hidden resources
{: .no_toc}

{% include toc.md %}

## Reserved resources

You can mark any user, role, action group or roles mapping as `reserved` in their respective configuration files. Resources that have this flag set to true can not be changed via the REST API and are marked as `reserved` in the Kibana Configuration GUI.

You can use this feature to give users or customers permission to add and edit their own users and roles, while making sure your own built-in resources are left untouched.

To mark a resource `reserved`, add the following flag:

```yaml
sg_my_role:
  reserved: true
  ...
```

To change the `reserved` flag you need to use sgctl.
{: .note .js-note .note-info}

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

To change the `reserved` flag you need to use sgctl.
{: .note .js-note .note-info}

Example:

```yaml
sg_my_role:
  hidden: true
  ...
```  

## Built-in (static) resources

The Search Guard built-in roles and and action groups are marked `static` and cannot be changed.
{: .note .js-note}
