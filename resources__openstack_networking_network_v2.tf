

resource "openstack_networking_network_v2" "intra_network" {
  name = "jup-ng-staging"
}


resource "openstack_networking_subnet_v2" "intra_subnet" {
  network_id = openstack_networking_network_v2.intra_network.id
  name       = "main"
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.254"
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_networking_router_v2" "jup_ng_router" {
  name = "jup-ng"
  external_network_id = data.openstack_networking_network_v2.private.id
}

resource "openstack_networking_router_interface_v2" "jup_ng_interface" {
  router_id = openstack_networking_router_v2.jup_ng_router.id
  subnet_id = openstack_networking_subnet_v2.intra_subnet.id
}

resource "openstack_networking_router_route_v2" "router_route_1" {
  depends_on       = [openstack_networking_router_interface_v2.jup_ng_interface]
  router_id        = openstack_networking_router_v2.jup_ng_router.id
  destination_cidr = "157.136.248.0/21"
  next_hop         = "157.136.248.1"
}
