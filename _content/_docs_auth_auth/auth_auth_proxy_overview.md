---
title: Proxy authentication
permalink: proxy-authentication-overview
category: authauth
subcategory: proxy
order: 800
layout: docs
edition: community
description: Use Search Guard's Proxy authentication feature to connect Elasticsearch to any third-party identity provider.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Proxy based authentication
{: .no_toc}

{% include toc.md %}

The proxy based authentication enables you to use a single sign on (SSO) solution - which you might already have - instead of the Search Guard authentication backend. 

Most of these solutions work as a proxy in front of Elasticsearch. Usually the request is routed to the SSO proxy first. The SSO proxy authenticates the user. If authentication succeeds, the (verified) username and its (verified) roles are set in HTTP header fields. The names of these fields are dependent on the SSO solution you have in place.
