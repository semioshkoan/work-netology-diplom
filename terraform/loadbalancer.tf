resource "yandex_alb_target_group" "web_target_group" {
  name = "web-target-group"
  target {
    subnet_id  = yandex_vpc_subnet.private_a.id
    ip_address = yandex_compute_instance.web[0].network_interface[0].ip_address
  }
  target {
    subnet_id  = yandex_vpc_subnet.private_b.id
    ip_address = yandex_compute_instance.web[1].network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "web_backend_group" {
  name = "web-backend-group"
  http_backend {
    name             = "web-backend"
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_target_group.id]
    healthcheck {
      timeout           = "1s"
      interval          = "1s"
      healthy_threshold = 2
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "web_router" {
  name = "web-router"
}

resource "yandex_alb_virtual_host" "web_virtual_host" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web_router.id
  route {
    name = "web-route"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend_group.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web_balancer" {
  name       = "web-balancer"
  network_id = yandex_vpc_network.diplom_network.id
  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public.id
    }
  }
  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
}