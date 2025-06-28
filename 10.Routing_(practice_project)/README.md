# Урок №10 - Practise Routing

**Дата:** 27.06.2025

**Задача:** Отработать самостоятельно маршрутизацию. Соединить все сегменты сети.

---

## IP-адресация

| Устройство | IP-адрес     | mask          | gate         | VLAN |
|------------|--------------|---------------|--------------|------|
| PC0 	     | 192.168.21.2 | 255.255.255.0 | 192.168.21.1 | 2    |
| PC3        | 192.168.21.3 | 255.255.255.0 | 192.168.21.1 | 2    |
| PC6        | 192.168.21.4 | 255.255.255.0 | 192.168.21.1 | 2    |
| PC9        | 192.168.21.5 | 255.255.255.0 | 192.168.21.1 | 2    |
| PC12       | 192.168.22.2 | 255.255.255.0 | 192.168.22.1 | 2    |
| PC15       | 192.168.23.2 | 255.255.255.0 | 192.168.23.1 | 2    |
| PC18       | 192.168.24.2 | 255.255.255.0 | 192.168.24.1 | 2    |
| PC1        | 192.168.31.2 | 255.255.255.0 | 192.168.31.1 | 3    |
| PC4        | 192.168.31.3 | 255.255.255.0 | 192.168.31.1 | 3    |
| PC7        | 192.168.31.4 | 255.255.255.0 | 192.168.31.1 | 3    |
| PC10       | 192.168.31.5 | 255.255.255.0 | 192.168.31.1 | 3    |
| PC13       | 192.168.32.2 | 255.255.255.0 | 192.168.32.1 | 3    |
| PC16       | 192.168.33.2 | 255.255.255.0 | 192.168.33.1 | 3    |
| PC19       | 192.168.34.2 | 255.255.255.0 | 192.168.34.1 | 3    |
| PC2        | 192.168.41.2 | 255.255.255.0 | 192.168.41.1 | 4    |
| PC5        | 192.168.41.3 | 255.255.255.0 | 192.168.41.1 | 4    |
| PC8        | 192.168.41.4 | 255.255.255.0 | 192.168.41.1 | 4    |
| PC11       | 192.168.41.5 | 255.255.255.0 | 192.168.41.1 | 4    |
| PC14       | 192.168.42.2 | 255.255.255.0 | 192.168.42.1 | 4    |
| PC17       | 192.168.43.2 | 255.255.255.0 | 192.168.43.1 | 4    |
| PC20       | 192.168.44.2 | 255.255.255.0 | 192.168.44.1 | 4    |
| Server0    | 192.168.51.2 | 255.255.255.0 | 192.168.51.1 | 5    |
| Server1    | 192.168.51.3 | 255.255.255.0 | 192.168.51.1 | 5    |

## Сегмент №1

![Первый большой сегмент сети](./screenshot/office1.png)

---

### Настроить L2 коммутаторы

```bash
# Создать vlan
Switch(config) vlan 2
Switch(config-vlan) name VLAN2

# Сделать access-порты
Switch(config) interface fastEthernet 0/1
Switch(config-if) switchport mode access 
Switch(config-if) switchport access vlan 2

# Сделать trunk-порт
Switch(config) interface fastEthernet 0/4
Switch(config-if) switchport mode trunk 
Switch(config-if) switchport trunk allowed vlan 2,3,4,5
```
![Результаты настройки](./screenshot/shr_switch0.png)

---

### Настроить L3 коммутатор

```bash
# Создать vlan
Switch(config) vlan 2
Switch(config-vlan) name VLAN2

# Указать инкапсуляцию и сделать trunk-порты
Switch(config) interface fastEthernet 0/1
Switch(config-if) switchport trunk encapsulation dot1q 
Switch(config-if) switchport mode trunk 
Switch(config-if) switchport trunk allowed vlan 2,3,4,5

# Настроить IP-адреса на VLAN
Switch(config) interface vlan 2
Switch(config-if) ip address 192.168.21.1 255.255.255.0

# Настроить vlan 6 для Router
Switch(config) vlan 6
Switch(config-vlan) name VLAN6
Switch(config-vlan) exit 
Switch(config) interface vlan 6
Switch(config-if) ip address 192.168.60.2 255.255.255.0
Switch(config-if) no shutdown 

# Сделать access-порт для vlan 6
Switch(config) interface gigabitEthernet 0/2
Switch(config-if) switchport mode access 
Switch(config-if) switchport access vlan 6
```
![Конфигурация L3 коммутатора](./screenshot/shr_0multiswitch.png)
![Конфигурация L3 коммутатора](./screenshot/shr_0multiswitch1.png)

---

### Проверка связи сежду сегментами сети

![PC11 to PC7, PC4, PC0, Server1](./screenshot/ping_pc11.png)


---


### Настроить Router0

