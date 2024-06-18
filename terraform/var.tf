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
  vm_jen_name = "jenkins"
}

variable "instances" {
  default = {
    "0" = {
      name = "kube1"
      ip   = "172.16.1.10"
      type = "master"
      zone = "ru-central1-a"
      net  = "0"
      nat  = true
    },
    "1" = {
      name = "kube2"
      ip   = "172.16.2.10"
      type = "slave"
      zone = "ru-central1-b"
      net  = "1"
      nat  = false
    },
    "2" = {
      name = "kube3"
      ip   = "172.16.3.10"
      type = "slave"
      zone = "ru-central1-d"
      net  = "2"
      nat  = false
    },
  }
}
