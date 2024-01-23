output REMOTE_FQDN {
    value = data.openstack_networking_floatingip_v2.instance.address
}
output REMOTE_USER {
    value = var.REMOTE_USER
}