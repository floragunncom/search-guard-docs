# LDAP and Active Directory

LDAP and Active Directory can be used both in the `authc` and `authz` section of the configuration. Active Directory also uses the LDAP protocol.

**Authentication:**

```
authentication_backend:
  type: ldap 
  config:
    ...
```

**Authorization:**

```    
authorization_backend:
  type: ldap 
  config:
    ...    
```
    
For both entries you need to specify additional configuration parameters. Most of them are identical between the `authc` and `authz` section. For `authz`, you need to specify some additional settings.

Common configuration parameters:

```
config:
  # enable ldaps
  enable_ssl: <true|false>
  # enable start tls, enable_ssl should be false
  enable_start_tls: <true|false>
  # send client certificate
  enable_ssl_client_auth: <true|false>
  # verify ldap hostname
  verify_hostnames: <true|false>
  hosts:
    - localhost:8389
  bind_dn: null
  password: null
  userbase: 'ou=people,dc=example,dc=com'
  # Filter to search for users (currently in the whole subtree beneath userbase)
  # {0} is substituted with the username 
  usersearch: '(uid={0})'
  # Use this attribute from the user as username (if not set then DN is used)
  username_attribute: null
```

## TLS settings

The first entries control the TLS settings of the connection to your LDAP server.

| Name  | Description  |
|---|---|
| enable_ssl  |  Whether to use LDAP over SSL (LDAPS) or not |
|  enable_\start\_tls |  Whether to use STARTTLS or not. Cannot be used in combination with LDAPS. |
| enable\_ssl\_client\_auth  | Whether to send the client certificate to the LDAP server or not   |

## LDAP server settings

Next, configure how Search Guard connects to your LDAP server(s):

| Name  | Description  |
|---|---|
| hosts  |  Host and port of your LDAP server(s). Hostnames and IPs are allowed, and you can define multiple LDAP servers. |
|  bind_dn | The DN to use when connecting to LDAP. If anonymous auth is allowed, can be set to null |
| password  | The password to use when connecting to LDAP. If anonymous auth is allowed, can be set to null   |

## Authentication settings

| Name  | Description  |
|---|---|
| userbase  | Specifies the subtree in the directory where user information is stored |
|  usersearch | The actual LDAP query that Search Guard executes when trying to authenticate a user. The variable {0} is substituted by the username.|
| username_attribute  | Search Guard uses this attribute of the directory entry to look for the user name. If set to null, the DN is used (default).  |

## Additional authorization settings

If used in the authz section, the following additional parameters are available:

```
config:
  rolebase: 'ou=groups,dc=example,dc=com'
  # Filter to search for roles (currently in the whole subtree beneath rolebase)
  rolesearch: '(uniqueMember={0})'
  userroleattribute: null
  # Roles as an attribute of the user entry
  userrolename: memberOf
  # The attribute in a role entry containing the name of that role
  rolename: cn
  # Resolve nested roles transitive (roles which are members of other roles and so on ...)
  resolve_nested_roles: <true|false>
```

| Name  | Description  |
|---|---|
| rolebase  | Specifies the subtree in the directory where role/group information is stored |
|  rolesearch | The actual LDAP query that Search Guard executes when trying to determine the roles of a user. You can use three variables here (see below)|
| userrolename  | If the roles/groups of a user are not stored in the groups subtree, but as an attribute of the user's directory entry, define this attribute name here. |
| userroleattribute  | The attribute of the user's directory entry |
| rolename  | The attribute in a role entry containing the name of that role to use for `{2}` variable substitution (see below)|
| resolve\_nested\_roles  | Whether ot not to resolve nested roles transitively (roles which are members of other roles and so on ...)  |

For `rolesearch`, you can use the following variables:

* {0} is substituted with the DN of the user
* {1} is substituted with the username 
* {2} is substituted with an attribute value from user's directory entry, of the authenticated user. 

The variable `{2}` refers to an attribute from the user's directory entry. Which attribute you want to here can be specified by the `userroleattribute` setting.

The concrete settings very much depend on the setup of your LDAP directory. For example, the LDAP schema if Actice Direcrory is not the same as the 'standard' LDAP schema.