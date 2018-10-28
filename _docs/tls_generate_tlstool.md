---
title: Offline TLS Tool
slug: offline-tls-tool
category: generating-certificates
order: 300
layout: docs
edition: community
description: Use the Search Guard TLS tool to generate production-ready TLS certificates for your Elasticsearch cluster.
resources:
  - https://search-guard.com/generating-certificates-tls-tool/|Generating production-ready certificates with the TLS tool (blog post)
  - https://search-guard.com/elasticsearch-searchguard-tls-introduction/|An introduction to TLS (blog post)
  - https://search-guard.com/elasticsearch-tls-certificates/|An introduction to TLS certificates (blog post)

---
<!---
Copryight 2017 floragunn GmbH
-->

# TLS Tool
{: .no_toc}

{% include_relative _includes/toc.md %}

We provide an [offline TLS tool](https://search.maven.org/#search%7Cga%7C1%7Ca%3A%22search-guard-tlstool%22){:target="_blank"} which you can use to generate all required certificates for running Search Guard in production: 

[Search Guard TLS Tool](https://search.maven.org/#search%7Cga%7C1%7Ca%3A%22search-guard-tlstool%22){:target="_blank"}

Just download the `zip` or `tar.gz` file and unpack it in a directory of your choice.

The TLS Tool is platform independent and can be used for 

* Generating Root and Intermediate CAs
* Generating Node, Client and Admin certificates
* Generating CSRs 
* Validating certificates

Besides the actual certificates the tool also generated configuration snippets which you can directly copy and paste into your `elasticsearch.yml`.

## General usage

The TLS tool will read the node- and certificate configuration settings from a yaml file, and outputs the generated files in a configurable directory.

You can choose to create the Root CA and (optional) intermediate CAs with your node certificates in one go. Or you can create the Root and intermediate CA first, and generate node certificates as you need them.

After unpacking the archive, you will find the Linux/OSX or Windows script in:

```
<installation directory>/tools/sgtlstool.sh
<installation directory>/tools/sgtlstool.bat
```

## Command line options

| Name | Description |
|---|---|
| -c,--config | Relative or absolute path to the configuration file. Required. |
| -t,--target | Relative or absolute path to the output directory. Optional, default: out|
| -v,--verbose  | Enable detailed output, default: false|
| -f,--force  | Force certificate generation despite of validation errors. default: false|
| -o,--overwrite  | Overwrite existing node-, client and admin certificates if they are already present. default: false |
| -ca,--create-ca  | Create new Root and Intermediate CAs |
| -crt,--create-cert  | Create certificates using an existing or newly created local certificate authority |

## Example

```
<installation directory>/tools/sgtlstool.sh -c ../config/tlsconfig.yml -ca -crt
```

Reads the configuration from `../config/tlsconfig.yml` and generates the configured Root and intermediate CAs and the configured node, admin and client certificates in one go. The generated files will be written to `out`.

```
<installation directory>/tools/sgtlstool.sh -c ../config/tlsconfig.yml -ca
```

Reads the configuration from `../config/tlsconfig.yml` and generates the configured Root and intermediate CAs only.

```
<installation directory>/tools/sgtlstool.sh -c ../config/tlsconfig.yml -crt
```

Reads the configuration from `../config/tlsconfig.yml` and generates node, admin and client certificates only. The Root and (optional) intermediate CA certificates and keys need to be present in the output directory, and their filenames, keys and (optional) passwords have to be configured in `tlsconfig.yml`

## Root CA

To configure the Root CA for all certificates, add the following lines to your configuration file:

```
ca:
   root:
      dn: CN=root.ca.example.com,OU=CA,O=Example Com\, Inc.,DC=example,DC=com
      keysize: 2048
      pkPassword: root-ca-password 
      validityDays: 3650
      file: root-ca.pem
```

Options:

| Name | Description |
|---|---|
| dn | The complete Distinguished Name of the Root CA. If you have special characters in the DN, you need to [quote them correctly](../_troubleshooting/tls_troubleshooting.md#checking-for-special-characters-in-dns){:target="_blank"}. Mandatory. |
| keysize | The size of the private key. Default: 2048 |
| pkPassword | Password of the private key. One of: "none", "auto" or a self chosen password. Default: auto |
| file | File name of the certificate, optional. Default: "root-ca" |

The pkPassword can be one of:

* **none**: The generated private key will be unencrypted
* **auto**: A random password is generated automatically. After the certificates have been generated, you can find the password in `root-ca.readme` file. In order to use these new passwords later again, you must edit the tool config file and set the generated passwords there.
* **other values**: Values other than none or auto are used as password directly

<div class="file-tree">
	<div class="file-tree-title"> Generated files
		<ul class="file-tree-buttons">
			<li class="js-expand">
				<i class="fa fa-plus"></i> Expand all</li>
			<li class="js-collapse">
				<i class="fa fa-minus"></i> Collapse all</li>
		</ul>
	</div>
	<ul class="file-tree-list js-file-tree treeview" data-expanded="true">
		<li class="is-folder contains-items">out
			<ul style="display: none;">
				<li class="is-file">root-ca.pem
					<span class="file-tree-description">Root certificate</span>
				</li>
				<li class="is-file">root-ca.key
					<span class="file-tree-description">Private key of the Root CA</span>
				</li>
				<li class="is-file">root-ca.readme
					<span class="file-tree-description">Passwords of the root and intermediate CAs</span>
				</li>
			</ul>
		</li>
	</ul>
</div>

## Intermediate CA

In addition to the root CA you optionally also specify an intermediate CA. If an intermediate CA is configured, then the node, admin and client certificates will be signed by the intermediate CA. If you do want to use an intermediate CA, remove the following section from the configuration. The certificates are then signed by the root CA directly.

```
ca:
   intermediate:
      dn: CN=signing.ca.example.com,OU=CA,O=Example Com\, Inc.,DC=example,DC=com
      keysize: 2048
      validityDays: 3650  
      pkPassword: intermediate-ca-password
      file: intermediate-ca.pem
```

<div class="file-tree">
	<div class="file-tree-title"> Generated files
		<ul class="file-tree-buttons">
			<li class="js-expand">
				<i class="fa fa-plus"></i> Expand all</li>
			<li class="js-collapse">
				<i class="fa fa-minus"></i> Collapse all</li>
		</ul>
	</div>
	<ul class="file-tree-list js-file-tree treeview" data-expanded="true">
		<li class="is-folder contains-items">out
			<ul style="display: none;">
				<li class="is-file">intermediate-ca.pem
					<span class="file-tree-description">Intermediate certificate</span>
				</li>
				<li class="is-file">intermediate-ca.key
					<span class="file-tree-description">Private key of the intermediate  certificate</span>
				</li>
				<li class="is-file">root-ca.readme
					<span class="file-tree-description">Auto-generated passwords of the root and intermediate CAs</span>
				</li>
			</ul>
		</li>
	</ul>
</div>

## Node and Client certificates

### Global and default settings

The default settings are applied to all generated certificates and configuration snippets. All values here are optional.

```
defaults:
  validityDays: 730
  pkPassword: auto
  generatedPasswordLength: 12
  nodesDn:
    - "CN=*.example.com,OU=Ops,O=Example Com\\, Inc.,DC=example,DC=com"
  nodeOid: "1.2.3.4.5.5"
  httpEnabled: true
  reuseTransportCertificatesForHttp: false
```

Options:

| Name | Description |
|---|---|
| validityDays | Validity of the generated certificates, in days. Default: 730. Can be overwritten for each certificate separately. |
| pkPassword | Password of the private key. One of: "none", "auto" or a self chosen password. Default: auto. Can be overwritten for each certificate separately. |
| generatedPasswordLength | Length of the auto-generated password for the private keys. Only takes effect when `pkPassword` is set to `auto`. Default: 12. Can be overwritten for each certificate separately. |
| nodesDn | Value of the `searchguard.nodes_dn` in the configuration snippet. Optional. If omitted, all DNs of all node certificates are listed. If you want to define your node certificates by using wildcards or regular expressions, set the values here. Default: list all DNs explicitely |
| nodeOid | If you want to use OIDs to mark legitimate node certificates instead of listing them in `searchguard.nodes_dn`, set the OID here. It will be included in the SAN section of all node certificates. Default: Don't add the OID to the SAN section. |
| httpsEnabled | Whether to enable TLS on the REST layer or not. Default: true |
| reuseTransportCertificatesForHttp | If set to false, individual certificates for REST and Transport are generated. If set to true, the node certificates are also used on the REST layer. Default: false |
| verifyHostnames | Set this to true to [enable hostname verification](tls_configuration.md#advanced-hostname-verification-and-dns-lookup){:target="_blank"}. Default: false |
| resolveHostnames | Set this to true to [resolve hostnames against DNS](tls_configuration.md#advanced-hostname-verification-and-dns-lookup){:target="_blank"}. Default: false |

### Node certificates

To generate node certificates, add the node name, the Distinguished Name,  the hostname(s) and/or the IP address(es) in the `nodes` section:

```
nodes:
  - name: node1
    dn: CN=node1.example.com,OU=Ops,O=Example Com\, Inc.,DC=example,DC=com
    dns: node1.example.com
    ip: 10.0.2.1
  - name: node2
    dn: CN=node2.example.com,OU=Ops,O=Example Com\, Inc.,DC=example,DC=com
    dns: 
      - node2.example.com
      - es2.example.com
    ip: 
      - 10.0.2.1
      - 192.168.2.1
  - name: node3
    dn: CN=node3.example.com,OU=Ops,O=Example Com\, Inc.,DC=example,DC=com
    dns: node3.example.com
```    

Options:

| Name | Description |
|---|---|
| name | Name of the node, will become part of the filenames. Mandatory |
| dn | The Distinguished Name of the certificate. If you have special characters in the DN, you need to [quote them correctly](../_troubleshooting/tls_troubleshooting.md#checking-for-special-characters-in-dns){:target="_blank"}. Mandatory |
| dns | The hostname(s) this certificate is valid for. Should match the `hostname` of the node. Optional, but recommended.  |
| ip | The IP(s) this certificate is valid for. Optional. Prefer hostnames if possible.  |


<div class="file-tree">
	<div class="file-tree-title"> Generated files
		<ul class="file-tree-buttons">
			<li class="js-expand">
				<i class="fa fa-plus"></i> Expand all</li>
			<li class="js-collapse">
				<i class="fa fa-minus"></i> Collapse all</li>
		</ul>
	</div>
	<ul class="file-tree-list js-file-tree treeview" data-expanded="true">
		<li class="is-folder contains-items">out
			<ul style="display: none;">
				<li class="is-file">[nodename].pem
					<span class="file-tree-description">Node certificate</span>
				</li>
				<li class="is-file">[nodename].key
					<span class="file-tree-description">Private key of the node certificate</span>
				</li>
				<li class="is-file">[nodename]_http.pem
					<span class="file-tree-description">REST certificate, only generated if reuseTransportCertificatesForHttp is false</span>
				</li>
				<li class="is-file">[nodename]_http.key
					<span class="file-tree-description">Private key of the REST certificate, only generated if reuseTransportCertificatesForHttp is false</span>
				</li>

				<li class="is-file">[nodename]_elasticsearch_config_snippet.yml
					<span class="file-tree-description">Search Guard configuration snippet for this node, add this to elasticsearch.yml</span>
				</li>
			</ul>
		</li>
	</ul>
</div>

## Admin and client certificates

To generate admin and client certificates, add the following lines to the configuration file:

```
clients:
  - name: spock
    dn: CN=spock.example.com,OU=Ops,O=Example Com\, Inc.,DC=example,DC=com
  - name: kirk
    dn: CN=kirk.example.com,OU=Ops,O=Example Com\, Inc.,DC=example,DC=com
    admin: true
```

Options:

| Name | Description |
|---|---|
| name | Name of the certificate, will become part of the file name |
| dn | The complete Distinguished Name of the certificate. If you have special characters in the DN, you need to [quote them correctly](../_troubleshooting/tls_troubleshooting.md#checking-for-special-characters-in-dns){:target="_blank"} |
| admin  | If set to true, this certificate will be marked as admin certificate in the generated configuration snippet.  |

Note that you need to mark at least one client certificate as admin certificate.

<div class="file-tree">
	<div class="file-tree-title"> Generated files
		<ul class="file-tree-buttons">
			<li class="js-expand">
				<i class="fa fa-plus"></i> Expand all</li>
			<li class="js-collapse">
				<i class="fa fa-minus"></i> Collapse all</li>
		</ul>
	</div>
	<ul class="file-tree-list js-file-tree treeview" data-expanded="true">
		<li class="is-folder contains-items">out
			<ul style="display: none;">
				<li class="is-file">[name].pem
					<span class="file-tree-description">Client certificate</span>
				</li>
				<li class="is-file">[name].key
					<span class="file-tree-description">Private key of the client certificate</span>
				</li>
				<li class="is-file">client-certificates.readme
					<span class="file-tree-description">Contains the auto-generated passwords for the certificates</span>
				</li>
			</ul>
		</li>
	</ul>
</div>


## Adding certificates after the first run

You can always add more node- or admin certificates as you need them after the initial run of the tool. As a precondition

* the root CA and, if used, the intermediate certificates and keys must be present in the output folder
* the password of the root CA and, if used, the intermediate CA must be present in the config file

If you use auto-generated passwords, copy them from the generated `root-ca.readme` file to the configuration file.

Certificates that have already been generated in a previous run of the tool will be left untouched unless you run the tool with the `-o,--overwrite` switch. In this case existing files are overwritten. If you have chosen to auto-generate passwords, new keys with auto-generated passwords are created.

## Creating CSRs

If you just want to create CSRs to submit them to your local CA, you can omit the `ca` part of the config complete. Just define the `default`, `node` and `client` section, and run the TLS tool with the `-csr` switch:

```
/sgtlstool.sh -c ../config/example.yml -csr
```


## Validating certificates

The TLS diagnose tool can be used to verify your certificates and your certificate chains:

```
<installation directory>/tools/sgtlsdiag.sh
<installation directory>/tools/sgtlsdiag.bat
```

### Command line options

| Name | Description |
|---|---|
| -ca,--trusted-ca | Path to a PEM file containing the certificate of a trusted CA|
| -crt,--certificates | Path to PEM files containing certificates to be checked |
| -es,--es-config | Path to the ElasticSearch config file containing the SearchGuard TLS configuration |
| -v,--verbose | Enable detailed output|

### Example: Checking PEM certificates directly

```
<installation directory>/tools/sgtlsdiag.sh -ca out/root-ca.pem -crt out/node1.pem
```

The diagnose tool will output the contents of the provided certificates and checks that the trust chain is valid. Example:

```
------------------------------------------------------------------------
Certificate 1
------------------------------------------------------------------------
            SHA1 FPR: 6A2049B9C7F8E48A79B81D60378F4C98EFD34B75
             MD5 FPR: 72C7F44B875FA777C6A4F047060304C6
Subject DN [RFC2253]: CN=node1.example.com,OU=Ops,O=Example Com\, Inc.,DC=example,DC=com
       Serial Number: 1519568340695
 Issuer DN [RFC2253]: CN=signing.ca.example.com,OU=CA,O=Example Com\, Inc.,DC=example,DC=com
          Not Before: Sun Feb 25 15:19:02 CET 2018
           Not After: Wed Feb 23 15:19:02 CET 2028
           Key Usage: digitalSignature nonRepudiation keyEncipherment
 Signature Algorithm: SHA256WITHRSA
             Version: 3
  Extended Key Usage: id_kp_serverAuth id_kp_clientAuth
  Basic Constraints: -1
                SAN: 
                  dNSName: node1.example.com
                  iPAddress: 10.0.2.1

------------------------------------------------------------------------
Certificate 2
------------------------------------------------------------------------
            SHA1 FPR: BBCF41A85E85385B8301FA641E9BF002086AAED5
             MD5 FPR: 3E1C2881A05FF08B4582F3AC2D2443B9
Subject DN [RFC2253]: CN=signing.ca.example.com,OU=CA,O=Example Com\, Inc.,DC=example,DC=com
       Serial Number: 2
 Issuer DN [RFC2253]: CN=root.ca.example.com,OU=CA,O=Example Com\, Inc.,DC=example,DC=com
          Not Before: Sun Feb 25 15:19:02 CET 2018
           Not After: Wed Feb 23 15:19:02 CET 2028
           Key Usage: digitalSignature keyCertSign cRLSign
 Signature Algorithm: SHA256WITHRSA
             Version: 3
  Extended Key Usage: null
  Basic Constraints: 0
                SAN: (none)
------------------------------------------------------------------------
Trust anchor:
DC=com,DC=example,O=Example Com\, Inc.,OU=CA,CN=root.ca.example.com
```

### Example: Checking TLS settings in elasticsearch.yml

By using the `-es` switch you can also check the TLS configuration in your elasticsearch.yml directly:

```
<installation directory>/tools/sgtlsdiag.sh -es /etc/elasticsearch/elasticsearch.yml
```



