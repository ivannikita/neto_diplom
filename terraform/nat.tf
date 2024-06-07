resource "yandex_compute_image" "nat_instance" {
  source_image = "fd8kk9tbc8khkg6gbivh"
}


resource "yandex_compute_instance" "natinstancemachne" {
  name        = local.vm_nat_name
  platform_id = "standard-v2"
  # zone                      = var.default_zone
  folder_id                 = var.folder_id
  allow_stopping_for_update = true
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.nat_instance.id
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.neto-subnet-pub.id
    ip_address = "172.16.17.11"
    nat        = true
    # security_group_ids = [yandex_vpc_security_group.nat-neto-sg.id]

  }
  # network_interface {
  #   subnet_id  = yandex_vpc_subnet.neto-subnet[0].id
  #   ip_address = "172.16.1.254"
  # }


  metadata = {
    ssh-keys = "admin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1ixdYjOlEA3J17vXai6m9GogHEJQE0s/r+sNSfyOmVA+2EWMPacNnNNE06YUQoeXMmksT3k/7gqOMniaBNVPO/+nzdXmOImW8WqkmxAkhWMNxN0vKZSJudzWQhj+V4JUC24s5xsFwRc1avGOLkxL2ynd2dy1AgZUjv2poZ0B/2rTqFzS5PTgy2ji+OGukD4ocT5VSz4q4sEZ9CUWmy0xqcgw0Z8puhTaQgHo52GdpZPTNRuqWmjZG28NMI6k6IPjH+z0uP8hKNbEGPjeEZqvcDQQ2DLSNS1JrFZlY5823KpALEjlc1oBwX4J1AgPgY0JQG2QeYc3fPgg1OAp3db0x nivanov@localhost.localdomain"
    #     user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}
