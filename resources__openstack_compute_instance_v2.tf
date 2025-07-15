resource openstack_blockstorage_volume_v3 persistent-volumes {
  for_each = local.PERSISTENT_VOLUMES_NAME
  name = each.value
  size = 77
}

resource openstack_networking_floatingip_v2 instance {
  pool = "public-2"
}

resource openstack_compute_instance_v2 instance {
  name            = var.INSTANCE_FQDN
  image_id        = data.openstack_images_image_v2.base_image.id
  flavor_name     = var.FLAVOR_NAME
  key_pair        = var.KEYPAIR_NAME
  security_groups = [data.openstack_networking_secgroup_v2.default.name,
                     data.openstack_networking_secgroup_v2.instance.name]
  network {
    port     = openstack_networking_port_v2.instance.id
  }

  connection {
    type = "ssh"
    agent = true
    host = openstack_networking_floatingip_v2.instance.address
    user = var.REMOTE_USER
  }
  provisioner remote-exec {
    inline = [ "hostname" ]
  }

}

