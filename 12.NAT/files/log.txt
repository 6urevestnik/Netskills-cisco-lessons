# Урок 12 - Технология NAT

**Дата:** 29.06.2025

**Видеоурок:** [12.Видео уроки Cisco Packet Tracer. Курс молодого бойца. NAT](https://vkvideo.ru/playlist/-32477510_12/video-32477510_456239176)

**Цель урока:** Повторение ранее изученного материала

---

## Основные задачи 
- Изучить технологию NAT, опробовать её использование




---

## Теория
- Технология NAT (Network Address Translation) - позволяет организовать доступ в сеть интернет для компьютеров с серыми адресами 

- Типы NAT:
  - Статический NAT
  - Динамический NAT
  - Перегруженный NAT (PAT; overloaded NAT) 

- Статический NAT - преобразование серого IP-адреса в белый, используется для обеспечения доступа из сети интернет к локальному серверу с серым IP-адресом.

- Динамический NAT - преобразование серого адреса в один из группы белых IP-адресов.

- Перегруженный NAT - позволяет преобразовывать несколько серых адресов в один белый, используя различные порты, обеспечивая для всех доступ в интернет. Можно обеспечить интернетом весь офис используя один белый IP-адрес.

- Публичный IP-адерс (белый) - данные адреса маршрутизируются в сети интернет, они доступны из любой точки мира.

- Частный IP-адрес (серый) - используется исключительно в локальных сетях, не имеет доступа к сети интернет; данные адреса могут повторяться.

- Что такое IPv4
- Что такое IPv6

- Всегдо выделено 3 класса сетей для использования в локальных сетях:
  - Сеть класса А - от 10.0.0.0 до 10.255.255.255 с маской 255.0.0.0 (около 16 млн. адресов)
  - Сеть класса В - от 172.16.0.0 до 172.31.0.0 с маской 255.255.0.0 (около 65 тыс. адресов)
  - Сеть класса С - от 192.168.0.0 до 192.168.255.255 с маской 255.255.255.0 (около 256 адресов)

---

## Практика

### Topology0

2x Маршрутизатор (Router0, Router1)
1x L2-коммутатор (Switch0)
2x Сервер (Server0, Server1)
3x Компьютер (PC0, PC1, PC2)

![Общий вид](screenshots/topology1.png)

### IP-адресация

|  Название | IP-адрес / Маска |
|-----------|------------------|
| PC0 | 192.168.2.2/24 | 
| PC1 | 192.168.2.3/24 |
| PC2 | 192.168.2.4/24 |
| Server0 | 192.168.3.2/24 |
| Server1 | 213.234.20.2/30 |
| Router0 | 213.234.10.2/30 | 
| Router1 | 213.234.10.1/30 |

### Настройка локальной сети

#### Настроить Access и Trunk порты на Switch0

```bash
# Настройка vlan для компьютеров
Switch(config) interface range fastEthernet 0/1-3
Switch(config-if-range) switchport mode access 
Switch(config-if-range) switchport access vlan 2

# Настройка vlan для сервера
Switch(config) interface fastEthernet 0/4
Switch(config-if-range) switchport mode access 
Switch(config-if-range) switchport access vlan 3

# Настройка Trunk порта для роутера
Switch(config) interface fastEthernet 0/5
Switch(config-if) switchport mode trunk 
Switch(config-if) switchport trunk allowed vlan 2,3

```

![Результаты настройки Switch0](screenshots/switch0_config.png)

#### Настроить Router

```bash
# Поднять линк
Router(config) interface fastEthernet 0/0
Router(config-if) no shutdown 

# Настроить Sub интерфейсы и поднять линк
Router(config) interface fastEthernet 0/0.2
Router(config-subif) encapsulation dot1Q 2
Router(config-subif) ip address 192.168.2.1 255.255.255.0
Router(config-subif) no shutdown 

Router(config) interface fastEthernet 0/0.3
Router(config-subif) encapsulation dot1Q 3
Router(config-subif) ip address 192.168.3.1 255.255.255.0
Router(config-subif) no shutdown 
```

![Результаты настройки Router0](screenshots/router0_config.png)

### Подключение локальной сети к сети интернет
(Сеть интернет в Cisco Packet Tracer симулируем с помощью роутера и сервера с публичными IP-адресами)

#### Настроить Router1

```bash
# Настроить IP-адрес и поднять линк 
Router(config) interface fastEthernet 0/1
Router(config-if) ip address 213.234.10.1 255.255.255.252
Router(config-if) no shutdown 

# Симулируем белый IP-адрес сервера, который находится за роутером провайдера
Router(config) interface fastEthernet 0/0
Router(config-if) ip address 213.234.20.1 255.255.255.252
Router(config-if) no shutdown 
```
![Настройка Router1](screenshots/router1_config.png)


#### Настроить Server1
- Нужно настроить:
  - IP-адрес
  - Маску сети
  - Шлюз

![Настройка Server1](screenshots/server1_config.png)

#### Соединить сегменты сети
- Задать IP-адрес выделенный провайдером и дефолтный маршрут
```bash
Router(config) interface fastEthernet 0/1
Router(config-if) ip address 213.234.10.2 255.255.255.252
Router(config-if) no shutdown 
Router(config-if) ip route 0.0.0.0 0.0.0.0 213.234.10.1
```
- Проверить соединение Router0 с Router1 и Server1
![Проверка соединения Router0 с Router1 и Server1](screenshots/router0_ping.png)

- Чтобы компьютеры с серыми IP-адресами получили доступ в интернет нужно:
  - Определить внутренний NAT интерфейс
  - Определить внешний NAT интерфейс
  -

```bash
# Назначить внешний NAT интерфейс
Router(config) interface fastEthernet 0/1
Router(config-if) ip nat outside 

# Назначить внутрений NAT интерфейс
Router(config) interface fastEthernet 0/0.2
Router(config-subif) ip nat inside 

# Назначить внутрений NAT интерфейс
Router(config) interface fastEthernet 0/0.3
Router(config-subif) ip nat inside 

```

![Настройка Router0](screenshots/router0_config2.png)

#### Создать access листы для NAT трафика (Настройка PAT)
```bash
# Создать
Router(config)#ip access-list standard FOR-NAT

# Указать сеть
Router(config-std-nacl) permit 192.168.2.0 0.255.255.255
Router(config-std-nacl) permit 192.168.3.0 0.255.255.255

# Указываем что NAT нужно с inside, когда трафик проходит через порт fastEthernet 0/1 - дополнительно указывем параметр overload - и тем самым настраиваем PAT
Router(config) ip nat inside source list FOR-NAT interface fastEthernet 0/1 overload 

# Смотрим все трансляции NAT
Router show ip nat translations 

```
![Посмотреть проходящий трафик через Router0](screenshots/router0_nat.png)
![Сделать пинг PC0 to Serever1](screenshots/pc0_ping.png)

- Проверить пинг с Server0 к Server1
![Проверить доступ Server0 в интернет](screenshots/server0_ping.png)

### Обеспечить доступ к локальному веб-серверу из внешней сети (Static NAT)
- Прописать команду на Router0
```bash
Router(config) ip nat inside source static tcp 192.168.3.2 80 213.234.10.2 80
```

Для проверки с Server1 пробуем открыть IP-адрес 231.234.10.2 в браузере
![Проверка подключения](screenshots/server1_web.png)

---

### Проверяем в режиме симуляции
- Видим, что пакет поступает с источником 192.168.2.2 на 213.234.20.2
![Симуляция, пакет с PC0 отправлен на Switch0](screenshots/simulation1.png)

- Когда пакет отправляется с Router0 то он уже поступает с источником 213.234.10.2 на 213.234.20.2
![Симуляция, пакет с Router0 отправлен на Router1](screenshots/simulation2.png)

- Когдад пакет идёт в обратную сторону и отправляется от Router0 к Switch0 - роутер посредством того, что он запомнил с какого компьютера была инициализирована данная сессия перенаправляет пакет от 213.234.20.2 на 192.168.2.2
![[Симуляция, пакет с Router0 отправлен на Switch0](screenshots/simulation3.png)

--- 


## Вывод
- Наиинтереснейшая тема
- Понял что при отправке пакет - просто меняется адрес его отправителя и когда пакет доходит до роутера с белым IP-адресом, то от него он уже как бы переотправляется и наследует его белый IP-адрес
- Нужно расширить теоретические знания NAT