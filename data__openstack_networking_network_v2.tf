data openstack_networking_network_v2 private {
  name = local.INSTANCE_NETWORK
}


data "openstack_networking_subnet_ids_v2" "intra_subnets" {
  network_id = openstack_networking_network_v2.intra_network.id
}

