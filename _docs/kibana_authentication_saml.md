---
title: SAML authentication
html_title: SAML authentication
slug: kibana-authentication-saml
category: kibana-authentication
order: 800
layout: docs
edition: enterprise
description: How to configure Kibana for SAML Single Sign On authentication.
---
<!---
Copryight 2016-2017 floragunn GmbH
-->

# Using Kibana with SAML authentication

**For Kibana SAML authentication to work you need at least the Search Guard Kibana Plugin v14 and above.**

Since most of the SAML specific configuration is done in Search Guard, just activate SAML in your `kibana.yml` by adding:

```
searchguard.auth.type: "saml"
```

In addition the Kibana endpoint for validating the SAML assertions must be whitelisted:

```
server.xsrf.whitelist: ["/searchguard/saml/acs"]
```

If you use the logout POST binding, you also need to whitelist the logout endpoint:

```
server.xsrf.whitelist: ["/searchguard/saml/acs", "/searchguard/saml/logout"]
```
