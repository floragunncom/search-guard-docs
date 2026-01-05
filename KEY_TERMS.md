# Search Guard Documentation - Key Terms Reference

This file contains all product and feature-relevant key terms found in the Search Guard documentation. Review this list for spelling consistency and accuracy.

## Product Names

- Search Guard
- Search Guard FLX
- Kibana
- Elasticsearch
- Elastic Stack
- Logstash
- Beats
- Grafana
- Cerebro
- X-Pack

## Core Features

- Signals
- Signals Alerting
- AIM
- Automated Index Management
- Multi-Tenancy
- Kibana Multi-Tenancy
- Document-Level Security
- DLS
- Field-Level Security
- FLS
- Field Masking
- Field Anonymization
- Audit Logging
- Compliance
- TLS Encryption
- Encryption at Rest
- Anomaly Detection
- Role-Based Access Control
- RBAC

## Authentication Methods

- LDAP
- Active Directory
- AD
- JSON Web Tokens
- JWT
- JWKS
- JSON Web Key
- JSON Web Key Set
- Kerberos
- SPNEGO
- SAML
- OpenID Connect
- OIDC
- Proxy Authentication
- Client Certificate Authentication
- TLS Client Certificates
- HTTP Basic Authentication
- Basic Authentication
- Anonymous Authentication
- Internal Users Database
- Search Guard Auth Tokens

## Tools and CLI

- sgctl
- enctl
- TLS Tool
- Offline TLS Tool
- hash.sh
- Configuration GUI
- REST API
- Admin API

## Configuration Files

- sg_authc.yml
- sg_roles.yml
- sg_internal_users.yml
- sg_action_groups.yml
- sg_frontend_authc.yml
- sg_frontend_multi_tenancy.yml
- sg_tenants.yml
- sg_authz.yml
- sg_auth_token_service.yml
- sg_blocks.yml
- sg_authz_dlsfls.yml
- elasticsearch.yml
- kibana.yml

## Action Groups

- SGS_ALL_ACCESS
- SGS_READALL
- SGS_READALL_AND_MONITOR
- SGS_KIBANA_SERVER
- SGS_KIBANA_USER
- SGS_KIBANA_USER_NO_GLOBAL_TENANT
- SGS_KIBANA_USER_NO_MT
- SGS_KIBANA_USER_NO_DEFAULT_TENANT
- SGS_LOGSTASH
- SGS_MANAGE_SNAPSHOTS
- SGS_OWN_INDEX
- SGS_XP_MONITORING
- SGS_XP_ALERTING
- SGS_XP_MACHINE_LEARNING
- SGS_READ
- SGS_WRITE
- SGS_SEARCH
- SGS_DELETE
- SGS_CRUD
- SGS_GET
- SGS_SUGGEST
- SGS_CREATE_INDEX
- SGS_MANAGE_ALIASES
- SGS_INDICES_MONITOR
- SGS_MANAGE
- SGS_INDICES_MANAGE_ILM
- SGS_UNLIMITED
- SGS_CLUSTER_ALL
- SGS_CLUSTER_MONITOR
- SGS_CLUSTER_COMPOSITE_OPS
- SGS_CLUSTER_COMPOSITE_OPS_RO
- SGS_CLUSTER_COMPOSITE
- SGS_CLUSTER_MANAGE_ILM
- SGS_CLUSTER_READ_ILM
- SGS_CLUSTER_MANAGE_INDEX_TEMPLATES
- SGS_CLUSTER_MANAGE_PIPELINES
- SGS_SIGNALS_ALL
- SGS_SIGNALS_WATCH_MANAGE
- SGS_SIGNALS_READ
- SGS_SIGNALS_ACCOUNT_MANAGE
- SGS_KIBANA_ALL_WRITE
- SGS_KIBANA_ALL_READ
- SGS_GLOBAL_TENANT
- SGS_AIM_ALL
- SGS_AIM_POLICY_MANAGE

## Index Names and Patterns

- .searchguard
- searchguard
- .searchguard_*
- .searchguard_resource_owner
- .searchguard_authtokens
- .searchguard-ad-state
- .searchguard-ad-results*
- .searchguard-ad-results-history*
- .searchguard-ad-anomaly-detectors
- .kibana
- .kibana*
- .kibana_*
- .kibana_analytics
- .kibana_ingest
- .kibana_security_solution
- .kibana_alerting_cases
- .kibana-reporting*
- .signals*
- .signals_main_watches
- .signals_watches*
- .signals_watches_state
- .signals_accounts
- .signals_settings
- .signals_log*
- .signals_log
- .aim
- sg_auditlog*

