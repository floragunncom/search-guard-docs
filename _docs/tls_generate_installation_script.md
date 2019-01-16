---
title: Search Guard Installer
slug: tls-certificates-installer
category: generating-certificates
order: 100
layout: docs
edition: community
description: How to generate TLS certificates by using the demo installation script that ships with Search Guard.

---
<!---
Copyright 2017 floragunn GmbH
-->

# Using the Search Guard demo installer
{: .no_toc}

{% include_relative _includes/toc.md %}

The demo installation script that ships with Search Guard comes with certificates that you can use to run a PoC or to test-drive our features. 

Since the demo certificates are the same for each Search Guard installation, do not use them in production.
{: .note .js-note .note-warning}

To execute the demo installation:

* ``cd`` into `<Elasticsearch directory>/plugins/search-guard-{{site.searchguard.esmajorversion}}/tools`
* Execute ``./install_demo_configuration.sh``(``chmod`` the script first if necessary.)

The demo installer will ask if you would like to install the demo certificates, if the Search Guard configuaration should be automatically initialized and if cluster mode should be enabled. Answer as follows:

```bash
Search Guard {{site.searchguard.esmajorversion}} Demo Installer
 ** Warning: Do not use on production or publicly reachable systems **
Install demo certificates? [y/N] y
Initialize Search Guard? [y/N] y
Enable cluster mode? [y/N] n
```

## Generated certificates

The demo installer will place the following files in the `config` directory of your Elasticsearch installation:

<div class="file-tree">
	<div class="file-tree-title"> Files
	</div>
	<ul class="file-tree-list js-file-tree treeview" data-expanded="">
		<li class="is-file">root-ca.pem
			<span class="file-tree-description">the root CA used for signing all other certificates</span>
		</li>
		<li class="is-file">esnode.pem
			<span class="file-tree-description">the node certificate used on the transport- and REST-layer</span>
		</li>
		<li class="is-file contains-items">esnode-key.pem
			<span class="file-tree-description">the private key for the node certificate</span>
		</li>
		<li class="is-file contains-items">kirk.pem
			<span class="file-tree-description">the admin certificate, allows full access to the cluster and can be used with sgadmin and the REST management API</span>
		</li>
		<li class="is-file contains-items">kirk-key.pem
			<span class="file-tree-description">the private key for the admin certificate</span>
		</li>
	</ul>
</div>


## Allow demo certificate usage

Since the demo certificates are unsafe to use on a production cluster, you must explicitely allow their usage by adding the following line to elasticsearch.yml:

```
searchguard.allow_unsafe_democertificates: true
```

The demo installation script adds this line automatically.