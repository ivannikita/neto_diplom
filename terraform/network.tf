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
resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id = var.folder_id
  name      = "neto-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "neto-table" {
  folder_id  = var.folder_id
  name       = "neto-table"
  network_id = yandex_vpc_network.net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

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

