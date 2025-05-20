resource "null_resource" "jenkins_deployer" {
  provisioner "local-exec" {
    command = <<EOT
        kubectl create namespace jenkins --kubeconfig ./kubeconfig/kubeconfig
        kubectl apply -f ../06_jenkins/deployment.yml --kubeconfig ./kubeconfig/kubeconfig
    EOT
  }
  depends_on = [ null_resource.atlantis_deployer ]
  
}