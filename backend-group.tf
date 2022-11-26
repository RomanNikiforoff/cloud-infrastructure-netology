resource "yandex_alb_backend_group" "backend-g" {
  name                     = "my-backend-group"

  http_backend {
    name                   = "http-back"
    weight                 = 1
    port                   = 80
    target_group_ids       = ["yandex_lb_target_group.tg.id"]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }
}
