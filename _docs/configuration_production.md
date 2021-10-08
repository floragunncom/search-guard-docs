---
title: Configuring Backup and Restore
slug: configuration-production
category: configuration
order: 400
layout: docs
description: How you can use sgadmin to quickly transfer your complete configuration from one system to another.
---
<!---
Copyright 2017 floragunn GmbH
-->
# Configuring Backup and Restore
{: .no_toc}

Once you have set up Search Guard on a testing or staging environment, you might want to replicate the exact Search Guard configuration on your production cluster.

If you have the Search Guard configuration files at hand, you can of course simply use [sgadmin](sgadmin.md) to upload them to production.

If you're unsure whether your configuration files actually resemble the active Search Guard configuration on your cluster, you can use [sgadmin](sgadmin.md) to retrieve the configuration from a running cluster, and upload it to another one:

Retrieve the current configuration from a cluster running on `staging.example.com` :

```
./sgadmin.sh --retrieve -h staging.example.com -ts ... -tspass ... -ks ... -kspass ...
```

To upload the dumped files to another cluster, here `production.example.com` listening on port 9301, use:

```
./sgadmin.sh -h production.example.com -cd /etc/backup/ 
    -ts ... -tspass ... -ks ... -kspass ...
```

You can read more details about this in the "Backup and Restore" chapter of the [sgadmin documentation](sgadmin.md).


