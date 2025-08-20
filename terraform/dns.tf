resource "yandex_dns_zone" "internal" {
  name   = "internal-zone"
  zone   = "ru-central1.internal."
  public = false
}

resource "yandex_dns_recordset" "hosts" {
  for_each = {
    "bastion"       = yandex_compute_instance.bastion.network_interface[0].ip_address
    "web1"          = yandex_compute_instance.web[0].network_interface[0].ip_address
    "web2"          = yandex_compute_instance.web[1].network_interface[0].ip_address
    "zabbix"        = yandex_compute_instance.zabbix.network_interface[0].ip_address
    "elasticsearch" = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
    "kibana"        = yandex_compute_instance.kibana.network_interface[0].ip_address
  }
  zone_id = yandex_dns_zone.internal.id
  name    = "${each.key}.ru-central1.internal."
  type    = "A"
  ttl     = 300
  data    = [each.value]
}