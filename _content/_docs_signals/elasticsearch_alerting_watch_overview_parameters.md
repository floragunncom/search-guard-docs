---
title: Watch overview page query params
html_title: Watch overview page query params
permalink: elasticsearch-alerting-watch-overview-parameters
layout: docs
edition: community
description: How to use query parameters to change
---
Filtering and Sorting Watches in Kibana

Introduced in Search Guard FLX 1.1.0
{: .available-since}

The Signals Kibana UI provides an overview page for watches. The filter, sorting and pagination of this page can be controlled with URL params.

```
Example: ?query=ticket&pageIndex=0&pageSize=10&sortField=status&sortDirection=asc
```


| Parameter          | Description                                     |
|---|-------------------------------------------------|
| query       | A filter expression to filter the watches table |
| pageIndex      | The pagination position                         |
| pageSize | The number of displayed watches per page        |
| sortField | The attribute to sort by                        |
| sortDirection      | The sort directions, either asc or desc         |
{: .config-table}