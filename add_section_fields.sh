#!/bin/bash

# Script to add section fields to all documentation pages
cd "$(dirname "$0")"

echo "Adding section fields to documentation files..."
echo ""

# Security section collections
for dir in _docs_auth_auth _docs_audit_logging _docs_configuration_changes \
           _docs_dls_fls _docs_installation _docs_introduction _docs_kibana \
           _docs_other_integrations _docs_quickstart _docs_rest_api \
           _docs_roles_permissions _docs_search_guard_versions \
           _docs_systemintegrators _docs_tls _docs_elasticstack \
           troubleshooting _changelogs; do
  if [ -d "_content/$dir" ]; then
    echo "Processing _content/$dir..."
    find "_content/$dir" -name "*.md" -type f -exec sed -i '' \
      '/^layout:/a\
section: security
' {} \;
  fi
done

# Alerting section
if [ -d "_content/_docs_signals" ]; then
  echo "Processing _content/_docs_signals..."
  find _content/_docs_signals -name "*.md" -type f -exec sed -i '' \
    '/^layout:/a\
section: alerting
' {} \;
fi

# Index Management section
if [ -d "_content/_docs_aim" ]; then
  echo "Processing _content/_docs_aim..."
  find _content/_docs_aim -name "*.md" -type f -exec sed -i '' \
    '/^layout:/a\
section: index_management
' {} \;
fi

# Encryption at Rest section
if [ -d "_content/_docs_encryption_at_rest" ]; then
  echo "Processing _content/_docs_encryption_at_rest..."
  find _content/_docs_encryption_at_rest -name "*.md" -type f -exec sed -i '' \
    '/^layout:/a\
section: encryption_at_rest
' {} \;
fi

# Anomaly Detection section
if [ -d "_content/_docs_ad" ]; then
  echo "Processing _content/_docs_ad..."
  find _content/_docs_ad -name "*.md" -type f -exec sed -i '' \
    '/^layout:/a\
section: anomaly_detection
' {} \;
fi

echo ""
echo "Bulk updates complete!"
echo ""
echo "Note: You still need to manually update:"
echo "  - Landing pages in _content/_docs_category_pages/"
echo "  - Ensure index.md does NOT have a section field"
