---
title: Custom implementations
slug: custom-authentication-modules
category: authauth
order: 800
layout: docs
edition: enterprise
description: How to write your own authentication and authorization modules for Search Guard.
---
<!---
Copyright 2017 floragunn GmbH
-->


# Custom authentication modules
{: .no_toc}

{% include_relative _includes/toc.md %}

If none of the Enterprise modules fits your needs, you can also write your own implementation. This is a feature of the Enterprise Edition, you can implement your own HTTP authenticator and also your own authentication and authorization backends.

The HTTP authenticator is responsible for extracting user credentials from a HTTP call, while the authentication backend is responsible for validating these credentials. An authorization backend fetches a user's backend roles.

## Setting up your project

In order to write your own implementations, you need to implement interfaces provided in the Search Guard plugin. The easiest way is to add the required dependencies in the pom.xml of your Maven project:

```xml
<dependency>
    <groupId>com.floragunn</groupId>
    <artifactId>search-guard-{{site.searchguard.esmajorversion}}</artifactId>
    <version>${searchguard.version}</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>org.elasticsearch</groupId>
    <artifactId>elasticsearch</artifactId>
    <version>${elasticsearch.version}</version>
    <scope>provided</scope>
</dependency>
```

Where the `${searchguard.version}` and `${elasticsearch.version}` are the Search Guard / Elasticsearch versions you want to compile against, e.g. {{site.elasticsearch.currentversion}}.

## Implementing a custom HTTPAuthenticator

A custom HTTPAuthenticator must extend the interface `com.floragunn.searchguard.auth.HTTPAuthenticator`.

The methods to implement are [fully documented in JavaDoc](https://github.com/floragunncom/search-guard/blob/master/src/main/java/com/floragunn/searchguard/auth/HTTPAuthenticator.java).

## Implementing a custom AuthenticationBackend

A custom AuthenticationBackend must extend the interface `com.floragunn.searchguard.auth.AuthenticationBackend`.

The methods to implement are [fully documented in JavaDoc](https://github.com/floragunncom/search-guard/blob/master/src/main/java/com/floragunn/searchguard/auth/AuthenticationBackend.java).

## Implementing a custom AuthorisationBackend

A custom AuthorisationBackend must extend the interface `com.floragunn.searchguard.auth.AuthorizationBackend`.

The methods to implement are [fully documented in JavaDoc](https://github.com/floragunncom/search-guard/blob/master/src/main/java/com/floragunn/searchguard/auth/AuthorizationBackend.java).

## Configuring custom implementations

Custom implementations can be configured in `sg_config.yml` by simply providing their fully qualified class name as type in the authc and/or authz section:

```yaml
authz:
  custom_authc_domain:
    enabled: true
    order: 0
    http_authenticator:
      type: com.floragunn.custom.CustomHttpAuthenticator
      challenge: false
      config:
        key: value
    authentication_backend:
      type: com.floragunn.custom.CustomAuthenticationBackend
      config:
        key: value
        ...
authz:
  custom_authz_domain:
    enabled: true
    authorization_backend:
      type: com.floragunn.custom.CustomAuthorizationBackend
      config:
        key: value
        ...      
```

## Accessing configuration settings

All custom implementations need to provide a public constructor, which takes a `org.elasticsearch.common.settings.Settings` object as argument. 

This object will contain the settings from the `config` sections of your custom modules in `sg_config.yml`. In the above example, all three custom modules would receieve a `org.elasticsearch.common.settings.Settings` object where `key` contains `value`.

## Adding additional user attributes

You can add additional properties to the user by either:

* Calling `AuthCredentials#addAttribute` in the HTTPAuthenticator
* Calling `User#getCustomAttributesMap` and modify the returned map directly

Attributes can be used to further describe the user, and, more importantly, they can be used as variables in the [Document Level Security](dlsfls_dls.md) query. This makes it possible to write dynamic DLS queries based on a user's attributes.