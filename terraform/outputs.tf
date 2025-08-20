output "balancer_ip" {
  value = yandex_alb_load_balancer.web_balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "kibana_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
}

output "web_ip" {
  value = yandex_compute_instance.web[*].network_interface[0].ip_address
}

output "zabbix_ip" {
  value = yandex_compute_instance.zabbix.network_interface[0].nat_ip_address
}

output "elastic_ip" {
  value = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
}