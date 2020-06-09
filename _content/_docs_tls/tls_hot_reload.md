---
title: TLS Hot-Reload
slug: hot-reload-tls
category: tls
order: 500
layout: docs
edition: community
description: Search Guard supports hot-reload of TLS certificates 
resources:
  - troubleshooting-tls|Troubleshooting TLS problems (docs)  
  - https://search-guard.com/elasticsearch-searchguard-tls-introduction/|An introduction to TLS (blog post)
  - https://search-guard.com/elasticsearch-tls-certificates/|An introduction to TLS certificates (blog post)

---
<!---
  This product includes software developed by Amazon.com, Inc.
  (https://github.com/opendistro-for-elasticsearch/security)
  
  Copyright 2015-2020 floragunn GmbH
-->
## TLS Certificate Hot-Reload

You can renew the `http` and `transport` TLS certificate without the need of restarting Elasticsearch.

Since this act is critical, it is recommended to do reload in two steps: 

1. Include both the old and new certificate in your `.pem` file or `.jks` store when performing the hot-reload
2a. If everything was successful, then perform the reload again with only the new certificate this time
2b. If something went wrong, you still have your old certificate in Elasticsearch and can retry 

The actual reload can be performed by:
1. Copy the new cert to the Elasticsearch node under the same configured path as specified in `elasticsearch.yml`
2. Use sgadmin or `curl -XPOST <elasticsearch>/_searchguard/api/ssl/{certType}/reloadcerts/` where `{certType}` can be either `http` or `transport`

Please note that the renewed certificate must be issued by the same Issuer and Subject DN and SAN with expiry dates after the existing certificate.
 