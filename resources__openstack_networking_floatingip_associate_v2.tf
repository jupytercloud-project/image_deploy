resource openstack_networking_floatingip_associate_v2 instance {
  floating_ip = data.openstack_networking_floatingip_v2.instance.address
  port_id     = openstack_networking_port_v2.instance.id
}