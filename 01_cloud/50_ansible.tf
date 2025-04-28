resource "time_sleep" "wait_30_seconds" {
  depends_on = [local_file.hosts_templatefile]
  create_duration = "60s"
}
resource "null_resource" "ansible_runner" {
  depends_on = [time_sleep.wait_30_seconds]
  triggers = {
  manual_trigger = var.force_redeploy
  }
  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_ROLES_PATH=./kubespray/roles && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i 32_hosts.ini --private-key=~/.ssh/netology ./kubespray/cluster.yml --become --skip-tags check
    EOT
  }
}
