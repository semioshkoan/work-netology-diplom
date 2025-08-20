resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion.ru-central1.internal"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  resources {
    cores         = var.vm_parameters.cores
    memory        = var.vm_parameters.memory
    core_fraction = var.vm_parameters.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.vm_parameters.disk_size
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOT
      #!/bin/bash
      cat <<EOF > /etc/resolv.conf
      nameserver ${cidrhost(yandex_vpc_subnet.public.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_a.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_b.v4_cidr_blocks[0], 2)}
      nameserver 8.8.8.8
      options rotate
      EOF
    EOT
  }
}

resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web${count.index + 1}"
  hostname    = "web${count.index + 1}.ru-central1.internal"
  zone        = count.index == 0 ? "ru-central1-a" : "ru-central1-b"
  platform_id = "standard-v3"
  resources {
    cores         = var.vm_parameters.cores
    memory        = var.vm_parameters.memory
    core_fraction = var.vm_parameters.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.vm_parameters.disk_size
    }
  }
  network_interface {
    subnet_id          = count.index == 0 ? yandex_vpc_subnet.private_a.id : yandex_vpc_subnet.private_b.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOT
      #!/bin/bash
      cat <<EOF > /etc/resolv.conf
      nameserver ${cidrhost(yandex_vpc_subnet.public.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_a.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_b.v4_cidr_blocks[0], 2)}
      nameserver 8.8.8.8
      options rotate
      EOF
    EOT
  }
}

resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix.ru-central1.internal"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd88ihfqlolga7mj8is9" # Ubuntu 22.04 LTS
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.zabbix_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOT
      #!/bin/bash
      cat <<EOF > /etc/resolv.conf
      nameserver ${cidrhost(yandex_vpc_subnet.public.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_a.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_b.v4_cidr_blocks[0], 2)}
      nameserver 8.8.8.8
      options rotate
      EOF
    EOT
  }
}

resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch.ru-central1.internal"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  resources {
    cores         = var.vm_parameters.cores
    memory        = var.vm_parameters.memory
    core_fraction = var.vm_parameters.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.vm_parameters.disk_size
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.private_a.id
    security_group_ids = [yandex_vpc_security_group.elasticsearch_sg.id]
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOT
      #!/bin/bash
      cat <<EOF > /etc/resolv.conf
      nameserver ${cidrhost(yandex_vpc_subnet.public.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_a.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_b.v4_cidr_blocks[0], 2)}
      nameserver 8.8.8.8
      options rotate
      EOF
    EOT
  }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana.ru-central1.internal"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"
  resources {
    cores         = var.vm_parameters.cores
    memory        = var.vm_parameters.memory
    core_fraction = var.vm_parameters.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.vm_parameters.disk_size
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana_sg.id]
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOT
      #!/bin/bash
      cat <<EOF > /etc/resolv.conf
      nameserver ${cidrhost(yandex_vpc_subnet.public.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_a.v4_cidr_blocks[0], 2)}
      nameserver ${cidrhost(yandex_vpc_subnet.private_b.v4_cidr_blocks[0], 2)}
      nameserver 8.8.8.8
      options rotate
      EOF
    EOT
  }
}