#!/bin/sh -eux

# Configure AppArmor parser cache settings
mkdir -p /etc/apparmor/earlypolicy/
cat > /etc/apparmor/parser.conf <<'EOF'
write-cache
Optimize=compress-fast
cache-loc /etc/apparmor/earlypolicy/
EOF

exit 0
