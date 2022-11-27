resource "yandex_alb_http_router" "tf-router" {
  name   = "my-http-router"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "my-virtual-host"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "http"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-g.id
        timeout          = "3s"
      }
    }
  }
}
