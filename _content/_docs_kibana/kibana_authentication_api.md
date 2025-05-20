---
title: Using the Kibana API
html_title: Using the Kibana API
permalink: kibana-authentication-api
layout: docs
edition: community
description: How to use the Kibana saved objects API when authentication is configured.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Kibana REST API
{: .no_toc}

{% include toc.md %}

## Adding user credentials

Kibana offers an API for saved objects like index patterns, dashboards and visualizations. In order to use this API in conjunction with Search Guard you need to add user credentials as HTTP headers to these calls as well. What kind of HTTP header is required depends on the configured Search Guard authentication type. 

**HTTP Basic example:**

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-bash">
<code class=" js-code language-markup">
curl \
   <b>-u hr_employee:hr_employee </b> \
   -H 'Content-Type: application/json' \
   -H "kbn-xsrf: true" \
   -XGET "http://localhost:5601/api/saved_objects/_find?type=index-pattern"
</code>
</pre>
</div>

**JWT example:**

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-bash">
<code class=" js-code language-markup">
curl \
   <b>-H 'Authorization: Bearer &lt;token&gt;'</b> \
   -H 'Content-Type: application/json' \
   -H "kbn-xsrf: true" \
   -XGET "http://localhost:5601/api/saved_objects/_find?type=index-pattern"
</code>
</pre>
</div>

## Multi-Tenancy: Setting the tenant

If you are using [Search Guard Multi-Tenancy](kibana-multi-tenancy), you can also specify the tenant by adding the `sgtenant` HTTP header:

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-bash">
<code class=" js-code language-markup">
curl \
   -u hr_employee:hr_employee \
   <b>-H "sgtenant: management" \</b>
   -H 'Content-Type: application/json' \
   -H "kbn-xsrf: true" \
   -XGET "http://localhost:5601/api/saved_objects/_find?type=index-pattern"
</code>
</pre>
</div>
