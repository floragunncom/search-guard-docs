---
title: OpenID Troubleshooting
slug: troubleshooting-openid
category: troubleshooting
order: 550
layout: troubleshooting
description: Step-by-step instructions on how to troubleshoot OpenID Connect issues in OpenSearch/Elasticsearch and Dashboards/Kibana.
---

<!--- Copyright 2020 floragunn GmbH -->

# OpenID troubleshooting

## Setting the log level to debug

For troubleshooting any problem with OpenID, it is recommended to set the log level to at least `debug` on OpenSearch/Elasticsearch.

Add the following lines in `config/log4j2.properties` and restart your node:

```
logger.sg.name = com.floragunn.dlic.auth.http.jwt
logger.sg.level = trace
```

This will print out a lot of helpful information in your log file. If this information is not sufficient, you can also set the log level to `trace`.

## Failed when trying to obtain the endpoints from your IdP

This indicates that the metadata endpoint of your IdP is not reachable. Please check the following setting in sg_config.yml:

```
openid_auth_domain:
  enabled: true
  order: 1
  http_authenticator:
    type: "openid"
    ...
    config:
      openid_connect_url: http://keycloak.examplesss.com:8080/auth/realms/master/.well-known/openid-configuration
    ...
```

## ValidationError: child "searchguard" fails ...

This indicates that one or more of the Dashboards/Kibana configuration settings are missing.

Check your kibana.yml file and make sure you have set the following minimal configuration:

```
searchguard.openid.client_id: "..."
searchguard.openid.client_secret: "..."
```

## Authentication failed. Please provide a new token.

This can have several reasons:

### Leftover cookies or cached credentials

To make sure you do not have any leftover cookies or otherwise stale data, please delete all cached browser data. If you are not sure how to do that try again with an incognito/private browser window.

### Wrong client secret

To trade the access token for an identity token, most IdPs require you to provide a client secret. Please check if the client secret in `kibana.yml matches the client secret of your IdP configuration:

```
#searchguard.openid.client_secret: "..."
```

### Failed to get subject from JWT claims, check if subject_key ... is correct.

This error is logged on OpenSearch/Elasticsearch and means that the username could not be extracted from the id token. Make sure the following setting matches the claims in the JWT your IdP issues:

```
openid_auth_domain:
  enabled: true
  order: 1
  http_authenticator:
    type: "openid"
    ...
    config:
      subject_key: <subject key>
    ...
```

### Failed to get roles from JWT claims with roles_key ...

This indicates that the roles key you configured in sg_config.yml does not exist in the JWT issued by your IdP. Make sure the following setting matches the claims in the JWT your IdP issues:

```
openid_auth_domain:
  enabled: true
  order: 1
  http_authenticator:
    type: "openid"
    ...
    config:
      roles_key: <roles key>
    ...
```



