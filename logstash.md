# Using Search Guard with Logstash

todo: write

## logstash.conf

```
output {
    elasticsearch {
	   password => logstash
	   ssl => true
	   ssl_certificate_verification => true
	   truststore => "/path/to/elasticsearch-2.3.1/config/truststore.jks"
	   truststore_password => changeit
	   user => logstash
    }
}
```