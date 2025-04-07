---
title: Search Guard 7.x-53.1.0
permalink: changelog-searchguard-7x-53_1_0
layout: changelogs
description: Changelog for Search Guard 7.x-53.1.0
---
<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 53.1

**Release Date: 2022-03-31**

This is a bug fix for a security issue in the DLS implementation of Search Guard.

## Security Bug Fixes

### Unauthorized access to single attribute values

A flaw was discovered in the DLS implementation where single attributes values could be exposed to a user, even if the user does not have privileges to access documents containing these attribute values.

**Note:** The flaw only exposed single attribute values, but **not** whole documents.

**Affected Versions:**

All Search Guard versions prior to 53.1.0.

**Solution:**

Update to Search Guard version 53.1.0.

