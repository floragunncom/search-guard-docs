---
title: Search Guard Upgrade Overview
html_title: Search Guard Upgrade Overview
permalink: sg-upgrade-overview
layout: docs
section: security
edition: community
description: Search Guard Upgrade Overview
---
<!---
Copyright 2026 floragunn GmbH
-->

# Search Guard Upgrade Overview

Regarding the 8.7.1-1.6.0 to 8.7.1-2.0.0, this stop is required to migrate Kibana multi-tenancy with sgctl.sh special start-mt-data-migration-from-8.7 command. https://docs.search-guard.com/latest/sg-200-upgrade

I didn't test mt migration option with any other higher version of FLX and ELK. Also, 8.7.1-1.6.0 or 8.7.1-2.0.0 are not listed on the available versions page. https://docs.search-guard.com/latest/search-guard-versions

Regarding config migration, the highest I've tested was 3.x with LDAP auth.


## Search Guard Upgrade Tool (Experimental)

- [Download here](https://maven.search-guard.com/search-guard-flx-release/com/floragunn/sg-upgrade-tool/0.2.0-beta-1/sg-upgrade-tool-0.2.0-beta-1.sh)
- [Read the Documentation](https://git.floragunn.com/search-guard/sg-upgrade-tool/-/blob/main/README.md)

### Legend

| Marker | Meaning |
|---|---|
| **GATE** | Mandatory stepping stone — cannot be skipped |
| **STOP** | Do not land here; this version is unsafe for some configurations |
| **ACTION** | A config or data migration you must perform yourself |
| **HELM** | Helm-chart-only event |

---

## The two hard constraints

Everything below follows from these two facts.

### Constraint A — the classic-config bridge ends at FLX 3.1.3

Search Guard classic stores its configuration as a legacy `sg_config` document in the Search Guard index. The module that reads that format is `search-guard-flx-security-legacy` (with `dlic-search-guard-flx-security-legacy`).

In the Maven archive that module exists for **0.0.1 through 3.1.3 — and for no 4.x version.** The plugin POMs confirm which releases actually bundle it:

| Plugin release | Depends on the legacy modules? |
|---|---|
| `search-guard-flx-elasticsearch-plugin-3.1.3-es-9.0.8` | **Yes** — both `search-guard-flx-security-legacy` and `dlic-search-guard-flx-security-legacy` |
| `search-guard-flx-elasticsearch-plugin-4.1.2-es-9.4.4` | **No** — no legacy module at all |

**So FLX 1.0.0 – 3.1.3 is a bridge that can boot against a config index still holding classic configuration. FLX 4.x cannot.**

This is what makes the classic → FLX crossing survivable — and it has **nothing to do with Multi-Tenancy**. Any path that skips the bridge entirely is broken for every customer, MT or not.

### Constraint B — Elasticsearch 8.7.1 is the only ES 8 build of FLX 1.x

Search Guard is built per Elasticsearch patch version, so the SG version and the ES version are tightly coupled. Which builds actually exist:

| SG FLX | Elasticsearch builds that exist |
|---|---|
| 1.4.0 | 7.17.14 – 7.17.16, **8.7.1 (the only ES 8 build)** |
| 1.6.0 | 7.17.17 – 7.17.29, **8.7.1 (the only ES 8 build)** |
| 2.0.0 | 8.8.2 – 8.15.2 |
| 3.0.3 | 8.16.2 – 8.17.8 |
| 3.1.0 / 3.1.1 | 8.18.x |
| 3.1.2 / 3.1.3 | 8.18.4 – 8.19.6 (3.1.2 is the lowest SG with any 8.19 build) |
| 4.0.0 | 8.19.6 – 8.19.7, 9.1.x |
| 4.1.2 | 8.19.16 – 8.19.19, 9.4.0 – 9.4.4 |

No Search Guard build spans the gap. **This is why every proved upgrade path funnels through 8.7.1 with FLX 1.6.0** — it is the only point at which an FLX 1.x cluster can exist on Elasticsearch 8 at all.

`1.6.0-es-7.17.28` also exists, so a customer can swap classic 53.10.0 for FLX 1.6.0 without changing their Elasticsearch version at all.

---

## Timeline

| # | Date | Component | Version | Elasticsearch / Kibana | Event | What it means when upgrading |
|---|---|---|---|---|---|---|
| 1 | 2022-02-22 | SG classic | 53.0.0 | ES 7.17.0 | Classic 53 line opens | The Kibana plugin stays at **53.0.0** for the entire classic 53 line — it is never renumbered, so a classic customer sees ES 7.17.28 / SG 53.10.0 / Kibana plugin 53.0.0 |
| 2 | 2022-08-09 | SG FLX | **1.0.0** | ES 7.10.2 / 7.17.x | **GATE ACTION — Classic → FLX: complete configuration redesign** | `sg_config.yml` is replaced by `sg_authc.yml`, `sg_authz.yml`, `sg_frontend_authc.yml`, `sg_frontend_multi_tenancy.yml`, `sg_auth_token_service.yml`, `sg_license_key.yml`. Convert with `sgctl migrate-config <sg_config.yml> <kibana.yml> -o <dir> --target-platform es711`. Also removed: SG 6 config support, transport-client authentication, privileges on aliases, the Kafka audit sink, user injection, custom auth modules, `multi_rolespan_enabled`, `enable_snapshot_restore_privilege`, and `openssl` settings in `elasticsearch.yml`. `roles_mapping_resolution` **must be removed from `elasticsearch.yml` before starting FLX**. The new DLS/FLS engine ships **off** — opt in with `use_impl: flx` in `sg_authz_dlsfls.yml` |
| 3 | 2022-12-08 | SG FLX | 1.1.0 | ES 7.x | **ACTION** — session signing keys now stored encrypted | Only when upgrading *from 1.0.0*: re-save the key by hand — `sgctl rest get /_searchguard/config/vars/sessions_signing_key`, then `sgctl update-var sessions_signing_key <value> --encrypt`. Role `SGS_KIBANA_USER_NO_DEFAULT_TENANT` renamed to `SGS_KIBANA_USER_NO_GLOBAL_TENANT` |
| 4 | 2023-02-20 | SG FLX | 1.1.1 | ES 7.10.2 | Security fix in the new DLS/FLS engine; last FLX for ES 7.10.2 | Only affects clusters that had opted into `use_impl: flx` |
| 5 | 2023-11-29 | SG classic | **53.8.0** | ES 7.17.x | **STOP** — MT security fix: read-only tenant users could `DELETE` the `.kibana` index | Classic customers using Multi-Tenancy must be on **53.8.0 or later**. The FLX equivalent is 1.4.1 |
| 6 | 2023-11-29 | SG FLX | **1.4.0** | ES 7.17.x / 8.7.1 | **GATE** — MT security floor for FLX; also fixes a Helm/`sgctl` cluster-init hang on ES 8.7.x | MT users must be on **1.4.0 or later**. With 1.6.0, one of only two versions accepted as the source for the 2.0.0 MT migration |
| 7 | 2024-01-15 | SG FLX | **1.5.0** | ES 8.x | **STOP** — *"Kibana Multi-Tenancy is not available in this version of Search Guard. Do NOT upgrade to 1.5.0 if you are using Kibana Multi-Tenancy!"* | MT customers must skip 1.5.0 entirely: 1.4.x straight to 1.6.0 |
| 8 | 2024-02-05 | SG FLX | **1.6.0** | ES 7.17.17 – 7.17.29 / **8.7.1 only** | **GATE — the pivot version.** Last FLX 1.x; MT restored. One breaking change: `missing_permissions` is no longer included in error responses by default | **This is why every proved path goes through 8.7.1.** `8.7.1` is the only ES 8 build of 1.6.0 (and of 1.4.0) — there is no FLX 1.x on any other ES 8 minor. With 1.4.0, the only accepted source for the 2.0.0 MT migration. `1.6.0-es-7.17.28` exists, so classic can be swapped for FLX without touching Elasticsearch. Also fixes a node-startup failure when `config/` contains files larger than 2 GB, and tightens validation of tenants referenced in roles |
| 9 | 2024-05-15 | SG FLX | **2.0.0** | ES 8.8.x – 8.12.x (builds exist to 8.15.2) | **GATE ACTION STOP — Multi-Tenancy completely reimplemented; backwards incompatible** | Per-tenant indices are gone. Saved-object IDs are now suffixed with the tenant ID and carry an `sg_tenant` attribute. **Private tenants are removed and their data is NOT migrated** — export it through the Kibana Saved Objects API first or lose it. MT configuration moves out of `kibana.yml` into `sg_frontend_multi_tenancy.yml`. Source must be **SG 1.4.0 or 1.6.0 on ES 8.7.1**. With Kibana stopped, run **`sgctl special start-mt-data-migration-from-8.7`** and poll with `get-mt-data-migration-state-from-8.7`. **Non-MT clusters are affected too:** Kibana users must be remapped to the new role **`SGS_KIBANA_USER_NO_MT`** or they cannot log in at all. Enabling MT on 2.0.0+ is effectively one-way |
| 10 | 2024-11-13 | SG FLX | **3.0.0** | ES 8.x | **GATE ACTION — legacy DLS/FLS implementation removed** | **Set `use_impl: flx` in `sg_authz_dlsfls.yml` BEFORE upgrading.** Otherwise, per the changelog, *"DLS/FLS/FM can become inoperable in mixed clusters and can potentially expose information to unauthorized users."* Field-masking settings move from `elasticsearch.yml` into `sg_authz_dlsfls.yml`: `searchguard.compliance.mask_prefix` becomes `field_anonymization.prefix`, and `searchguard.compliance.salt` becomes `field_anonymization.personalization` (to keep blake2b hashes stable) or `field_anonymization.salt` (if hash stability does not matter). Also: `exclude_index_permission` removed, and **do not add, change or delete auth tokens while the cluster is mixed 2.x/3.0** |
| 11 | 2024-12-05 | SG FLX | 3.0.2 | ES 8.x | **ACTION** — "Multi-tenancy in data migration" fixed | If you are running the MT data migration, do it on **3.0.2 or later**, or on 2.0.x per the guide. The migration was broken in 3.0.0 and 3.0.1 |
| 12 | 2025-03-18 | SG classic | **53.10.0** | ES 7.17.28, Kibana plugin 53.0.0 | **GATE — final Search Guard classic release; end of the classic line** | The customer's starting point. Nothing after this exists for classic; every path forward goes through FLX. Note there is no changelog page for 53.10.0 in the documentation |
| 13 | 2025-08-12 | SG FLX | **3.1.2** | ES 8.18.4 – 8.19.6 | **GATE** — minimum Search Guard version for the ES 8 → 9 upgrade; FLS and field-masking security fixes | *"FLX 3.1.1 and earlier are still vulnerable."* FLS exclusions on object-valued fields did not restrict queries against member fields, and field masking on IP fields remained searchable |
| 14 | 2025-11-03 | SG FLX | **3.1.3** | ES 8.19.6 / 9.0.x | **GATE — the last Search Guard version able to read classic configuration** | The 3.1.3 plugin POM still depends on `search-guard-flx-security-legacy`; no 4.x POM does, and no 4.x build of that module exists. **FLX 1.0.0 – 3.1.3 is the entire window in which a cluster can boot with classic config still in the index.** Also: security fix — DLS was not applied during Signals watch execution. First SG line for Elasticsearch 9 |
| 15 | 2025-11-04 | SG FLX | **4.0.0** | ES 8.19.6 – 8.19.7 / 9.1.x | **GATE ACTION STOP — legacy `sg_config.yml` support removed; the classic bridge closes** | *"Support for configuration stored in `sg_config.yml` … has been removed. … This needs to be completed before you update to FLX 4.0.0 or newer. All APIs dedicated to modifying the `sg_config` version type have been removed."* **Consequence: you can never go from classic straight to 4.x — the config migration must be completed on some version between 1.0.0 and 3.1.3 first.** Also breaking: **Bouncy Castle removed** (obsolete ciphers and private-key formats may stop working across node TLS, LDAP, Kerberos, JWT, OIDC and SAML), **TLS on the REST layer is on by default**, **custom action groups must declare a `type` attribute** or validation fails, TLS 1.0 and 1.1 dropped, and audit-log request-body handling changed. LDAP now defaults to LDAPS when no explicit TLS configuration is given — previously it used plain `ldap://` |
| 16 | 2025-11-25 | SG FLX | 4.0.1 | ES 8.19.7+ / 9.1.x – 9.2.x | Security: data-stream documents readable without the necessary privileges (affects 3.1.0 – 4.0.0) | Do not linger on 3.1.x or 4.0.0 |
| 17 | 2026-03-25 | SG FLX | 4.1.0 | ES 8.19.13+ / 9.3.x | **ACTION** — security: **audit logs could contain user credentials in every version from 1.0.0 to 4.0.1** | If you cannot upgrade immediately, mitigate with `searchguard.audit.log_request_body: false`, or `searchguard.audit.ignore_request_bodies: ["*/_searchguard/auth/session*"]`. Also fixes an open redirect in the Kibana plugin and insufficiently restricted data-stream management operations. Adds the `SGS_FAILURE_STORE_ACCESS` privilege (ES 9.3.0+), which must be granted explicitly — `SGS_READ` and `SGS_CRUD` are not sufficient |
| 18 | 2026-06-16 | SG Kibana | **4.1.1** | Kibana 9.4.0+ | **STOP** — known issue: requests with an `Authorization: Basic` header fail with HTTP 500, **preventing Kibana from loading** | Affects Kibana 9.4.0 and later; bearer-token authentication is unaffected. Expected to be fixed in a Kibana release, most likely 9.4.3. Separately, Entity Store v2 became opt-out in Kibana 9.4 and logs errors continuously — set `uiSettings.overrides."securitySolution:entityStoreEnableV2": false` in `kibana.yml` **before** first start |
| 19 | 2026-06-25 | SG FLX | **4.1.2** | ES 8.19.16 – 8.19.19 / 9.4.0 – 9.4.4 | **GATE — current release; the target of every supported path** | Fixes a multi-node authentication failure: where auth domains mapped HTTP request headers into user attributes (`attrs.from: $.request.headers[...]`), the user context could not be serialised between nodes and requests failed with `NotSerializableException`. Single-node setups were unaffected |

### Helm chart lane

| # | Date | Chart tag | Ships | Event | What it means when upgrading |
|---|---|---|---|---|---|
| H1 | 2024-01-06 | `2.6.0` | ES 8.7.1 / SG 1.4.0 | First chart on the 2.0.0-migration baseline | Charts `2.6.0` – `2.11.0` are the ones that satisfy the SG 2.0.0 prerequisite |
| H2 | 2024-03-11 | `2.11.0` | ES 8.7.1 / SG 1.6.0 | Last chart of the old numbering scheme | |
| H3 | 2024-07-30 | **`2.0.0-flx`** | ES 8.12.2 / SG 2.0.0 | **HELM STOP — versioning scheme reset; chart numbers go BACKWARDS** | From here the chart version tracks the Search Guard plugin version with a `-flx` suffix. **`2.11.0` → `2.0.0-flx` is a forward upgrade.** `helm search repo --versions` and any semver comparison will order these wrong. The `common.frontend_multi_tenancy` schema is replaced. Follow `docs/sg-2x-upgrade.md` in the chart repo |
| H4 | 2025-03-13 | `3.0.3-flx` | ES 8.17.0 / SG 3.0.3 | `docs/sg-200-upgrade.md` renamed to `docs/sg-2x-upgrade.md`; ingress and Signals nodes added | The link printed in the Search Guard documentation points at the renamed file |
| H5 | 2025-07-18 | `3.1.1-flx` | **ES 9.0.1** / SG 3.1.1 | **HELM STOP — an Elasticsearch major upgrade hidden behind a chart patch bump** | Chart `3.1.0-flx` ships ES 8.18.3; chart `3.1.1-flx` ships ES 9.0.1. Do not treat this as a patch release |
| H6 | 2025-11-27 | **`4.0.0-flx`** | ES 9.1.7 / SG 4.0.0 | **HELM ACTION — all four container images renamed and re-published** | `sg-elasticsearch-h4` → `search-guard-flx-elasticsearch`, `sg-kibana-h4` → `search-guard-flx-kibana`, `sg-sgctl-h4` → `search-guard-flx-sgctl`, `sg-kubectl-h4` → `search-guard-flx-cluster-config`. The values key **`common.images.kubectl_base_image` becomes `common.images.cluster_config_base_image`**. Tag format is now `sgversion-es-esversion` (e.g. `4.0.0-es-9.1.6`) and the **`-flx` suffix is gone from `common.sgversion`** — carrying an old `values.yaml` forward gives `ImagePullBackOff`. The Kubernetes floor rises to **1.32** |
| H7 | 2026-06-29 | `4.1.2-flx` | ES 9.4.2 / SG 4.1.2 | Current chart | Chart version does not always equal SG version: charts `3.1.2`/`3.1.3`/`3.1.4-flx` all ship SG 3.1.1, and chart `4.0.2-flx` ships SG 4.0.1 |

Two standing Helm notes, from the chart `README.md`: use `helm upgrade --set common.es_upgrade_order=true --set common.disable_sharding=true --timeout 1h` for any ES or SG version change, but do **not** set `es_upgrade_order=true` when `master.replicas=1` — it deadlocks.

### Stack-level gates

Not Search Guard events, but they constrain the path.

| Gate | Constraint | Documented in |
|---|---|---|
| ES 7.17 → 8.x | Requires **ES 7.17.x or later and SG FLX 1.0.0 or later**. *"Upgrading from Search Guard classic (i.e., Search Guard versions 53 and before) is not supported."* | [sg-upgrade-7-8](https://docs.search-guard.com/latest/sg-upgrade-7-8) |
| ES / Kibana 8.8.0 | *"Upgrading Elasticsearch and Kibana to 8.8.0 implies also upgrading Search Guard FLX plugin to at least version 2.0.0"* | [upgrading](https://docs.search-guard.com/latest/upgrading) |
| Kibana 8.8.0+ | Adds `.kibana_analytics`, `.kibana_ingest`, `.kibana_security_solution`, `.kibana_alerting_cases` — widen the backup scope | [sg-200-upgrade](https://docs.search-guard.com/latest/sg-200-upgrade) |
| ES 8.19 → 9.x | Requires **ES 8.19.x or later and SG FLX 3.1.2 or later**. ES 8.19 is the last 8.x minor, so it is a mandatory waypoint | [sg-upgrade-8-9](https://docs.search-guard.com/latest/sg-upgrade-8-9) |
| Mixed clusters | Supported for 7.17 ↔ 8.x and 8.19 ↔ 9.x, **with FLX on both sides**, and only for the duration of the upgrade | sg-upgrade-7-8, sg-upgrade-8-9 |

---

## Verdict on the three proposed upgrade paths

### Option 1 — supported, most conservative

```
7.17.28-53.10.0 -> 7.17.28-1.6.0 -> 8.7.1-1.6.0 -> 8.19.19-4.1.2 -> 9.4.4-4.1.2
```

Consistent with every documented gate. The classic → FLX config migration happens on ES 7.17.28 exactly as the [production migration guide](https://docs.search-guard.com/latest/sg-classic-config-migration-prod) describes it — same Elasticsearch version, rolling, minimal outage — and can be verified before the stack moves at all. The MT data migration happens on the `8.7.1-1.6.0 → 8.19.19-4.1.2` hop.

### Option 2 — supported in practice, one documented deviation

```
7.17.28-53.10.0 -> 8.7.1-1.6.0 -> 8.19.19-4.1.2 -> 9.4.4-4.1.2
```

Combines the classic → FLX config migration with the Elasticsearch 7 → 8 major in a single hop. On paper this deviates: `sg-upgrade-7-8` states the prerequisite as "Search Guard FLX 1.0.0" and says classic "is not supported". In practice it works because 1.6.0 still carries the legacy modules (Constraint A) — that is the safety valve — and support has proved it.

Choosing between Options 1 and 2 is the customer's call: separate the Search Guard migration from the stack upgrade and test in between (Option 1), or do both at once (Option 2).

### Option 3 — NOT supported: a big-bang migration with a total-outage window

```
7.17.28-53.10.0 -> 8.19.19-4.1.2 -> 9.4.4-4.1.2
```

**The premise behind Option 3 is wrong.** The premise is that the 1.6.0 stop exists only for the MT migration, so a customer who never used Multi-Tenancy can skip it. But the 1.6.0 stop does **two** jobs, and only one of them is MT:

1. It is where the MT data migration runs — *skippable* if MT was never used.
2. It is the **legacy-config bridge** (Constraint A) — **not skippable, ever, by anyone**.

**What actually happens if you try it.** A 4.1.2 node against a classic config index does not crash and does not report a parse error. `ConfigurationLoader` builds its request from `CType.all()`, and `CType.CONFIG` no longer exists, so the legacy document is simply never fetched. The mandatory config types — `internalusers`, `actiongroups`, `roles`, `rolesmapping`, `tenants` — all exist in a classic index, so the node logs `initialized`. But `authc` does not exist, so `AuthenticatingRestFilter` leaves `authenticationProcessor` null and every request gets:

```
HTTP 503 — Search Guard not initialized (SG11)
```

**There is a recovery window, and it is admin-certificate-only.** Immediately above that check, `AuthenticatingRestFilter` short-circuits for admin DNs — the source comment reads *"Admin Cert authentication works also without a valid configuration"*. So `sgctl` connected with an admin TLS client certificate can still reach the config APIs while the cluster is SG11-locked, and `update-config` will land. `sgctl migrate-config` can also be run entirely offline beforehand: at tag `sgctl-4.1.2` it is `MigrateConfig implements Callable<Integer>` — not a `ConnectingCommand`, no endpoint options, no REST client — it only reads local `sg_config.yml` and `kibana.yml` and writes files to `-o`.

So Option 3 is not physically impossible. It is a **big-bang migration**, and that is why it should not be offered:

1. **No rolling upgrade is possible.** Mixed 7.17 ↔ 8.x is supported only with FLX on both sides, and 4.1.2 cannot read the configuration the classic nodes are running from. It has to be a full cluster restart.
2. **Total outage between restart and bootstrap.** All normal traffic — Kibana, applications, password authentication — is SG11-locked from the moment the first 4.1.2 node comes up until the admin-cert `sgctl update-config` succeeds. If that upload is rejected for any reason, the only way back is restore-from-backup: Elasticsearch cannot be downgraded.
3. **No way to test first.** In Options 1 and 2 the migrated configuration is validated against a running FLX cluster on a known-good version before the stack moves. Here it is validated for the first time during the outage.
4. **Two silent losses to get right blind.** In classic the license key lived inside `sg_config.dynamic` and the MT settings in `kibana.yml`. At 4.x `LicenseRepository` has no legacy fallback, so `sg_license_key.yml` and `sg_frontend_multi_tenancy.yml` must both be uploaded in that same window or the cluster comes back unlicensed.
5. **The 3.0.0 and 4.0.0 gates land under pressure.** `sg_authz_dlsfls.yml` with `use_impl: flx`, and a `type` attribute on every custom action group, *can* be authored offline into the migrated files — but they are unverified hand-edits made during an outage. Bouncy Castle removal and the TLS-on-REST default flip surface only after the point of no return, and classic-era clusters are exactly the ones carrying old key formats and weak ciphers.

**Recommendation: do not offer Option 3.** If a customer insists, it requires an offline-prepared config set, a tested admin certificate, an accepted full-outage window, and a backup that has been proved restorable.

### Recommended minimal path for a customer who never used Multi-Tenancy

**Option 2, keeping the 1.6.0 stop and simply not running the MT command.**

```
7.17.28-53.10.0 -> 8.7.1-1.6.0 -> 8.19.19-4.1.2 -> 9.4.4-4.1.2
```

Skipping `sgctl special start-mt-data-migration-from-8.7` is free for a never-MT customer. Skipping the **8.7.1-1.6.0 stop itself** is not. Every hop here is one support already calls proved.

Whichever variant is chosen, do all of the following **while still on 1.6.0**, before the hop to 4.1.2:

1. **Set `use_impl: flx` in `sg_authz_dlsfls.yml`.** If DLS, FLS or field masking is used, also transpose `searchguard.compliance.mask_prefix` and the salt settings to `field_anonymization.*` by hand — `sgctl migrate-config` does **not** generate this file. (FLX 3.0.0 gate; safe to set even if unused.)
2. **Add a `type` attribute to every custom action group.** (FLX 4.0.0 gate. The attribute has existed since FLX 1.0.0, so 1.6.0 accepts it.)
3. **Remap Kibana users to `SGS_KIBANA_USER_NO_MT`.** This one bites non-MT customers specifically and is easy to miss — from 2.0.0 onward, users left on `SGS_KIBANA_USER` cannot log into Kibana at all.
4. **Do not create, update or delete auth tokens during the mixed window.** (FLX 3.0.0 restriction.)
5. **Test TLS material and JWT / OIDC / SAML / LDAP crypto** against the Bouncy Castle removal, and set `searchguard.ssl.http.enabled` explicitly rather than relying on the default.

No stop at 3.1.2 is required: the "FLX 3.1.2 minimum" in `sg-upgrade-8-9` is the floor for the Search Guard version running on the ES 8.19 nodes *entering* the 8 → 9 hop, and 4.1.2 satisfies it.

The tooling for the MT hop is confirmed present in the current sgctl — `sgctl-4.1.2.jar` contains both `StartMultiTenancyDataMigration` and `GetMultiTenancyDataMigrationState` under `commands/special/multitenancy/datamigration880/`.

### A fourth variant worth putting to the team

```
7.17.28-53.10.0 -> 7.17.28-1.6.0 -> 8.19.6-3.1.3 -> 8.19.19-4.1.2 -> 9.4.4-4.1.2
```

`sg-flx-3.1.3-es-8.19.6` is the **last release that still carries the legacy modules and the first that runs on ES 8.19**. For a non-MT customer that makes it an attractive landing point: the classic → FLX config migration is done on 1.6.0 at the customer's existing ES 7.17.28 (a drop-in plugin swap, no Elasticsearch change, fully testable), and the ES 7 → 8 crossing then happens FLX-to-FLX with the legacy safety net still present on the destination side.

The cost is one extra hop versus the recommended path, and the `7.17.28-1.6.0 → 8.19.6-3.1.3` hop is not on support's proved list. Listed here — not recommended over Option 2 without confirmation — because it is the only variant that keeps the legacy bridge available on both sides of the Elasticsearch major.

---

## Open questions for the Search Guard team

Resolved by this research, no longer open: `migrate-config` is still present in sgctl 4.1.2 and is local-files-only; the last legacy-capable release is FLX 3.1.3; a 4.x node over a classic config index initialises but SG11-locks, with an admin-cert bypass.

Still open:

1. Is the `7.17.28-1.6.0 → 8.19.19-4.1.2` variant (Option 1 without the 8.7.1 stop) proved? It crosses the Elasticsearch major and a 1.6.0 → 4.1.2 Search Guard skew simultaneously. Plausible, but neither documented nor on the proved list.
2. Same question for the `7.17.28-1.6.0 → 8.19.6-3.1.3` variant above.
3. Is `sgctl migrate-config` output directly valid for 4.1.2 — specifically, does it emit the `type` attribute on action groups that 4.0.0 made mandatory, or must that be added by hand?
4. Should the timeline publish the bound *"FLX 3.1.3 is the last version able to read classic configuration"*? It is certain from the source and the artifacts and is genuinely useful, but it is documented nowhere today.
5. `sg-200-upgrade` says SG 2.0.0 requires ES 8.8.x – 8.12.x, but builds exist up to `2.0.0-es-8.15.2`. Which is right?

## Documentation defects noticed along the way

Not part of this timeline; raised separately.

- `sg_upgrade_8_9.md` is a near-verbatim copy of `sg_upgrade_7_8.md`: its breaking-changes section still says "Elasticsearch 8", the mixed-mode section still says "7.17.x and 8.x nodes", and the classic warning still says "Search Guard 7 classic".
- The `sgversions` matrix in `_config.yml` no longer contains any FLX 1.x-on-ES-8.7.x, 2.x or 3.0.x row — so the exact stepping stones that `sg-200-upgrade` mandates are not downloadable from the page it links to. Only the archive has them.
- The `search_guard_upgrades.md` category page omits `sg-upgrade-6-7` and `sg-upgrade-8-9`, unlike the side navigation.
- `upgrading.md` ends with a stale ES-8.8.0-specific section that duplicates its own top banner.
- Helm-chart column oddities in the matrix: ES 9.2.6 maps to SG 4.0.1 but chart `4.1.0-flx`; ES 8.19.17 maps to SG 4.1.2 but chart `4.1.0-flx`. Likely data errors.
- Typos in `sg_200_upgrade.md`: "aw well", "Elasticseare", "should be above a few minutes".
- No changelog page exists for classic 53.10.0, the final classic release.