## Signals Components

- Watches
- Watch
- Actions
- Inputs
- Checks
- Conditions
- Triggers
- Throttling
- Severity
- Severity Levels
- Accounts
- Proxies
- Trust Stores
- Truststore
- Keystore
- Transformations
- Calculations
- Chaining Checks
- Security Context
- Operator View
- Status Logging

## Signals Action Types

- Email
- Slack
- PagerDuty
- Jira
- Webhook
- Index Action

## Signals Inputs

- Elasticsearch Input
- HTTP Input
- Static Input
- Search Input

## Signals Severity Levels

- INFO
- WARNING
- ERROR
- FATAL
- CRITICAL
- NONE

## AIM (Automated Index Management) Components

- Policy
- Policy Instance
- Steps
- Conditions
- Actions
- Schedule

## AIM Actions

- Allocation
- Close
- Delete
- Force Merge
- Rollover
- Set Priority
- Set Read-Only
- Set Replica Count
- Snapshot

## AIM Conditions

- Age
- Age Condition
- Doc Count
- Doc Count Condition
- Size
- Size Condition
- Index Count
- Index Count Condition

## Tenants

- Global Tenant
- Private Tenant
- SGS_GLOBAL_TENANT

## Roles and Users

- Admin Certificate
- Admin User
- Backend Roles
- Search Guard Roles
- Kibana Server User
- kibanaserver

## Security Concepts

- Authentication
- Authc
- Authorization
- Authz
- Credentials
- Permissions
- Privileges
- User Mapping
- Role Mapping
- Challenging Authenticator
- Non-Challenging Authenticator
- SSO
- Single Sign-On
- User Information Backend
- Authentication Backend
- Authorization Backend
- Authentication Domain
- Authorization Domain

## TLS/Certificate Concepts

- Transport Layer
- REST Layer
- HTTP Layer
- Root CA
- Certificate Authority
- Certificate Revocation
- CRL
- OCSP
- Hot Reload
- Hostname Verification
- DNS Lookup
- PEM
- PKCS#12
- Certificate Signing Request
- CSR
- Distinguished Name
- DN
- Subject Alternative Name
- SAN

## Compliance Features

- GDPR
- PCI
- PCI DSS
- SOX
- HIPAA
- Audit Trails
- Read History
- Write History
- Configuration Integrity
- Immutable Indices
- Event Routing

## Editions

- Community Edition
- Enterprise Edition
- Compliance Edition

## Advanced Features

- Data Streams
- Aliases
- Index Patterns
- Wildcards
- Regular Expressions
- User Attributes
- Variable Substitution
- Date Math
- Dynamic Roles
- Nested Groups
- Recursive Group Search
- Index Templates
- Component Templates
- Composable Templates

## API and Integration

- Health Check
- Component State
- License Management
- Configuration Variables
- Password Hashing
- Hot Config Reloading
- Snapshot and Restore
- Cross-Cluster Search
- Tribe Nodes

## Anomaly Detection Components

- Detector
- Features
- Historical Analysis
- Real-Time Detection
- Anomaly Grade
- Confidence Score
- Confidence Interval
- Feature Contribution
- Probation Period
- High Cardinality Detection
- Shingle Size
- Window Delay
- Category Field

## Configuration Settings

- index.aim.policy_name
- index.aim.alias_mapping
- searchguard.ssl.transport.*
- searchguard.ssl.http.*
- searchguard.authcz.admin_dn
- searchguard.restapi.roles_enabled
- searchguard.admin_only_indices
- signals.enabled
- node.attr.signals
- searchguard.allow_unsafe_democertificates
- searchguard.allow_default_init_sgindex
- encryption_at_rest_enabled

## Demo and Testing

- Demo Installer
- Demo Users
- Demo Roles
- Demo Certificates
- Sample Data
- Sample Watches

## Encryption at Rest

- Master Key
- Encryption Key
- Decryption
- Ciphertext
- Plaintext
- AES
- AES-256
- Crypto Store
- Encrypted Index
- Encrypted Store
- Key Rotation
- Re-encryption

## Additional Key Terms

- Painless Script
- Mustache Template
- Lucene
- Segments
- Shards
- Replicas
- Principal
- Filter
- Query
- Aggregation
- Bulk Request
- Write Index
- Rollover Alias
- State
- Transition
- Model
- Training
- Threshold
- Time Field
- Source Index
- Result Index
- Custom Result Index
- Job
- Execution
- Runtime Data
- Execution Context
- Watch State
- Watch Log
- Resolve Action
