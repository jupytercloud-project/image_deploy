

resource "openstack_networking_subnet_route_v2" "subnet_route_1" {
  subnet_id        = openstack_networking_subnet_v2.intra_subnet.id
  destination_cidr = "157.136.248.0/21"
  next_hop         = "157.136.248.1"
}

resource openstack_networking_port_v2 instance {
  name           = local.INSTANCE_FQDN
  network_id     = openstack_networking_network_v2.intra_network.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.intra_subnet.id
  }
}  
