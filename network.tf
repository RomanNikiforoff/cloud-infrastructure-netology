# Network&subnets creating

resource "yandex_vpc_network" "net1" {
  name = "test-net"
}

resource "yandex_vpc_subnet" "subnet-zone-a" {
  name           = "subnet-a"
  v4_cidr_blocks = ["10.10.0.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net1.id
}

resource "yandex_vpc_subnet" "subnet-zone-b" {
  name           = "subnet-b"
  v4_cidr_blocks = ["10.20.0.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net1.id
}

resource "yandex_vpc_subnet" "subnet-zone-c" {
  name           = "subnet-c"
  v4_cidr_blocks = ["10.30.0.0/24"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.net1.id
}
