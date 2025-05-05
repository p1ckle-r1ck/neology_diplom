resource "time_sleep" "sleep_before_monitoring" {
  depends_on = [null_resource.kubeconfig]
  create_duration = "60s"
  
}
resource "null_resource" "monitoring_deployer" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl apply --server-side -f ../03_monitoring/kube-prometheus/manifests/setup --kubeconfig ./kubeconfig/kubeconfig
      kubectl --kubeconfig ./kubeconfig/kubeconfig wait \
	  --for condition=Established \
	  --all CustomResourceDefinition \
	  --namespace=monitoring
      kubectl apply -f ../03_monitoring/kube-prometheus/manifests/ --kubeconfig ./kubeconfig/kubeconfig
    EOT
  }
  depends_on = [ time_sleep.sleep_before_monitoring ]
}

resource "null_resource" "grafana_nodeport" {
    provisioner "local-exec" {
        command = <<EOT
        kubectl apply -f ../03_monitoring/grafana/grafana_nodeport.yml --kubeconfig ./kubeconfig/kubeconfig
        EOT
    }
    depends_on = [ null_resource.monitoring_deployer ]
}

resource "null_resource" "network_policy" {
    provisioner "local-exec" {
        command = <<EOT
        kubectl apply -f ../03_monitoring/grafana/network-policy.yml --kubeconfig ./kubeconfig/kubeconfig
        EOT
    }
    depends_on = [ null_resource.grafana_nodeport ]
}