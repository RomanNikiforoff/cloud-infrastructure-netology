#VM Creating

# Prometheus
resource "yandex_compute_instance" "somepr" {
  name                      = "theus"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-zone-a.id 
    nat = true # public динамический ip
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable = 1
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname prometheus1",
      "echo '${var.user}:${var.user_password}' | sudo chpasswd"
    ]
  }
     
  connection {
      type = "ssh"
      user = var.user
      private_key = file(var.private_key_path)
      host = self.network_interface[0].nat_ip_address
  }
}


# Outputs
output "external_ip_address_Prometheus" {
  value = yandex_compute_instance.somepr.network_interface.0.nat_ip_address
}
