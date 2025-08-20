variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "ubuntu_image_id" {
  description = "Ubuntu 22.04 image ID"
  type        = string
  default     = "fd88ihfqlolga7mj8is9"
}

variable "vm_parameters" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
  }
}

# --- Zabbix Variables ---
variable "zabbix_db_password" {
  description = "Password for the Zabbix database user"
  type        = string
  sensitive   = true # Скрывает значение в логах и выводе plan/apply
  # default     = "ChangeMeInTerraformTFVars" # Не рекомендуется задавать дефолт для паролей
}

# --- ELK Variables ---
variable "kibana_auth_user" {
  description = "Username for Kibana basic authentication"
  type        = string
  default     = "kibanaadmin"
}

variable "kibana_auth_password" {
  description = "Password for Kibana basic authentication"
  type        = string
  sensitive   = true # Скрывает значение в логах и выводе plan/apply
  # default     = "ChangeMeInTerraformTFVars" # Не рекомендуется задавать дефолт для паролей
}

# Если в будущем понадобятся другие переменные, например:
# variable "elasticsearch_heap_size" {
#   description = "Heap size for Elasticsearch JVM"
#   type        = string
#   default     = "1g"
# }