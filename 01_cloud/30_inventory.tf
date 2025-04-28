resource "local_file" "hosts_templatefile" {
  depends_on = [ yandex_compute_instance.worker-node-2 ]
  content = templatefile("${path.module}/template/inventory.tpl",
    {
      master   = yandex_compute_instance.master_node,
      worker-1 = yandex_compute_instance.worker-node-1,
      worker-2 = yandex_compute_instance.worker-node-2,
  })

  filename = "${abspath(path.module)}/kubespray_inv/inventory/sample/inventory.ini"
}
