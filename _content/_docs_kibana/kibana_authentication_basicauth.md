---
title: HTTP Basic Authentication
html_title: Kibana Basic Auth
slug: kibana-authentication-http-basic
category: kibana-authentication
order: 200
layout: docs
edition: community
description: How to configure Kibana for HTTP Basic Authentication. Secure Kibana access with a login screen.
---
<!---
Copyright 2020 floragunn GmbH
-->

# HTTP Basic Authentication
{: .no_toc}

{% include toc.md %}

HTTP Basic is the most common used authentication type and probably the one you are most familiar with. If a user tries to access Kibana:  

* Search Guard checks whether the user has an active session with valid username/password credentials
* if so, the credentials are added to any HTTP call from Kibana to Elasticsearch/Search Guard
  * Search Guard will use these credentials for authentication and authorization  and for assigning roles and permissions
  * Depending on the configured authentication backend, the credentials are checked against the internal user database, LDAP or Active Directory
* If the user does not have any active session, a customizable login page is display and the user has to log in.

To activate Basic Authentication and the login page, add the following entry to `kibana.yml`:

```
searchguard.auth.type: "basicauth"
```


Use the following settings in `kibana.yml` to configure HTTP Basic authentication:

## Session management

The user session is stored in an encrypted cookie. Use the following to configuration options to control the session behavior:

| Name | Description |
|---|---|
| searchguard.cookie.secure | boolean, if set to true cookies are only stored when using HTTPS. Default: false. |
| searchguard.cookie.name | String, name of the cookie. Default: 'searchguard_authentication' |
| searchguard.cookie.password | String, key used to encrypt the cookie. Must be at least 32 characters long. Default: 'searchguard\_cookie\_default\_password' |
| searchguard.cookie.ttl | Integer, lifetime of the cookie in milliseconds. Can be set to 0 for session cookie. Default: 1 hour |
| searchguard.session.ttl | Integer, lifetime of the session in milliseconds. If set, the user is prompted to log in again after the configured time, regardless of the cookie. Default: 1 hour |
| searchguard.session.keepalive | boolean, if set to true the session lifetime is extended by `searchguard.session.ttl` upon each request. Default: true |
{: .config-table}

## Preventing users from logging in

You can prevent users from logging in to Kibana by listing them in `kibana.yml`. This is useful if you don't want system users like the Kibana server user or the logstash user to log in. In `kibana.yml`, set:

```
searchguard.basicauth.forbidden_usernames: ["kibanaserver", "logstash"]
```

## Configuration example

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-yaml">
<code class=" js-code language-markup">
# Activate basic auth
searchguard.auth.type: "basicauth"

# Configure session management
searchguard.cookie.password: &lt;encryption key, min. 32 characters&gt;

# Use HTTPS instead of HTTP
elasticsearch.hosts: "https://&lt;hostname&gt;.com:&lt;http port&gt;"

# Configure the Kibana internal server user
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"

# Disable SSL verification when using self-signed demo certificates
elasticsearch.ssl.verificationMode: none

# Whitelist basic headers and multi tenancy header
elasticsearch.requestHeadersWhitelist: ["Authorization", "sgtenant"]
</code>
</pre>
</div>