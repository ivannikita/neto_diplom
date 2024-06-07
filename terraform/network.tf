variable "subnets" {
  default = {
    "0" = {
      cidr = "172.16.1.0/24"
      zone = "ru-central1-a"
    },
    "1" = {
      cidr = "172.16.2.0/24"
      zone = "ru-central1-b"
    },
    "2" = {
      cidr = "172.16.3.0/24"
      zone = "ru-central1-d"
    },
  }
}


resource "yandex_vpc_network" "net" {
  name = local.net
}


resource "yandex_vpc_route_table" "neto-table" {
  network_id = yandex_vpc_network.net.id
  name       = "neto-table"
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.natinstancemachne.network_interface.0.ip_address
  }

}

# resource "yandex_vpc_security_group" "nat-neto-sg" {
#   name       = local.sg_nat_name
#   network_id = yandex_vpc_network.net.id

#   egress {
#     protocol       = "ANY"
#     description    = "any"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     protocol       = "TCP"
#     description    = "ssh"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 22
#   }

#   ingress {
#     protocol       = "TCP"
#     description    = "ext-http"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 80
#   }
#   ingress {
#     protocol          = "TCP"
#     description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика."
#     predefined_target = "loadbalancer_healthchecks"
#     from_port         = 0
#     to_port           = 65535
#   }
#   ingress {
#     protocol          = "ANY"
#     description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
#     predefined_target = "self_security_group"
#     from_port         = 0
#     to_port           = 65535
#   }
#   ingress {
#     protocol       = "ANY"
#     description    = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера и сервисов."
#     v4_cidr_blocks = ["10.96.0.0/16", "10.112.0.0/16"]
#     from_port      = 0
#     to_port        = 65535
#   }
#   ingress {
#     protocol       = "TCP"
#     description    = "ext-https"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 443
#   }
#   ingress {
#     protocol       = "TCP"
#     description    = "Правило разрешает подключение к API Kubernetes через порт 6443 из указанной сети."
#     v4_cidr_blocks = ["78.81.147.252/32"]
#     port           = 6443
#   }
#   ingress {
#     protocol       = "ICMP"
#     description    = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
#     v4_cidr_blocks = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
#   }
# }

resource "yandex_vpc_subnet" "neto-subnet-pub" {
  name           = local.sub_net_pub
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["172.16.17.0/28"]
}

resource "yandex_vpc_subnet" "neto-subnet" {
  count          = 3
  name           = "neto_sub_net${count.index}"
  route_table_id = yandex_vpc_route_table.neto-table.id
  zone           = var.subnets[count.index].zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.subnets[count.index].cidr]

}

