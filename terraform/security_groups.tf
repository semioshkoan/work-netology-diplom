resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["192.168.10.0/24"]
  }
  ingress {
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "zabbix_sg" {
  name       = "zabbix-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  ingress {
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name       = "elasticsearch-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.kibana_sg.id
  }
  ingress {
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.web_sg.id
  }
  ingress {
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "kibana_sg" {
  name       = "kibana-sg"
  network_id = yandex_vpc_network.diplom_network.id
  ingress {
    protocol       = "TCP"
    port           = 80 # <-- Порт для Nginx
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}