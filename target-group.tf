resource "yandex_alb_target_group" "tg" {
  name      = "my-target-group"
  timeouts {
    create = "15m"
    delete = "30m"
  }
  target {
    subnet_id = yandex_vpc_subnet.subnet-zone-a.id
    ip_address   = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-zone-c.id
    ip_address   = yandex_compute_instance.web2.network_interface.0.ip_address
  }

}
