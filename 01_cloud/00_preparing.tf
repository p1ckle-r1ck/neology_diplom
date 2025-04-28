resource "null_resource" "kubespray_install" {
  provisioner "local-exec" {
    command = <<EOT
    if [ ! -d "kubespray" ]; then
        git clone --depth 1 https://github.com/kubernetes-sigs/kubespray.git
        pip install -r requirements.txt
    fi
    EOT
  }
}