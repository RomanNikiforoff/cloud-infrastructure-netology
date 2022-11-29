#VM Creating

# WEB-1 NGINX-1
resource "yandex_compute_instance" "web1" {
  name                      = "web-1"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
      size     = 15
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
      "sudo hostnamectl set-hostname webserver1",
      "echo '${var.user}:${var.user_password}' | sudo chpasswd",
      "sudo apt-get update -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl restart nginx",
      "sudo chmod 777 /var/www/html/index.nginx-debian.html"
    ]
  }
  
  provisioner "file" { #меняем дефолтный index.html на свой
      source      = "~/kurs-project/files/index.html"
      destination = "/var/www/html/index.nginx-debian.html"  
  }   
  connection {
      type = "ssh"
      user = var.user
      private_key = file(var.private_key_path)
      host = self.network_interface[0].nat_ip_address
  }
}

# WEB-2 NGINX-2

resource "yandex_compute_instance" "web2" {
  name                      = "web-2"
  allow_stopping_for_update = true
  zone                      = "ru-central1-c"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-zone-c.id
    nat = true # public ip
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable = 1
  }
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname webserver2",
      "echo '${var.user}:${var.user_password}' | sudo chpasswd",
      "sudo apt-get update -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl restart nginx",
      "sudo chmod 776 /var/www/html/index.nginx-debian.html"  
    ]
  }
  
  provisioner "file" { #меняем дефолтный index.html на свой
      source      = "~/kurs-project/files/index.html"
      destination = "/var/www/html/index.nginx-debian.html"
  }  
    connection {
      type = "ssh"
      user = var.user
      private_key = file(var.private_key_path)
      host = self.network_interface[0].nat_ip_address
    }
}

# Outputs
output "internal_ip_address_web_1" {
  value = yandex_compute_instance.web1.network_interface.0.ip_address
}
output "internal_ip_address_web_2" {
  value = yandex_compute_instance.web2.network_interface.0.ip_address
}
output "external_ip_address_web_1" {
  value = yandex_compute_instance.web1.network_interface.0.nat_ip_address
}
output "external_ip_address_web_2" {
  value = yandex_compute_instance.web2.network_interface.0.nat_ip_address
}
#output "external_ip_address_gate" {
#  value = yandex_compute_instance.gate.network_interface.0.nat_ip_address
#}
#output "load_balancer_ip" {
#  value = yandex_alb_load_balancer.alb1.network_interface.0.ip_address
#}
