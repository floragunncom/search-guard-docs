---
title: Execution context
html_title: Execution context
slug: elasticsearch-alerting-security-security-context
category: security
order: 200
layout: docs
edition: community
description: Understanding the security execution context of Signals Alerting for Elasticsearch
---

<!--- Copyright 2020 floragunn GmbH -->

# Security execution context
{: .no_toc}

Signals is fully integrated with all Search Guard security features.

In particular this means that each watch is executed in a **security context** that controls **to what data on Elasticsearch the watch has access to**:

* The security context is stored as part of the watch definition
* It is encrypted, and can be changed only by the Signals application
* It is not accessible via the REST API.

Each watch is executed with the **Search Guard permissions** the user that created the watch had **at the time of watch creation**.

The security context is not bound to a Search Guard user or a Search Guard role. This makes sure that even if the user who created watches is deleted, the created watches will continue to work.

The permissions that are stored in the security context of the watch include access permissions to indices, and also all advanced settings like [Document- and Field-level security](document-level-security) or [Field anonymization](field-anonymization).

If a user edits a watch has had been created before by a different user, the security context will be replaced with the permissions of the current user.
