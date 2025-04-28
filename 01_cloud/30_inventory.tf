resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      master   = yandex_compute_instance.master_node,
      worker-1 = yandex_compute_instance.worker-node-1,
      worker-2 = yandex_compute_instance.worker-node-2,
  })

  filename = "${abspath(path.module)}/32_hosts.ini"
}