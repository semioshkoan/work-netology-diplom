
#             Дипломная работа по профессии 
#             «Системный администратор»
#             Семиошко Андрей

## Задача

Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. 
Для развёртывания инфраструктуры использовал Terraform и Ansible.
Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/) и отвечать минимальным стандартам безопасности: запрещается выкладывать токен от облака в git. 
Используйте [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#get-credentials).

# Начало работы  

## Инфраструктура  

# Итоговая архитектура по дипломному заданию

🎯 Основные компоненты:

Веб-серверы
2 ВМ (Nginx, стат. сайт, приватный IP, zabbix-agent, filebeat).

Бастион
1 ВМ, публичный IP, приватный IP, SSH.

Zabbix
1 ВМ (сервер + агент), публичный IP, приватный IP.

Elasticsearch
1 ВМ, приватный IP, SSH.

Kibana
1 ВМ, публичный IP, приватный IP.

Балансировщик
Yandex Application Load Balancer.

Мониторинг и логи
Zabbix + Filebeat -> Elasticsearch.

Резервное копирование
Snapshots всех ВМ, TTL = 7 дней, ежедневный запуск.

NAT
Yandex NAT Gateway.

VPC
1 VPC, 1 публичная + 1 приватная подсеть.

## Для развертывания инфраструктуры использовался Terraform. 

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/1.png)  

## Создано 6 виртуальных машин согласно заданию дипломной работы.

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/2.png)  

## Создано расписание для снимков дисков ВМ.

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/3.png) 

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/4.png) 

## Созданы приватная подсеть и публичная сеть.

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/5.png) 

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/14.png)

## Создана группа безопасности.
  
![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/6.png) 

## Карта сети. 

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/7.png) 

## Создан балансировщик.

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/8.png)  

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/9.png)  
  
Время развертывания занимает 10 - 15 минут.  
  
## Сервисы  
   
### Сайт  

## Nginx  http://84.252.135.63

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/10.png)  

## Выполняем curl -v http://84.252.135.63

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/11.png)  
  
### Мониторинг  
  
## Zabbix  http://89.169.153.230  Дашборты для VM1 и VM2.

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/12.png)  
  
### Логи

## Kibana http://89.169.131.216

![alt text](https://github.com/semioshkoan/work-netology-diplom/blob/main/screenshots/13.png)  
  

