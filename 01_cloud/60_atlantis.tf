resource "null_resource" "atlantis_deployer" {
  provisioner "local-exec" {
    command = <<EOT
        kubectl create secret generic atlantis-vcs --from-file=../05_atlantis/token --from-file=../05_atlantis/webhook-secret --kubeconfig ./kubeconfig/kubeconfig
        kubectl apply -f ../05_atlantis/deployment.yml --kubeconfig ./kubeconfig/kubeconfig
    EOT
  }
  depends_on = [ null_resource.network_policy ]
  
}
