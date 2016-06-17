<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Snapshots and Snapshot Restore

Since all user-, role- and permission settings are stored in the Search Guard index inside Elasticsearch, it will also be part of any snapshot you make.

However, since Search Guard is used to protect your Elasticsearch data from unauthorized access, anyone who has access to your snapshot(s) can read the data anyways, regardless if the Search Guard settings are included in the snapshot or not.

So, please make sure that only authorized users have access to your snapshots - but that's what you should do anyways.