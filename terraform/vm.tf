

resource "yandex_compute_image" "kuber_machine" {
  source_image = "fd8oc4qnq5kg274e0vbn"
}

resource "yandex_compute_instance" "kuber_machine" {
  count                     = 3
  name                      = var.instances[count.index].name
  platform_id               = "standard-v2"
  zone                      = var.instances[count.index].zone
  folder_id                 = var.folder_id
  hostname                  = var.instances[count.index].name
  allow_stopping_for_update = true

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.kuber_machine.id
      size     = 30
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.neto-subnet[var.instances[count.index].net].id
    ip_address = var.instances[count.index].ip
    nat        = var.instances[count.index].nat
    # security_group_ids = [yandex_vpc_security_group.nat-neto-sg.id]
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1ixdYjOlEA3J17vXai6m9GogHEJQE0s/r+sNSfyOmVA+2EWMPacNnNNE06YUQoeXMmksT3k/7gqOMniaBNVPO/+nzdXmOImW8WqkmxAkhWMNxN0vKZSJudzWQhj+V4JUC24s5xsFwRc1avGOLkxL2ynd2dy1AgZUjv2poZ0B/2rTqFzS5PTgy2ji+OGukD4ocT5VSz4q4sEZ9CUWmy0xqcgw0Z8puhTaQgHo52GdpZPTNRuqWmjZG28NMI6k6IPjH+z0uP8hKNbEGPjeEZqvcDQQ2DLSNS1JrFZlY5823KpALEjlc1oBwX4J1AgPgY0JQG2QeYc3fPgg1OAp3db0x nivanov@localhost.localdomain"
  }
}
resource "local_file" "k8s" {
  count    = 3
  content  = templatefile("${path.module}/host.tpl", { "name" : var.instances[count.index].name, "ip" : yandex_compute_instance.kuber_machine[count.index].network_interface.*.ip_address[0], group : "k8s", user : "ubuntu", type : "${var.instances[count.index].type}", "ip_nat" : yandex_compute_instance.natinstancemachne.network_interface.0.nat_ip_address, "kub_ip" : yandex_compute_instance.kuber_machine[0].network_interface.0.nat_ip_address })
  filename = pathexpand("~/neto_diplom/Ansible/hosts/k8s${count.index}")
}
