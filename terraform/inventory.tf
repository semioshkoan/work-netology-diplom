resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.yaml.tmpl", {
    bastion_fqdn       = "bastion.ru-central1.internal"
    bastion_ip         = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
    web1_fqdn          = "web1.ru-central1.internal"
    web1_ip            = yandex_compute_instance.web[0].network_interface[0].ip_address
    web2_fqdn          = "web2.ru-central1.internal"
    web2_ip            = yandex_compute_instance.web[1].network_interface[0].ip_address
    zabbix_fqdn        = "zabbix.ru-central1.internal"
    zabbix_ip          = yandex_compute_instance.zabbix.network_interface[0].ip_address
    elasticsearch_fqdn = "elasticsearch.ru-central1.internal"
    elasticsearch_ip   = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
    kibana_fqdn        = "kibana.ru-central1.internal"
    kibana_ip          = yandex_compute_instance.kibana.network_interface[0].ip_address
  })
  filename = "${path.module}/../ansible/inventory/prod.yml"
}