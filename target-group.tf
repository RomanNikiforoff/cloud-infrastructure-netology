resource "yandex_alb_target_group" "tg" {
  name      = "my-target-group"

  target {
    subnet_id = "e9bopjo60lbholcap1u2"
    ip_address   = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id = "b0c82gt6k72695pofe0m"
    ip_address   = yandex_compute_instance.web2.network_interface.0.ip_address
  }

}
