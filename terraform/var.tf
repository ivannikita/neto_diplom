variable "folder_id" {
  type = string
}
variable "token" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}



locals {
  net         = "neto-net"
  pub_net     = "neto-net-pub"
  vm_nat_name = "nat-machine"
  sub_net_pub = "neto-pub-net"
  sub_net1    = "neto_sub_net1"
  sub_net2    = "neto_sub_net2"
  sub_net3    = "neto_sub_net3"
  sg_nat_name = "sec_name"
}
