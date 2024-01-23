
resource openstack_networking_port_v2 instance {
  name           = local.INSTANCE_FQDN
  network_id     = data.openstack_networking_network_v2.private.id
  admin_state_up = "true"
}  