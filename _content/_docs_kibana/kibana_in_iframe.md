---
title: Kibana in IFrame
html_title: Kibana in IFrame
permalink: kibana-in-iframe
layout: docs
edition: community
description: How to run Kibana powered by SearchGuard in an iframe on a third party
  website.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Kibana in IFrame
{: .no_toc}

{% include toc.md %}

Web browsers changed the default behavior for cookies so that:

* Cookies without a `SameSite` attribute are treated as `SameSite=Lax`.
* Cookies for cross-site usage must specify `SameSite=None; Secure` to include third party content.

It means that Kibana can't be accessed via an iframe on a third party web site by default. The cookies at the Kibana side must be configured to add `SameSite=None; Secure` attributes.

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

