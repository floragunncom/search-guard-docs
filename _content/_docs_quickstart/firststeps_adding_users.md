---
title: Adding users
html_title: Adding users
permalink: first-steps-user-configuration
category: first_steps
order: 100
layout: docs
description: How to add new Search Guard users by using sgadmin and the Search Guard configuration.
resources:
  - internal-users-database|Internal user database (docs)  
  - sgadmin|Using sgadmin (docs)  
---
<!---
Copyright 2020 floragunn GmbH
-->

# Adding Search Guard users
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

## The internal user database

Search Guard can use external authentication systems like LDAP, OpenID, SAML or Kerberos for authenticating users. As an alternative, you can also use the **internal user database** to manage your users.

The internal user database stores users and their credentials directly in OpenSearch/Elasticsearch. To manage users in the internal user database you have three options:

* Configure the users, their password hashes and backend roles in the sg_intern_users.yml file and use the sgadmin CLI to upload this configuration to your cluster (Community)
* Use the [internal users REST API](rest-api-internalusers) (Enterprise)
* Use the [Search Guard Configuration GUI](configuration-gui) (Enterprise)

In this guide we will take the first approach.

## Adding users to sg\_internal\_users.yml

The sg\_internal\_users.yml file defines all Search Guard users. You can find an example in the folder:

```
<ES installation directory>/plugins/search-guard-7/sgconfig/sg_internal_users.yml
```

A user entry has the following basic format:

```
<username>:
  hash: <hashed password>
  backend_roles:
    - <rolename>
    - <rolename>
```

In this guide we want to add a user called `jdoe` which has read-only access to a fictitious index called `humanresources`.

We also want to add the user to a backend role called `hr_department`. For the moment, think about **backend roles as a way of putting users in different groups**, just like LDAP or Active Directory groups. We use them later to assign all users with the `hr_department` backend role to a Search Guard role. 

So our basic entry in `sg_internal_users.yml` looks like:

```
jdoe:
  hash: <hashed password>
  backend_roles:
    - hr_department
```

**Note:** If you want that a user is able to log into Dashboards/Kibana, you have to assign them the special role `SGS_KIBANA_USER`. This can look like this:

```
jdoe:
  hash: <hashed password>
  backend_roles:
    - hr_department
  search_guard_roles:
    - SGS_KIBANA_USER  
```

You can also map the Search Guard role `SGS_KIBANA_USER` to the backend role `hr_department`. See the guide on [roles mapping](firststeps_rolesmapping.md) for more on this.

## Generating the password hash

Because we do not want to store any cleartext passsords anywhere, the password of the user must be hashed before we can add it to the configuration.

Search Guard uses a BCrypt hash for the passwords, so you can use [any tool that is capable of producing a BCrypt hash](https://bcrypt-generator.com/).

Search Guard ships with a `hash.sh` script which you can use as well to generate the password hash. The script is located in:

```
<ES installation directory>/plugins/search-guard-7/tools/hash.sh
```

We can generate the hash like:

```
<ES installation directory>/plugins/search-guard-7/tools/hash.sh -p <cleartext password>
```

Which will then output the hash on the command line. We can now simply copy the hash to our configuration:

```
jdoe:
  hash: $2y$12$AwwN1fn0HDEw/LBCwWU0y.Ys6PoKBL5pR.WTYAIV92ld7tA8kozqa
  backend_roles:
    - hr_department
```

Since we use the BCrypt algorithm, your actual hash values might vary from the ones in this guide.
{: .note .js-note .note-info}

## Adding more users

In our example we will add another user that is also member of the `hr_department` group, and one more user that is member of the `devops` group. We will then create Search Guard roles for these users in the next step. Our configuration looks like:

```
jdoe:
  hash: $2y$12$AwwN1fn0HDEw/LBCwWU0y.Ys6PoKBL5pR.WTYAIV92ld7tA8kozqa
  backend_roles:
    - hr_department

psmith:
  hash: $2y$12$YOVZhJ.gbZOAoGyd9YGNMuw7rWYTfB73n8OGBLtsrihMkW5rg5D1G
  backend_roles:
    - hr_department

cmaddock:
  hash: $2y$12$3UFikPXIZLoHcsDGD0hyqOvxjytdXeRkefIF1M58jA5oueSDKthzu
  backend_roles:
    - devops
```

To keep things simple, the passwords we use here are the same as the username.

## Uploading the changes to your cluster

In order to activate the changed configuration, we need to upload it to the Search Guard configuration index by using the `sgctl` command line tool. 

If you have already set up the `sgctl` connection to the cluster, just type:

```bash
$ ./sgctl.sh update-config /path/to/the/changed/sg_internal_users.yml
```

If you have not yet set up the `sgctl` connection, you have to do this once:

```bash
$ ./sgctl.sh connect localhost --ca-cart /path/to/root-ca.pem --cert /path/to/admin-cert.pem --key /path/to/admin-cert-private-key.pem
```

The configuration changes are active immediately. There is no need to restart your cluster.