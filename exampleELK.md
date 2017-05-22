Example


1. [Install SearchGuard Plugin in ElasticSearch](exampleELK.md#1)
2. Generate TLS certificates 
3. Load Sample Data to ElasticSearch	 
4. Kibana Install SearchGuard Plugin	 
5. Kibana Config	 
6. FileBeat Configure and Start	 
7. ElasticSearch Enable SSL	 
 


## <a name="1"></a>  Install SearchGuard Plugin in ElasticSearch
Match correct version.  Show [version support matrix](https://github.com/floragunncom/search-guard/wiki).

If you get any errors about not having enough memory you can increase the user quota by:


`sysctl -w vm.max_map_count=262144`


`./elasticsearch-plugin install -b com.floragunn:search-guard-5:5.2.2-12`

**Generate TLS certificates**
You can use your own cerificate authority, get [Florgunn to do it for you](https://floragunn.com/tls-certificate-generator/), or use the demo install explained below.


## <a name="2"></a> Demo Cert Installation

2017-05-22T21:42:25,338][INFO ][c.f.s.c.IndexBaseConfigurationRepository] searchguard index does not exist yet, so no need to load config on node startup. Use sgadmin to initialize cluster

After installing Search Guard, you will find the script here:

`<ES dir>/plugins/search-guard-5/tools/install_demo_configuration.sh`

Then restart ElasticSearch and then run:

`<ES dir>/plugins/search-guard-5/tools/sgadmin_demo.sh`

Then elasticsearch.yml will be update to:

 
```
######## Start Search Guard Demo Configuration ########
searchguard.ssl.transport.keystore_filepath: keystore.jks
searchguard.ssl.transport.truststore_filepath: truststore.jks
searchguard.ssl.transport.enforce_hostname_verification: false
```



# <a name="3"></a> Whether to enable TLS on the REST layer or not
```
searchguard.ssl.http.enabled: true
searchguard.ssl.http.keystore_filepath: keystore.jks
searchguard.ssl.http.truststore_filepath: truststore.jks
searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,L=test, C=de

cluster.name: searchguard_demo
network.host: 0.0.0.0
```


Print cert:

Issuer: CN=Example Com Inc. Signing CA, OU=Example Com Inc. Signing CA, O=Example Com Inc., DC=example, DC=com
keytool -list  -storepass changeit -keystore keystore.jks -printcert -file /tmp/keystore.crt -alias node-0
keytool -list  -storepass changeit -keystore trusttore.jks -printcert -file /tmp/keystore.crt -alias root-ca-chain

## Load Sample Data to ElasticSearch

`load_sampledata.sh.`

It created two indices: humanresources and finance and populates them with sample data.

Which you can see by telling curl to ignore cert validation and logging with the admin user:

`curl --insecure -u admin:admin -k 'https://localhost:9200/_cat/indices?v'`


## <a name="4"></a> Kibana Install SearchGuard Plugin
[Kibana instructions on Git](https://github.com/floragunncom/search-guard-docs/blob/master/kibana.md).

```
bin/kibana-plugin install file:///searchguard-kibana-5.3.2-2.zip
```
It is not necessary to add any config options to kibana.yml except the ElasticSearch username and password.  The default values will work:

```
sudo cat /usr/share/kibana/kibana-5.2.2-linux-x86_64/config/kibana.yml 

elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"
```


Test SSL connection to ElasticSearch:

```
openssl s_client -connect localhost:9200

CONNECTED(00000003)
depth=1 DC = com, DC = example, O = Example Com Inc., OU = Example Com Inc. Signing CA, CN = Example Com Inc. Signing CA
verify error:num=20:unable to get local issuer certificate
verify return:0
---
Certificate chain
 0 s:/C=DE/L=Test/O=Test/OU=SSL/CN=node-0.example.com
   i:/DC=com/DC=example/O=Example Com Inc./OU=Example Com Inc. Signing CA/CN=Example Com Inc. Signing CA
 1 s:/DC=com/DC=example/O=Example Com Inc./OU=Example Com Inc. Signing CA/CN=Example Com Inc. Signing CA
   i:/DC=com/DC=example/O=Example Com Inc./OU=Example Com Inc. Root CA/CN=Example Com Inc. Root CA
```

 


curl --insecure -u admin:admin -k 'https://localhost:9200/_cat/indices?v'


TypeError: "field" is a required parameter
    at FieldAggParamFactory.FieldAggParam.write (http://localhost:5601/bundles/kibana.bundle.js?v=14849:73:9103)
    at http://localhost:5601/bundles/kibana.bundle.js?v=14849:73:5942
    at AggParams.forEach (native)
    at AggParamsFactory.AggParams.write (http://localhost:5601/bundles/kibana.bundle.js?v=14849:73:5900)
    at AggConfigFactory.AggConfig.write (http://localhost:5601/bundles/kibana.bundle.js?v=14849:76:3473)
    at AggConfigFactory.AggConfig.toDsl (http://localhost:5601/bundles/kibana.bundle.js?v=14849:76:4230)
    at http://localhost:5601/bundles/kibana.bundle.js?v=14849:76:25195
    at Array.forEach (native)
    at AggConfigsFactory.AggConfigs.toDsl (http://localhost:5601/bundles/kibana.bundle.js?v=14849:76:24978)
    at http://localhost:5601/bundles/kibana.bundle.js?v=14849:71:890

http://localhost:5601/bundles/kibana.bundle.js?v=14849:73:5942


## <a name="5"></a> FileBeat Configure and Start



cat /usr/share/filebeat/filebeat-5.4.0-linux-x86_64/filebeat.yml

```
 filebeat.prospectors:
- input_type: log
  paths:
    - /tmp/logs/*
output.logstash:
  hosts: ["localhost:5043"]
```
  

### <a name="6"></a> Start FileBeat:

`sudo ./filebeat -e -c filebeat.yml -d "publish"`


## <a name="7"></a> Logstash Config

 
`bin/logstash -f first-pipeline.conf `


```
input {
    beats {
        port => "5043"
    }
}
 {
}
output {
  elasticsearch {
        ssl_certificate_verification => false
        hosts => [ "https://localhost:9200" ]
    }
}
```
 



