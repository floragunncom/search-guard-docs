---
title: Convert ES Watch
html_title: Import Elasticsearch Watch
permalink: elasticsearch-alerting-rest-api-convert-es
category: signals-rest
order: 710
layout: docs
edition: beta
description: How to automatically convert an existing Elasticsearch Alerting watch to the Signals format and import it.
---

<!--- Copyright 2020 floragunn GmbH -->

# Convert Watch API
{: .no_toc}

{% include toc.md %}

This feature is experimental at the moment! 
{: .note .js-note .note-warning}

## Endpoint

```
POST /_signals/convert/es
```

Converts a watch definition in ES Watcher format into Signals format. The result of the conversion is returned in the response body. Furthermore, the response body will list any potential problems that were found during the conversion.

The watch is not stored in Signals. It is up to the caller to `PUT` the watch afterwards.

## Request Body

A watch in ES Watcher format as a JSON document.

## Responses

### 200 OK

The watch could be converted; the conversion is possibly only partial. The returned JSON document will then list potential problems.

### 400 Bad Request

The JSON document could not be parsed.

## Examples

### Basic 

```
POST /_signals/convert/es
```
```json
{
    "trigger": {
        "schedule": {
            "daily": {
                "at": "noon"
            }
        }
    },
    "input": {
        "simple": {
            "x": "y"
        }
    },
    "actions": {
        "my_action": {
            "email": {
                "to": "horst@horst",
                "subject": "Hello World",
                "body": "Hallo {{ctx.payload.x}}",
                "attachments": "foo"
            }
        },
        "another_action": {
            "index": {
                "index": "foo",
                "execution_time_field": "holla"
            }
        }
    }
}
```

**Response**

```
200 OK
```

```json
{
  "status" : "Watch was partially converted; One problem was encountered for attribute actions.email.type.attachments: Attachments are not supported",
  "signals_watch" : {
    "trigger" : {
      "schedule" : {
        "daily" : [
          {
            "at" : "12:00"
          }
        ]
      }
    },
    "checks" : [
      {
        "type" : "static",
        "name" : null,
        "target" : null,
        "value" : {
          "x" : "y"
        }
      }
    ],
    "actions" : [
      {
        "type" : "email",
        "name" : "my_action",
        "to" : [
          "horst@horst"
        ],
        "subject" : "Hello World",
        "text_body" : "Hallo {{data.x}}"
      },
      {
        "type" : "index",
        "name" : "another_action",
        "checks" : [
          {
            "type" : "calc",
            "source" : "data.holla = execution_time;"
          }
        ],
        "index" : "foo"
      }
    ],
    "active" : true,
    "log_runtime_data" : false,
    "_meta" : { }
  },
  "detail" : {
    "actions.email.type.attachments" : [
      {
        "error" : "Attachments are not supported"
      }
    ]
  }
}
```


