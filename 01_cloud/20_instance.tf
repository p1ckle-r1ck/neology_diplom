resource "yandex_compute_instance" "master_node" {
  name = "master"
  resources {
    memory        = var.k8s-instance["master_node"].memory
    cores         = var.k8s-instance["master_node"].cores
    core_fraction = var.k8s-instance["master_node"].core_fraction
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.a_subnet.id
    nat       = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.fedora.id
    }
  }
  metadata = {
    user-data = "${file("users.yml")}"
  }
}

resource "yandex_compute_instance" "worker-node-1" {
  depends_on = [ yandex_compute_instance.master_node ]
  name = "worker1"
  zone = var.network-zones.b
  resources {
    memory        = var.k8s-instance["worker_node"].memory
    cores         = var.k8s-instance["worker_node"].cores
    core_fraction = var.k8s-instance["worker_node"].core_fraction
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.b_subnet.id
    nat       = true

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.fedora.id
    }
  }
  metadata = {
    user-data = "${file("users.yml")}"
  }
}

resource "yandex_compute_instance" "worker-node-2" {
  depends_on = [ yandex_compute_instance.worker-node-1 ]
  name        = "worker2"
  zone        = var.network-zones.d
  platform_id = "standard-v2"
  resources {
    memory        = var.k8s-instance["worker_node"].memory
    cores         = var.k8s-instance["worker_node"].cores
    core_fraction = var.k8s-instance["worker_node"].core_fraction
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.d_subnet.id
    nat       = true

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.fedora.id
    }
  }
  metadata = {
    user-data = "${file("users.yml")}"
  }
}


