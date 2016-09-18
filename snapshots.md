<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Snapshots and Restore

Since all user-, role- and permission settings are stored in the Search Guard index inside Elasticsearch, it will also be part of any snapshot you make.

Because the Search Guard index contains sensitive information, snaphots and restores are only allowed if an admin certificate is sent with the snapshot/restore request.

Please see chapter [Using sgadmin](sgadmin.md) for more information on admin certificates.