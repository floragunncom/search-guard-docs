---
title: Advanced Configuration
html_title: Username/password based authentication advanced configuration
slug: kibana-authentication-http-basic-advanced
category: kibana-authentication-basic-overview
order: 200
layout: docs
edition: community
---
<!---
Copyright 2020 floragunn GmbH
-->

# Password-based authentication Advanced Configuration
{: .no_toc}

{% include toc.md %}

## Preventing users from logging in

You can prevent users from logging in to Kibana by listing them in `kibana.yml`. This is useful if you don't want system users like the Kibana server user or the logstash user to log in. In `kibana.yml`, set:

```
searchguard.basicauth.forbidden_usernames: ["kibanaserver", "logstash"]
```
