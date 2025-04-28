resource "time_sleep" "wait_30_seconds" {
  depends_on = [local_file.hosts_templatefile]

  create_duration = "30s"
}
resource "null_resource" "ansible_runner" {
  depends_on = [time_sleep.wait_30_seconds]

  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_RzOLES_PATH=./ansible/kubespray-master/roles && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini --private-key=~/.ssh/netology ./ansible/kubespray-master/cluster.yml --become
    EOT
  }
}
