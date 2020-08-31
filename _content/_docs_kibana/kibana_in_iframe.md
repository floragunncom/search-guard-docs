---
title: Iframe
html_title: Kibana in iframe
slug: kibana-in-iframe
category: kibana
order: 500
layout: docs
edition: community
description: How to run Kibana powered by SearchGuard in an iframe on a third party website.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Kibana in iframe
{: .no_toc}

{% include toc.md %}

Web browsers change the default behavior for cookies so that:

* Cookies without a `SameSite` attribute will be treated as `SameSite=Lax`.
* Cookies for cross-site usage must specify `SameSite=None; Secure` to include third party content.

It means that Kibana can't be accessed via an iframe on a third party web site by default. The cookies at the Kibana side must be configured to add `SameSite=None; Secure` attributes. It can't be done now because [Kibana is still using hapi v17 server](https://github.com/elastic/kibana/blob/7.6/package.json#L185){:target="_blank"}. And hapi introduced `SameSite=None` in [v19.0.0 release](https://github.com/hapijs/hapi/issues/4017){:target="_blank"}. The related Kibana issue can be found [here](https://github.com/elastic/kibana/issues/60522){:target="_blank"}.

<span style="font-size:1.5em;color:green">Good news!</span> We provide a patch to make it work.

## Patch

```
$ cd kibana/plugins/searchguard
$ ./patches/patch_to_add_samesite_none_to_cookies.sh

SGD-231/SGD-19 The patch makes it possible to work with Kibana which is embeded in an iframe on a third party website.
Read more about SameSite=None: https://www.chromestatus.com/feature/5633521622188032 and https://web.dev/samesite-cookies-explained/

The following configuration of kibana.yml is required:
searchguard:
 cookie:
  secure: true
  isSameSite: None

Patched node_modules/hapi-auth-cookie/lib/index.js. The original file backup is in node_modules/hapi-auth-cookie/lib/index.js.bak
Patched ../../node_modules/statehood/lib/index.js. The original file backup is in ../../node_modules/statehood/lib/index.js.bak
```

## Kibana configuration

**kibana.yml**
```yaml
searchguard:
 cookie:
  secure: true
  isSameSite: None
```

## References

[Reject insecure SameSite=None cookies](https://www.chromestatus.com/feature/5633521622188032){:target="_blank"}

[Temporarily rolling back SameSite Cookie Changes](https://blog.chromium.org/2020/04/temporarily-rolling-back-samesite.html){:target="_blank"}

[SameSite cookies explained](https://web.dev/samesite-cookies-explained/){:target="_blank"}


[Incrementally Better Cookies](https://tools.ietf.org/html/draft-west-cookie-incrementalism-00){:target="_blank"}
