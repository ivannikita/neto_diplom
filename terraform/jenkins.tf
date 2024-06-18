variable "instances_jen" {
  default = {
    "0" = {
      name = "jenkins"
      ip   = "172.16.1.10"
      zone = "ru-central1-a"
      net  = "0"
      nat  = true
    }
  }
}

resource "yandex_compute_image" "jenkins" {
  source_image = "fd8uovsib5ai08e20cr2"
}


resource "yandex_compute_instance" "jenkins_machne" {
  count       = 1
  name        = local.vm_jen_name
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
      image_id = yandex_compute_image.jenkins.id
      size     = 30
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.neto-subnet[var.instances_jen[count.index].net].id
    ip_address = "172.16.1.11"
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
resource "local_file" "jen" {
  count    = 1
  content  = templatefile("${path.module}/host.tpl", { "name" : local.vm_jen_name, "ip" : yandex_compute_instance.jenkins_machne[count.index].network_interface.*.ip_address[0], group : "jen", user : "debian", type : "jen", "ip_nat" : yandex_compute_instance.natinstancemachne.network_interface.0.nat_ip_address, "kub_ip" : "null" })
  filename = pathexpand("~/neto_diplom/Ansible/hosts/jen")
}
