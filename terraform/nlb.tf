resource "yandex_lb_target_group" "kuber" {
  name = "kuber-claster"
  target {
    subnet_id = yandex_vpc_subnet.neto-subnet[var.instances[0].net].id
    address   = var.instances[0].ip
  }
  target {
    subnet_id = yandex_vpc_subnet.neto-subnet[var.instances[1].net].id
    address   = var.instances[1].ip
  }
  target {
    subnet_id = yandex_vpc_subnet.neto-subnet[var.instances[2].net].id
    address   = var.instances[2].ip
  }
}

resource "yandex_lb_network_load_balancer" "kuber" {
  name                = "kubernlb"
  deletion_protection = false
  listener {
    name        = "kub"
    port        = 80
    target_port = 30822
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  listener {
    name        = "kub-monitor"
    port        = 3000
    target_port = 30747
    external_address_spec {
      ip_version = "ipv4"
    }

  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.kuber.id
    healthcheck {
      name = "nlbhealthcheck"
      tcp_options {
        port = 30822
      }
    }
  }
}


