---
title: Search Guard Documentation
html_title: Documentation
slug: index
layout: docs
description: Official documentation for Search Guard 7, the enterprise security and alerting suite for Elasticsearch.
showsearch: true
isroot: true
---
<!---
Copryight 2020 floragunn GmbH
-->


<p align="center">
<img src="img/logos/search-guard-frontmatter.png" alt="Search Guard - Security for Elasticsearch" style="width: 40%" />
</p>

<h2 align="center">Security and Alerting for Elasticsearch</h2>

<h1 align="center">Search Guard {{site.searchguard.version}} Documentation</h1>

The [Search Guard Technical Preview 2](https://docs.search-guard.com/tech-preview/), a preview of the next generation of Search Guard, has been just released!
{: .note .js-note}

## Docker Demo

To try out Search Guard and Signals quickly, you can use the Search Guard Demo Docker image:

```
docker run -ti -p 9200:9200 -p 5601:5601 floragunncom/sgdemo
```

After the container is up, open

```
http://localhost:5601 to access Kibana
```

to access Kibana. For login, use `admin/admin`.

<hr  />

## Quick Links

| Security | Alerting |
|---|---|
| [Latest versions](search-guard-versions) |[Getting started](elasticsearch-alerting-getting-started) |
| [Quick Start](demo-installer) | [How Signals Works](elasticsearch-alerting-how-it-works) |
| [First steps: Adding users](first-steps-user-configuration) |[Sample Watches](elasticsearch-alerting-watches-sample)|
| [First steps: Configuring roles](first-steps-roles-configuration) |[REST API](elasticsearch-alerting-rest-api-overview)|
| [First steps: Assign users to roles](first-steps-mapping-users-roles) | [Severity Levels](elasticsearch-alerting-severity)|
| [Main Concepts](main-concepts) | [Actions](elasticsearch-alerting-actions-overview)| 
{: .equalwidth-table}


