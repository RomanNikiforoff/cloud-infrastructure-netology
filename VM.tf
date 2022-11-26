#VM Creating

# Bastion host (машина с внешним IP и ssh для управления всеми остальными)
resource "yandex_compute_instance" "gate" {
  name                      = "gate"
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
    subnet_id = "e9bopjo60lbholcap1u2" # одна из дефолтных подсетей
    nat       = true                   # автоматически установить динамический ip
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable = 1
  }

}

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
    subnet_id = "e9bopjo60lbholcap1u2" # одна из дефолтных подсетей
    nat = true # автоматически установить динамический ip
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
      "sudo systemctl restart nginx"
      #"sudo ufw allow 3389/tcp",
      #"sudo /etc/xrdp/startwm.sh",
      #"sudo /etc/init.d/xrdp restart"
    ]
    connection {
      type = "ssh"
      user = var.user
      private_key = file(var.private_key_path)
      host = self.network_interface[0].nat_ip_address
    }
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
    subnet_id = "b0c82gt6k72695pofe0m" # одна из дефолтных подсетей
    nat = true # автоматически установить динамический ip
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
      "sudo systemctl restart nginx"
      #"sudo ufw allow 3389/tcp",
      #"sudo /etc/xrdp/startwm.sh",
      #"sudo /etc/init.d/xrdp restart"
    ]
    connection {
      type = "ssh"
      user = var.user
      private_key = file(var.private_key_path)
      host = self.network_interface[0].nat_ip_address
    }
  }

}

# Prometheus

resource "yandex_compute_instance" "prom1" {
  name                      = "prometheus"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
      size     = 30
    }
  }

  network_interface {
    subnet_id = "e9bopjo60lbholcap1u2" # одна из дефолтных подсетей
    #nat = true # автоматически установить динамический ip
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable = 1
  }

}

# Grafana

resource "yandex_compute_instance" "graf" {
  name                      = "grafana"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
      size     = 30
    }
  }

  network_interface {
    subnet_id = "e9bopjo60lbholcap1u2" # одна из дефолтных подсетей
    nat = true # автоматически установить динамический ip
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable = 1
  }

}

# Elastic\opensearch

resource "yandex_compute_instance" "elk" {
  name                      = "opensearch"
  allow_stopping_for_update = true
  zone                      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 6
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
      size     = 15
    }
  }

  network_interface {
    subnet_id = "e9bopjo60lbholcap1u2" # одна из дефолтных подсетей
    #nat = true # автоматически установить динамический ip
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable = 1
  }

}

# kibana

resource "yandex_compute_instance" "kibana" {
  name                      = "kibana"
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
    subnet_id = "e9bopjo60lbholcap1u2" # одна из дефолтных подсетей
    nat = true # автоматически установить динамический ip
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable = 1
  }

}

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
output "external_ip_address_gate" {
  value = yandex_compute_instance.gate.network_interface.0.nat_ip_address
}
