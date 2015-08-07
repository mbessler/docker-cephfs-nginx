#!/bin/sh -e
modprobe ceph
cat /etc/ceph/ceph.client.admin.keyring | grep 'key =' | sed 's/.*key = //' > /etc/ceph/admin.secret
mount -t ceph -o name=admin,secretfile=/etc/ceph/admin.secret ${CEPHFS} /ceph
#chown www-data /ceph
/usr/sbin/nginx -g 'daemon off;'
