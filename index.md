---
title: Search Guard Documentation
html_title: Documentation
#permalink: security
layout: docs
description: Official documentation for Search Guard FLX, the enterprise security and alerting suite for Elasticsearch.
isroot: true
---
<!---
Copyright 2022 floragunn GmbH
-->


<p align="center">
<img src="img/logos/search-guard-frontmatter.svg" alt="Search Guard - Security for Elasticsearch" style="width: 40%" />
</p>

<h1 align="center">Search Guard FLX Documentation</h1>

Welcome to Search Guard FLX, the enterprise security and alerting suite for Elasticsearch!

## Quick Start with Docker

Get started with Search Guard in seconds using Docker:

```bash
docker run -it --rm -p 5601:5601 -p 9200:9200 floragunncom/search-guard-flx-demo
```

Once the container is running, point your browser to `http://localhost:5601` and login with:
- **Username:** `admin`
- **Password:** `admin`

You now have a fully functional Elasticsearch cluster with Kibana and Search Guard FLX installed!

## What Are You Most Interested In?

Search Guard FLX provides comprehensive enterprise features for Elasticsearch. Choose the area you'd like to explore:

<div class="feature-section" markdown="1">

### <span class="feature-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg></span> Security

Protect your Elasticsearch cluster with enterprise-grade security features including authentication, authorization, role-based access control, field and document level security, and audit logging. Search Guard supports LDAP, Active Directory, SAML, OpenID Connect, Kerberos, JWT, and many other authentication methods.

[Explore Security Features →](security)

</div>

<div class="feature-section" markdown="1">

### <span class="feature-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg></span> Alerting

Monitor your data and get notified when something important happens. Create watches that continuously check your data using powerful queries and trigger actions like sending emails, Slack messages, PagerDuty alerts, or webhooks when conditions are met.

[Explore Alerting →](elasticsearch-alerting)

</div>

<div class="feature-section" markdown="1">

### <span class="feature-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H8V4h12v12zM10 9h8v2h-8zm0 3h4v2h-4zm0-6h8v2h-8z"/></svg></span> Index Management

Automate index lifecycle management with scheduled policies. Define transitions, rollover strategies, snapshots, and retention policies to automatically manage your indices as they age - from hot to warm to cold storage, and eventually deletion.

[Explore Index Management →](automated-index-management)

</div>

<div class="feature-section" markdown="1">

### <span class="feature-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM9 6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9V6zm9 14H6V10h12v10zm-6-3c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2z"/></svg></span> Encryption at Rest

Encrypt your Elasticsearch indices at rest to meet compliance requirements and protect sensitive data. Search Guard encrypts data transparently at the storage layer, ensuring your data is secure even if physical media is compromised.

[Explore Encryption at Rest →](encryption-at-rest)

</div>

<div class="feature-section" markdown="1">

### <span class="feature-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3.5 18.49l6-6.01 4 4L22 6.92l-1.41-1.41-7.09 7.97-4-4L2 16.99z"/></svg></span> Anomaly Detection

Automatically detect anomalies and outliers in your time-series data using machine learning. Identify unusual patterns, deviations, and trends without manual threshold configuration, helping you spot issues before they become critical.

[Explore Anomaly Detection →](anomaly-detection)

</div>

## Additional Resources

- [Demo Installer](demo-installer) - Quick test installation for your local system
- [Using sgctl](sgctl) - Command-line administration tool
- [Configuration Variables](configuration-password-handling) - Secure credential management
- [Migrating from Search Guard 53](sg-classic-config-migration-quick) - Migration guide
- [Release Notes](changelog-searchguard-flx-1_0_0) - Latest changes and updates

## Feedback

Your feedback is welcome! Visit the [Search Guard Forum](https://forum.search-guard.com/) for questions and discussions, or report issues at the Search Guard Gitlab repository.

 



