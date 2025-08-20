resource "local_file" "setup_playbook" {
  content = <<-EOT

- name: Configure all hosts
  hosts: all
  become: true
  tasks:
    - name: Configure DNS resolver
      copy:
        content: "nameserver 8.8.8.8"
        dest: "/etc/resolv.conf"
        mode: "0644"

# --- 1. Установка WEB-серверов ---
- name: Configure webservers
  hosts: webservers
  become: true
  tags: web
  vars:
    zabbix_server_ip: "${yandex_compute_instance.zabbix.network_interface[0].ip_address}"
    elasticsearch_ip: "${yandex_compute_instance.elasticsearch.network_interface[0].ip_address}"
    kibana_public_ip: "${yandex_compute_instance.kibana.network_interface[0].nat_ip_address}"
    # Переменные для роли zabbix-agent
    zabbix_agent_server: "${yandex_compute_instance.zabbix.network_interface[0].ip_address}"
    zabbix_agent_server_port: 10051
  roles:
    - web
    
# --- 2. Установка ZABBIX-сервера ---
- name: Configure Zabbix
  hosts: zabbix
  become: true
  tags: zabbix
  vars:
    zabbix_public_ip: "${yandex_compute_instance.zabbix.network_interface[0].nat_ip_address}"
  vars_files:
    - ../group_vars/zabbix.yml  
  roles:
    - zabbix-server

# --- 3. Установка ELK (Elasticsearch, Kibana, Filebeat) ---
- name: Configure ELK
  hosts: elk
  become: true
  tags: elk 
  vars:
    elasticsearch_ip: "${yandex_compute_instance.elasticsearch.network_interface[0].ip_address}"
    kibana_ip: "${yandex_compute_instance.kibana.network_interface[0].ip_address}"
    # Передаем переменные аутентификации напрямую из Terraform
    kibana_auth_user: "${var.kibana_auth_user}"
    kibana_auth_password: "${var.kibana_auth_password}"
  roles:
    - elk
    
# --- 4. Установка FILEBEAT на WEB-серверах ---
- name: Configure Filebeat on webservers
  hosts: webservers
  become: true
  tags: filebeat
  vars:
    elasticsearch_ip: "${yandex_compute_instance.elasticsearch.network_interface[0].ip_address}"
    elasticsearch_port: 9200
    kibana_public_ip: "${yandex_compute_instance.kibana.network_interface[0].nat_ip_address}"
  roles:
    - filebeat

# --- 5. Установка ZABBIX-агентов на WEB-серверах ---
- name: Configure Zabbix Agents on webservers
  hosts: webservers
  become: true
  tags: zabbix-agent-web
  vars:
    zabbix_agent_server: "${yandex_compute_instance.zabbix.network_interface[0].ip_address}"
    zabbix_agent_server_port: 10051
  roles:
    - zabbix-agent
  EOT
  filename = "${path.module}/../ansible/playbooks/setup.yml"
}

resource "local_file" "zabbix_group_vars" {
  content = yamlencode({
    zabbix_db_name     = "zabbix"
    zabbix_db_user     = "zabbix"
    zabbix_db_password = var.zabbix_db_password # Используем переменную Terraform
    php_version        = "8.1"
  })
  filename = "${path.module}/../ansible/group_vars/zabbix.yml"
}

resource "local_file" "elk_group_vars" {
  content = yamlencode({
    # --- Kibana Basic Auth ---
    # Эти переменные будут использоваться ролью elk
    kibana_auth_user     = var.kibana_auth_user     # Используем переменную Terraform
    kibana_auth_password = var.kibana_auth_password # Используем переменную Terraform
  })
  filename = "${path.module}/../ansible/group_vars/elk.yml"
}