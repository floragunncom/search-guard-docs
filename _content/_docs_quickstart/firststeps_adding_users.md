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
  - sgctl|Using sgctl (docs)  
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

The internal user database stores users and their credentials directly in Elasticsearch. To manage users in the internal user database you have three options:

* Configure the users, their password hashes and backend roles in the `sg_internal_users.yml` file and use the `sgctl` CLI tool to upload this configuration to your cluster (Community Edition)
* Use the `sgctl` tool to directly add users to a running cluster (Community Edition)
* Use the [Search Guard Configuration GUI](configuration-gui) (Enterprise)
* Use the [internal users REST API](rest-api-internalusers) (Enterprise)

## Adding users to `sg_internal_users.yml`

The `sg_internal_users.yml` file defines all Search Guard users. You can find an example in the folder:

```
<ES installation directory>/plugins/search-guard-flx/sgconfig/sg_internal_users.yml
```

A user entry has the following basic format:

```
<username>:
  hash: <hashed password>
  backend_roles:
    - role1
    - role2
  search_guard_roles:
    - sg_role1
    - sg_role2
  attributes:
    key: value      
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

**Note:** If you want that a user is able to log into Kibana, you have to assign them the special role `SGS_KIBANA_USER`. This can look like this:

```
jdoe:
  hash: <hashed password>
  backend_roles:
    - hr_department
  search_guard_roles:
    - SGS_KIBANA_USER  
```

You can also map the Search Guard role `SGS_KIBANA_USER` to the backend role `hr_department`. See the guide on [roles mapping](firststeps_rolesmapping.md) for more on this.

Because we do not want to store any cleartext passsords anywhere, the password of the user must be hashed before we can add it to the configuration.

Search Guard uses a BCrypt hash for the passwords, so you can use [any tool that is capable of producing a BCrypt hash](https://bcrypt-generator.com/).

The easiest way to add users to a local `sg_internal_users.yml` file is to use `sgctl` with the `add-user-local` command. You can specify all necessary user attributes on the command line and then have the user automatically appended to a `sg_internal_users.yml` file.

Thus, in order to create the `jdoe` user, execute the following command:

```
$ ./sgctl.sh add-user-local jdoe --backend-roles hr_department --password -o /path/to/a/local/sg_internal_users.yml
```

When executing this, the command will ask you to enter a password. Alternatively, you can specify the password after the `--password` switch. If the file specified by the `-o` switch does not exist, it is automatically created. If it does already exist, the entry will be appended.

The newly added user will look like this:

```
jdoe:
  hash: $2y$12$AwwN1fn0HDEw/LBCwWU0y.Ys6PoKBL5pR.WTYAIV92ld7tA8kozqa
  backend_roles:
    - hr_department
```

Since we use the BCrypt algorithm, your actual hash values might vary from the ones in this guide.
{: .note .js-note .note-info}


### Uploading the changes to your cluster

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

## Using `sgctl` to directly add users on the cluster

Alternatively, if you already have a running cluster, you can also `sgctl` to directly create users on the cluster without modifying a local `sg_internal_users.yml` file first.

**Note:** After having used `sgctl` to directly modify the users on the cluster, keep in mind that any `sg_internal_user.yml` files you might have locally are now outdated. If you would use these files to update the configuration, you might lose users which were created directly on the cluster.

The syntax to add users directly on the cluster is very simple to the syntax of the `add-user-local` command. Just replace `add-user-local` by `add-user` and skip the `-o` option:

```
$ ./sgctl.sh add-user jdoe --backend-roles hr_department --password
```

To modify existing users, use the `update-user` command:

```
$ ./sgctl.sh update-user jdoe --backend-roles another_department
```

Use the `delete-user` command to delete a user:

```
$ ./sgctl.sh delete-user jdoe 
```
