---
title: Online TLS Generator
slug: online-tls-generator
category: generating-certificates
order: 200
layout: docs
edition: community
description: Use the Search Guard online TLS service to generate all certificates required to run Search Guard. 
resources:
  - https://search-guard.com/generating-certificates-tls-tool/|Generating production-ready certificates with the TLS tool (blog post)
  - https://search-guard.com/elasticsearch-searchguard-tls-introduction/|An introduction to TLS (blog post)
  - https://search-guard.com/elasticsearch-tls-certificates/|An introduction to TLS certificates (blog post)

---
<!---
Copyright 2017 floragunn GmbH
-->

# Online TLS certificate generator
{: .no_toc}

{% include_relative _includes/toc.md %}

We provide an [online TLS service](https://search-guard.com/tls-certificate-generator/){:target="_blank"} which you can use to generate all required certificates for running Search Guard: 

[https://search-guard.com/tls-certificate-generator/](https://search-guard.com/tls-certificate-generator/){:target="_blank"}

You need to provide your email address and organisation name, and can specify up to 10 hostnames. The certificates, key and truststore files are generated in the background and we will send you a download link once the certificates have been created.

Your email is necessary to send you the download link, while the organisation name will become part of the generated root CA. **Use only letters, digits, hyphens and dots for the hostname**.

## Generated artefacts

After downloading and unpacking the certificate archive, you will see the following file structure:


<div class="file-tree">
	<div class="file-tree-title"> File hierarchy
		<ul class="file-tree-buttons">
			<li class="js-expand">
				<i class="fa fa-plus"></i> Expand all</li>
			<li class="js-collapse">
				<i class="fa fa-minus"></i> Collapse all</li>
		</ul>
	</div>
	<ul class="file-tree-list js-file-tree treeview" data-expanded="">
		<li class="is-folder contains-items">node-certificates -
			<span class="file-tree-description">Node certificates for all hostnames</span>
			<ul style="display: none;">
				<li class="is-file">CN=[hostname]-keystore.jks -
					<span class="file-tree-description">Keystore containing the node certificate for <i>[hostname]</i></span>
				</li>
				<li class="is-file">CN=[hostname]-keystore.p12 -
					<span class="file-tree-description">PKCS#12 containing the node certificate for <i>[hostname]</i></span>
				</li>
				<li class="is-file">CN=[hostname]-signed.pem -
					<span class="file-tree-description">PEM certificate for <i>[hostname]</i>, without root or intermediate CA</span>
				</li>
				<li class="is-file">CN=[hostname].crtfull.pem -
					<span class="file-tree-description">Full certificate chain for  <i>[hostname]</i>, with root and intermediate CA</span>
				</li>
				<li class="is-file">CN=[hostname].key.pem -
					<span class="file-tree-description">Private key for  <i>[hostname]</i></span>
				</li>
			</ul>
		</li>
		<li class="is-folder contains-items">client-certificates -
			<span class="file-tree-description">Client- and admin certificates</span>
			<ul style="display: none;">
				<li class="is-file">CN=sgadmin-keystore.jks
					<span class="file-tree-description">Keystore containing the admin certificate. Can be used with sgadmin.</span>
				</li>
				<li class="is-file">CN=sgadmin-keystore.p12
					<span class="file-tree-description">PKCS#12 containing the admin certificate. Can be used with sgadmin.</span>
				</li>
				<li class="is-file">CN=sgadmin-signed.pem
					<span class="file-tree-description">PEM admin certificate</span>
				</li>
				<li class="is-file">CN=sgadmin.crtfull.pem
					<span class="file-tree-description">PEM admin certificate including the root and intermediate CA. Can be used with sgadmin.</span>
				</li>
				<li class="is-file">CN=sgadmin.key.pem
					<span class="file-tree-description">Private key for the admin certificate. Can be used with sgadmin.</span>
				</li>
				<li class="is-file">CN=sgadmin.csr
					<span class="file-tree-description">The CSR used to create the  admin certificate</span>
				</li>
				<li class="is-file">CN=demouser-keystore.jks
					<span class="file-tree-description">Keystore containing a client certificate. Can be used for TLS client authentication or for Transport Clients.</span>
				</li>
				<li class="is-file">CN=demouser-keystore.p12
					<span class="file-tree-description">PKCS#12 containing a client certificate. Can be used for TLS client authentication or for Transport Clients.</span>
				</li>
				<li class="is-file">CN=demouser-signed.pem
					<span class="file-tree-description">PEM client certificate</span>
				</li>
				<li class="is-file">CN=demouser.crtfull.pem
					<span class="file-tree-description">PEM client certificate including the root and intermediate CA. Can be used for TLS client authentication or for Transport Clients.</span>
				</li>
				<li class="is-file">CN=demouser.key.pem
					<span class="file-tree-description">Private key for the client certificate. Can be used for TLS client authentication or for Transport Clients.</span>
				</li>
				<li class="is-file">CN=demouser.csr
					<span class="file-tree-description">The CSR used to create the  client certificate</span>
				</li>

			</ul>
		</li>
		<li class="is-folder contains-items">root-ca -
			<span class="file-tree-description">The root CA used for creating the signing certificates</span>
			<ul style="display: none;">
				<li class="is-file">root-ca.crt -
					<span class="file-tree-description">Root CA in CRT format</span>
				</li>
				<li class="is-file">root-ca.pem -
					<span class="file-tree-description">Root CA in PEM format</span>
				</li>
				<li class="is-file">root-ca.key -
					<span class="file-tree-description">Private key of the root CA</span>
				</li>
			</ul>
		</li>
		<li class="is-folder contains-items">signing-ca -
			<span class="file-tree-description">The signing CA used for creating and signing the node certificates</span>
			<ul style="display: none;">
				<li class="is-file">signing-ca.crt -
					<span class="file-tree-description">Signing CA in CRT format</span>
				</li>
				<li class="is-file">signing-ca.pem -
					<span class="file-tree-description">Signing CA in PEM format</span>
				</li>
				<li class="is-file">root-ca.key -
					<span class="file-tree-description">Private key of the signing CA</span>
				</li>
			</ul>

		</li>

		<li class="is-file">truststore.jks -
			<span class="file-tree-description">Truststore containing the root CA</span>
		</li>
		<li class="is-file">truststore.p12 -
			<span class="file-tree-description">PKCS#12 containing the root CA</span>
		</li>
		<li class="is-file">root-ca.pem -
			<span class="file-tree-description">PEM containing the root certificate</span>
		</li>
		<li class="is-file">chain-ca.pem -
			<span class="file-tree-description">PEM containing the root and the intermediate certificate</span>
		</li>
		<li class="is-file">README.txt -
			<span class="file-tree-description">Installation instructions. You can find all auto-generated passwords here.</span>
		</li>
	</ul>	
</div>