---
title: Enterprise and Compliance Edition
html_title: Enterprise Edition
permalink: search-guard-enterprise-edition
category: versions
order: 300
layout: docs
edition: enterprise
description: The Search Guard Enterprise and Compliance license offers enterprise security for Elasticsearch and Kibana.
resources:
  - "https://search-guard.com/product/|Search Guard editions feature comparison (website)"

---
<!---
Copyright 2022 floragunn GmbH
-->

# Enterprise and Compliance Edition
{: .no_toc}

{% include toc.md %}

## Enterprise and Compliance License

For running Search Guard Enterprise or Compliance on production systems you need to [obtain a license](https://search-guard.com/licensing/){:target="_blank"}. Search Guard is licensed per cluster with an unlimited number of nodes. The license covers all non-production systems like development, staging and QA as well.

## Feature Comparison

For a feature comparison between the Compliance, Enterprise and Community Edition please refer to [the feature comparison matrix on our website](https://search-guard.com/licensing/){:target="_blank"}.

## Trial License

When installing Search Guard for the first time, a trial license is automatically generated. Depending on the installed version, it unlocks all Enterprise and Compliance features without any limitation.

This trial license is valid for 60 days. If you want to extend it, just [contact us](https://search-guard.com/contacts/) and we're happy to send you an extended license. 

## License Handling

Newly acquired license can be used no earlier than 30 days prior to start date of this license.
{: .note .js-note .note-warning}

### Displaying your current license

You have several ways to check the validity of your current license.

#### Logfile

On startup, Search Guard will print license information to the Elasticsearch logfile on `INFO` level. If your license is about to expire, a message on `WARN` level is printed. Running Search Guard with an expired license will result in `ERROR` message in the logfile.

#### HTTP license endpoint

The following endpoint will return your current license and information about the active Search Guard modules in JSON format:

```
https://<Elasticsearch Host>:<HTTP Port>/_searchguard/license
```

For example:

```
https://example.com:9200/_searchguard/license
```

You don't need to authenticate to access this endpoint.

#### REST API

The REST API offers an endpoint to retrieve your current license information. To access it, you need to use an account that has the privilege to use the REST API. If you used the demo installation script for installing and initializing Search Guard, you can use the admin user for that, e.g.:

```bash
curl -Ss --insecure -u admin:admin -XGET https://example.com:9200/_searchguard/license?pretty
```

See the [REST management API](rest-api) configuration chapter for further information on how to configure API users.

#### Kibana Configuration GUI

If you're using the Search Guard Kibana plugin, you can display your license and system information by clicking on "Search Guard" / "License & System Info".

### Applying an Enterprise or Compliance License

After obtaining a license, you can apply it in two ways. 

#### sg_license_key.yml

Add the license string to sg_license_key.yml and upload the configuration by using [sgctl](changelog-searchguard-flx-1_0_0#sg_license_key)

When using `sgctl` to upload the changed `sg_license_key.yml` with the new license, any existing license will be overwritten. In order to [backup your existing license](sgctl-configuration-changes).
#### REST API

You can use the [REST management API](rest-api) license endpoint to `POST` an Enterprise License to Search Guard.

#### Kibana Configuration GUI

If you're using the Search Guard Kibana plugin, you upload a new license by clicking on "Search Guard" / "License & System Info" / "Upload new license". Paste the complete license string in the input field and click on "Upload".