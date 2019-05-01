---
title: Search Guard Documentation
html_title: Documentation
slug: index
layout: docs
description: Official documentation for Search Guard 6, the enterprise security suite for Elasticsearch.
showsearch: false

---
<!---
Copryight 2016-2017 floragunn GmbH
-->


<p align="center">
<img src="search-guard-frontmatter.png" alt="Search Guard - Security for Elasticsearch" style="width: 40%" />
</p>


<h1 align="center">Search Guard {{site.searchguard.esmajorversion}} Documentation</h1>

* [Installation](search-guard-versions)
* [Quick Start](demo-installer)

<h3>Current releases</h3>
<table>
    <thead>
    <tr>
        <th>Elasticsearch Version</th>
        <th>Search Guard Version</th>
        <th>Kibana Plugin Version</th>
        <th>Artifact</th>
    </tr>
    </thead>
    <tbody>

    {% for version in site.sgversions.enterprise %}

    {% assign sgversions = version | split: "|" %}

    {% if sgversions[3] != 'yes' %}
        {% continue %}
    {% endif %}

    <tr>
                                            
        <td>{{ sgversions[0] }}</td>
        <td><a href="https://oss.sonatype.org/service/local/repositories/releases/content/com/floragunn/search-guard-6/{{ sgversions[0] }}-{{ sgversions[1] }}/search-guard-6-{{ sgversions[0] }}-{{ sgversions[1] }}.zip" target="_blank">{{ sgversions[1] }}</a></td>
        <td><a href="https://oss.sonatype.org/service/local/repositories/releases/content/com/floragunn/search-guard-kibana-plugin/{{ sgversions[0] }}-{{ sgversions[2] }}/search-guard-kibana-plugin-{{ sgversions[0] }}-{{ sgversions[2] }}.zip" target="_blank">{{ sgversions[2] }}</a></td>
        <td>com.floragunn:search-guard-6:{{ sgversions[0] }}-{{ sgversions[1] }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>


Search Guard is a trademark of floragunn GmbH, registered in the U.S. and in other countries

Elasticsearch, Kibana, Logstash, and Beats are trademarks of Elasticsearch BV, registered in the U.S. and in other countries.

Copyright 2016-2019 floragunn GmbH


