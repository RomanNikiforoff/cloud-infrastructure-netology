resource "yandex_alb_load_balancer" "alb1" {
  name        = "alb1"
  network_id  = "enpf9jsec2ppbhjaivpm"

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = "e9bopjo60lbholcap1u2"
    }
  }

  listener {
    name = "listener1"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }
}
