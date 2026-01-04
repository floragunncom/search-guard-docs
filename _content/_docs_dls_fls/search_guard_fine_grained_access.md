---
title: Fine-Grained Access Control
html_title: Fine-Grained Access Control
permalink: search-guard-fine-grained-access
layout: docs
section: security
description: Document and field-level security for granular data access control
---

<!--- Copyright 2025 floragunn GmbH -->

# Fine-Grained Access Control

Fine-grained access control lets you restrict access to specific documents and fields within Elasticsearch indices. This provides data security at a granular level beyond basic index permissions.

## What is Fine-Grained Access Control?

While standard authorization controls access at the index level, fine-grained access control provides two additional security layers:

- **Document-Level Security (DLS)** - Control which documents users can see within an index
- **Field-Level Security (FLS)** - Control which fields users can access within documents

These features are often used together to implement complex data access policies based on user attributes, document content, or organizational requirements.

## Use Cases

### Document-Level Security

- **Multi-tenant applications** - Each tenant sees only their own data
- **Department isolation** - Users see only documents for their department
- **Regional restrictions** - Limit data access by geographic region
- **Status-based access** - Show only documents with specific status values
- **Time-based access** - Restrict access to recent or historical data

### Field-Level Security

- **PII protection** - Hide sensitive fields like SSN, credit card numbers
- **GDPR compliance** - Restrict access to personal data fields
- **Role-based views** - Different users see different field sets
- **Anonymization** - Hash or mask sensitive field values
- **Confidential data** - Hide salary, performance review fields

## Document-Level Security

### Basic DLS

Restrict documents using Elasticsearch query syntax:

```yaml
sg_department_sales:
  index_permissions:
    - index_patterns:
        - 'company-data'
      allowed_actions:
        - SGS_READ
      dls: '{"term": {"department": "sales"}}'
```

Users with this role only see documents where `department` equals `sales`.

### Attribute-Based DLS

Use user attributes in DLS queries:

```yaml
sg_user_dept:
  index_permissions:
    - index_patterns:
        - 'company-data'
      allowed_actions:
        - SGS_READ
      dls: '{"term": {"department": "${user.department}"}}'
```

The `${user.department}` placeholder is replaced with the actual user's department.

**Learn more:** [Document-Level Security](document-level-security)

## Field-Level Security

### Basic FLS

Restrict which fields users can access:

```yaml
sg_limited_view:
  index_permissions:
    - index_patterns:
        - 'employee-data'
      allowed_actions:
        - SGS_READ
      fls:
        - 'name'
        - 'email'
        - 'department'
```

Users see only `name`, `email`, and `department` fields. All other fields are hidden.

### Field Anonymization

Hash sensitive field values:

```yaml
sg_anonymized:
  index_permissions:
    - index_patterns:
        - 'employee-data'
      allowed_actions:
        - SGS_READ
      masked_fields:
        - 'ssn'
        - 'salary'
```

The `ssn` and `salary` fields are returned as hashed values instead of actual data.

**Learn more:** [Field-Level Security](field-level-security)

## Topics in This Section

### Document-Level Security

- **[Basics](document-level-security)** - DLS fundamentals and configuration
- **[Attribute-Based DLS](attribute-based-dls)** - Use user attributes in DLS queries
- **[Advanced Topics](advanced-dls)** - Complex queries, performance tuning

### Field-Level Security

- **[Basics](field-level-security)** - FLS fundamentals and configuration
- **[Field Anonymization](field-anonymization)** - Hash or mask sensitive fields

## Combining DLS and FLS

You can use both DLS and FLS together for maximum control:

```yaml
sg_restricted_access:
  index_permissions:
    - index_patterns:
        - 'sensitive-data'
      allowed_actions:
        - SGS_READ
      dls: '{"term": {"department": "${user.department}"}}'
      fls:
        - 'id'
        - 'name'
        - 'department'
        - 'status'
      masked_fields:
        - 'ssn'
```

This configuration:
1. Limits documents to user's department (DLS)
2. Shows only specific fields (FLS)
3. Masks the SSN field (anonymization)

## Performance Considerations

Fine-grained access control adds processing overhead:

- **DLS** - Additional query filter applied to every search
- **FLS** - Field filtering happens during document retrieval
- **Anonymization** - Field hashing adds minimal overhead

**Best practices:**
- Use efficient DLS queries (prefer `term` over complex queries)
- Limit FLS to necessary fields only
- Test performance with realistic data volumes
- Consider caching strategies for frequently accessed data

## Security Considerations

- **DLS bypass** - Ensure aggregations don't leak restricted data
- **Query visibility** - Be aware that queries may reveal information about restricted documents
- **Field inference** - Field existence can be inferred from search results
- **Administrative access** - Administrators can see all data regardless of DLS/FLS

## Next Steps

1. **Start with [Document-Level Security](document-level-security)** - Learn DLS fundamentals
2. **Explore [Attribute-Based DLS](attribute-based-dls)** - Use user attributes in queries
3. **Configure [Field-Level Security](field-level-security)** - Hide sensitive fields
4. **Implement [Field Anonymization](field-anonymization)** - Mask sensitive data
