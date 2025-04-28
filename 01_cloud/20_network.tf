resource "yandex_vpc_network" "vpc" {
  name = "private-vpc"

}
resource "yandex_vpc_subnet" "a_subnet" {
  name           = "a-subnet"
  v4_cidr_blocks = ["10.1.0.0/24"]
  network_id     = yandex_vpc_network.vpc.id
  zone           = var.network-zones.a
}

resource "yandex_vpc_subnet" "b_subnet" {
  name           = "b-subnet"
  v4_cidr_blocks = ["10.2.0.0/24"]
  network_id     = yandex_vpc_network.vpc.id
  zone           = var.network-zones.b

}

resource "yandex_vpc_subnet" "d_subnet" {
  name           = "d-subnet"
  v4_cidr_blocks = ["10.3.0.0/24"]
  network_id     = yandex_vpc_network.vpc.id
  zone           = var.network-zones.d

}