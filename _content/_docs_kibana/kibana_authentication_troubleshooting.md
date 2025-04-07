---
title: Troubleshooting
html_title: Authentication Troubleshooting
permalink: kibana-authentication-troubleshooting
layout: docs
edition: community
description: What to do when things do not work as they are supposed to
---
<!---
Copyright 2022 floragunn GmbH
-->

# Kibana Authentication Troubleshooting
{: .no_toc}

In case you encounter problems with authentication in Kibana, you can use a special configuration option to display useful debugging information while logging in.

To do so, use the following command:

```
$ ./sgctl.sh set frontend_config debug --true
```

**Important:** Be aware that this might expose sensitive information to all users which can access the cluster. Don't use this on production clusters.

After having activated the configuration, open Kibana in your browser and try to log in. If you encounter a login failure, you should see more detailed information about the login process. This can look like this:


![Login page with authentication failure and debug information](kibana_authentication_debug.png)



