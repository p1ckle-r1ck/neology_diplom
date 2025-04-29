resource "time_sleep" "wait_30_seconds" {
  depends_on = [local_file.hosts_templatefile]
  create_duration = "60s"
}

resource "null_resource" "ansible_ssl_keys" {
  depends_on = [ time_sleep.wait_30_seconds ]
   provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./kubespray_inv/inventory/sample/inventory.ini ./ansible/ssl_key_san.yml -v
     EOT 
      
   }
}

resource "null_resource" "kubespray" {
  depends_on = [time_sleep.wait_30_seconds]
  # triggers = {
  # manual_trigger = var.force_redeploy
  # }
  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_ROLES_PATH=./kubespray/roles && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i kubespray_inv/inventory/sample/inventory.ini --private-key=~/.ssh/netology ./kubespray/cluster.yml --become --skip-tags check
    EOT
  }
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = <<EOT
    ANSIBLE_FORCE_COLOR=1 ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i kubespray_inv/inventory/sample/inventory.ini ./ansible/kubeconfig.yml --private-key=~/.ssh/netology -b -v
    EOT  
  }

  depends_on = [
    null_resource.kubespray
  ]
}