```bash
# Поднять линк gi0/2 и задать ему IP-адрес
Router(config) interface gigabitEthernet 0/2
Router(config-if) no shutdown 
Router(config-if) ip address 192.168.60.1 255.255.255.0

# Проверить соединение с L3 switch
Router ping 192.168.60.2
```
![Проверка пинга с Router0 на L3-коммутатор](./screenshot/ping_0router.png)

---

## Сегменты №2,3,4

### Настроить Switch5
```bash
# Создать vlan
Switch(config) vlan 2
Switch(config-vlan) name VLAN2

# Сделать access-порты
Switch(config) interface fastEthernet 0/1
Switch(config-if) switchport mode access 
Switch(config-if) switchport access vlan 2

# Сделать trunk-порт
Switch(config) interface fastEthernet 0/4
Switch(config-if) switchport mode trunk 
Switch(config-if) switchport trunk allowed vlan 2,3,4
```
- Аналогично настроить  Switch6 и Switch7

![Результаты настройки](./screenshot/shr_switch5.png)
![Результаты настройки](./screenshot/shr_switch6.png)
![Результаты настройки](./screenshot/shr_switch7.png)


### Настроить Router1
```bash
# Поднять линк
Router(config) interface fastEthernet 0/0
Router(config-if) no shutdown 

# Создать Sub-интерфейс и задать IP-адрес
Router(config) interface fastEthernet 0/0.2
Router(config-subif) ip address 192.168.22.1 255.255.255.0
Router(config-subif) no shutdown 
```
- Аналогично настроить  Router2 и Router3

![Конфигурация Router1](./screenshot/shr_1router.png)
![Конфигурация Router1](./screenshot/shr_2router.png)

### Проверка пинга между сегментами сети

![Проверка пинга PC12 to PC13, PC14](./screenshot/ping_pc12.png)
![Проверка пинга PC16 to PC15, PC17](./screenshot/ping_pc16.png)
![Проверка пинга PC20 to PC19, PC18](./screenshot/ping_pc18.png)

---

 ## Соединить сегменты №1,2,3 и 4

![](./screenshot/topology_full.png)

### Указать маршруты к vlan для Router0
```bash
Router(config) ip route 192.168.21.0 255.255.255.0 192.168.60.2
Router(config) ip route 192.168.31.0 255.255.255.0 192.168.60.2
Router(config) ip route 192.168.41.0 255.255.255.0 192.168.60.2
Router(config) ip route 192.168.51.0 255.255.255.0 192.168.60.2
```
![Проверить пинг Router0 с PC0, PC4, PC8, PC10, Server1](./screenshot/ping_0router1.png)

### Настроить линк между Router0 и Router1
- Router0
```bash
Router(config) interface gigabitEthernet 0/1
Router(config-if) no shutdown 
Router(config-if) ip address 192.168.61.1 255.255.255.252
```

- Router1
```bash
Router(config) interface fastEthernet 0/1
Router(config-if) no shutdown 
Router(config-if) ip address 192.168.61.2 255.255.255.252
```
- Проверить пинг между Router0 и 1 - успешно

### Настроить линк между Router0 и Router3
- Router0
```bash
Router(config) interface gigabitEthernet 0/0
Router(config-if) ip address 192.168.62.1 255.255.255.252
Router(config-if) no shutdown 
```

- Router3
```bash
Router(config) interface gigabitEthernet 0/2
Router(config-if) ip address 192.168.62.2 255.255.255.252
Router(config-if) no shutdown 
```
- Проверить пинг между Router1 и 3 - успешно

### Настроить линк между Router3 и Router2
- Router3
```bash
Router(config) interface gigabitEthernet 0/0
Router(config-if) ip address 192.168.63.1 255.255.255.252
Router(config-if) no shutdown 
```

- Router2
``` bash
Router(config) interface fastEthernet 0/0
Router(config-if) ip address 192.168.63.2 255.255.255.252
Router(config-if) no shutdown 
```
- Проверить пинг между Router3 и 2 - успешно

---

### Таблица маршрутизации L3 Switch
![Таблица маршрутизации L3-коммутатора](./screenshot/ip_route_l3switch.png)

### Таблица маршрутизации Router0
![Таблица маршрутизации Router0](./screenshot/ip_route_router0.png)

### Таблица маршрутизации Router1
![Таблица маршрутизации Router1](./screenshot/ip_route_router1.png)

### Таблица маршрутизации Router2
![Таблица маршрутизации Router2](./screenshot/ip_route_router2.png)

### Таблица маршрутизации Router3
![Таблица маршрутизации Router3](./screenshot/ip_route_router3.png)

---

## Работа над ошибками
- Не было связи PC0 и PC9. Забыл прописать настройки на Switch3
- Перепутал маршруты от Router 2. С помощью no ip route стёр неверную конфигурацию и указал верную.
