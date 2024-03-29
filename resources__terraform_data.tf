
resource terraform_data setup-base {
  triggers_replace = openstack_compute_volume_attach_v2.persistent-volumes[*]

  depends_on = [
    openstack_compute_volume_attach_v2.persistent-volumes
  ]

  connection {
    type  = "ssh"
    agent = true
    host  = data.openstack_networking_floatingip_v2.instance.address
    user  = var.REMOTE_USER
  }
  provisioner file {
    source = "remote/scripts/base/setup.bash"
    destination = "/tmp/setup-base.bash"
  }

  provisioner remote-exec {
    inline = [
      "bash /tmp/setup-base.bash"
    ]
  }
} 

resource terraform_data setup-persistent-volume {
  triggers_replace = openstack_compute_volume_attach_v2.persistent-volumes[*]

  depends_on = [
    terraform_data.setup-base
  ]

  for_each = data.openstack_blockstorage_volume_v3.persistent-volumes

  connection {
    type  = "ssh"
    agent = true
    host  = data.openstack_networking_floatingip_v2.instance.address
    user  = var.REMOTE_USER
  }

  provisioner file {
    source = "remote/scripts/persistent-volume/setup.bash"
    destination = "/tmp/setup-persistent-volume.bash"
  }

  provisioner remote-exec {
    inline = [
      "bash /tmp/setup-persistent-volume.bash '${each.value.id}' '${each.key}'"
    ]
  }
}

resource terraform_data exec-provisioner-tasks {
  triggers_replace = openstack_compute_volume_attach_v2.persistent-volumes[*]

  depends_on = [
    terraform_data.setup-persistent-volume
  ]

  provisioner local-exec {
    command = "bash local/scripts/exec_provisioner_tasks.bash"
  }
}
