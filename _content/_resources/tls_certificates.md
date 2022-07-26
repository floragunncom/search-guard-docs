---
title: TLS Demo Certificates
html_title: TLS Demo Certificates
permalink: tls-demo-certificates
category: resources
order: 200
layout: resources
description: Download the Search Guard TLS demo certificates for setting up a working PoC in no time. Works on Linux, Mac and Windows.
---
<!---
Copyright 2020 floragunn GmbH
-->

# TLS demo certificates

In order to set up a Search Guard PoC quickly, you can simply download and install our demo TLS certificates. The certificates can be used for node to node TLS encryption, REST encryption and for using sgadmin. They work on Linux, Mac and Windows.

<div class="header-back-buttons helper center" style="margin-top: 40px; margin-bottom:40px;">
<a href="/resources/certificates/certificates.zip" target="_blank" class="button stroke rounded large blue">Download Demo Certificates</a>
</div>

**The certificates are for PoC usage only. Do not install on production.**

## Download and install

Download the [certificates zip file](/resources/certificates/certificates.zip){:target="_blank"}, unpack it and place all files in the following directory:

```
<ES installation directory>/config
```

<<<<<<< tech-preview
Next, add the Search Guard TLS configuration to `opensearch.yml`/`elasticsearch.yml`:
=======
Next, add the Search Guard TLS configuration to `elasticsearch.yml`:
>>>>>>> 2a2e5e1 OpenSearch support

<div class="code-highlight " data-label="">
<span class="js-copy-to-clipboard copy-code">copy</span> 
<pre class="language-yml">
<code class=" js-code language-markup">
searchguard.ssl.transport.pemcert_filepath: esnode.pem
searchguard.ssl.transport.pemkey_filepath: esnode-key.pem
searchguard.ssl.transport.pemtrustedcas_filepath: root-ca.pem
searchguard.ssl.transport.enforce_hostname_verification: false
searchguard.ssl.http.enabled: true
searchguard.ssl.http.pemcert_filepath: esnode.pem
searchguard.ssl.http.pemkey_filepath: esnode-key.pem
searchguard.ssl.http.pemtrustedcas_filepath: root-ca.pem
searchguard.allow_unsafe_democertificates: true
searchguard.allow_default_init_sgindex: true
searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test,C=de
</code>
</pre>
</div>


This will enable TLS encryption on transport and on REST layer. 

## Using sgadmin with the demo certificates

The demo certificates contain an admin TLS certificate which you can use to run [sgadmin](https://docs.search-guard.com/latest/sgadmin){:target="_blank"}:

<div class="file-tree">
	<ul class="file-tree-list js-file-tree treeview" data-expanded="">
		<li class="is-file">kirk.pem -
			<span class="file-tree-description">The admin certificate that can be used with sgadmin.</span>
		</li>
		<li class="is-file">kirk-key.pem -
			<span class="file-tree-description">Private key for the admin certificate. This key has no password set.</span>
		</li>
	</ul>	
</div>

To execute sgadmin with the `kirk` admin certificate, switch to the following directory:

```
<ES installation directory>/plugins/search-guard-<version>/tools/
```

And execute:

```
./sgadmin.sh -cd ../sgconfig -key ../../../config/kirk-key.pem -cert ../../../config/kirk.pem -cacert ../../../config/root-ca.pem -nhnv -icl
```

This will update the Search Guard configuration with the contents of the files located in:

```
<ES installation directory>/plugins/search-guard-<version>/config/
```

If everything is updated correctly, you will see the following output:

```
Will update 'sg/config' with ../sgconfig/sg_config.yml 
   SUCC: Configuration for 'config' created or updated
Will update 'sg/roles' with ../sgconfig/sg_roles.yml 
   SUCC: Configuration for 'roles' created or updated
Will update 'sg/rolesmapping' with ../sgconfig/sg_roles_mapping.yml 
   SUCC: Configuration for 'rolesmapping' created or updated
Will update 'sg/internalusers' with ../sgconfig/sg_internal_users.yml 
   SUCC: Configuration for 'internalusers' created or updated
Will update 'sg/actiongroups' with ../sgconfig/sg_action_groups.yml 
   SUCC: Configuration for 'actiongroups' created or updated
Done with success
```


## File contents

<div class="file-tree">
	<ul class="file-tree-list js-file-tree treeview" data-expanded="">
		<li class="is-file">root-ca.pem -
			<span class="file-tree-description">The root certificate used to sign all other certificates, in PEM format.</span>
		</li>
		<li class="is-file">esnode.pem -
			<span class="file-tree-description">Node certificate in PEM format. Can be used for inter-node and REST encryption.</span>
		</li>
		<li class="is-file">esnode-key.pem -
			<span class="file-tree-description">The private key for the node certificate. This key has no password set.</span>
		</li>
		<li class="is-file">kirk.pem -
			<span class="file-tree-description">The admin certificate that can be used with sgadmin.</span>
		</li>
		<li class="is-file">kirk-key.pem -
			<span class="file-tree-description">Private key for the admin certificate. This key has no password set.</span>
		</li>
		<li class="is-file">spock.pem -
			<span class="file-tree-description">Regular client certificate, can be used for PKI authentication.</span>
		</li>
		<li class="is-file">spock-key.pem -
			<span class="file-tree-description">Private key for the client certificate. This key has no password set.</span>
		</li>
	</ul>	
</div>

