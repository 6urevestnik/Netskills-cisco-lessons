# Урок 8 - Использование коммутатора третьего уровня

**Дата:** 25.06.2025
**Видеоурок:** [8.Видео уроки Cisco Packet Tracer. Курс молодого бойца. L3 коммутатор](https://vkvideo.ru/playlist/-32477510_12/video-32477510_456239179)

**Цель урока:** Повторение ранее изученного материала

---

## Основные задачи 

---

## Теория
Коммутаторы L3 могут:
- IP маршрутизация
- Агрегирование коммутаторов уровня доступа
- Используются в качестве коммутаторов уровня распределения
- Высокая производительность

- L3 коммутатор нужен для маршрутизации в случае если коммутаторов L2 в сети больше 2
---

## Практика

**Топология**
- L3 Switch
- К нему подключены 3 PC: PC0-PC2

**Конфигурация**
- Каждый PC находится в своей VLAN
  - PC0 - vlan 2 - name VLAN2
  - PC1 - vlan 3 - name VLAN3
  - PC2 - vlan 3 - name VLAN4

```bash
# Настройка vlan 2 для PC0
Switch(config) vlan 2
Switch(config-if) name VLAN2
Switch(config) interface fastethernet 0/1
Switch(config) switchport mode access
Switch(config) switchport access vlan 2
# Провести аналогичную настройку vlan

```
- Сконфигурировать IP-адреса для созданных vlan
  - vlan 2 - 2.2.2.1 255.255.255.0
  - vlan 3 - 3.3.3.1 255.255.255.0
  - vlan 4 - 4.4.4.1 255.255.255.0

- Сконфигурировать IP-адреса для PC
  - PC0 2.2.2.2 255.255.255.0
  - PC1 3.3.3.2 255.255.255.0
  - PC2 4.4.4.2 255.255.255.0

- Задать дефолтный шлюз согласно IP-адресу vlan

```bash
# Конфигурация IP-адреса vlan 2
Switch(config) interface vlan 2
Switch(config-vlan) ip address 2.2.2.1 255.255.255.0
# Провести аналогичную конфигурация vlan
```
- Проверить результаты конфигурации
![интерфейс вилан](./scrns/conig_vlan.png)
![фаст езернет](./scrns/conif_f-e.png)

- Проверить свзяь
![пинг пк0](./scrns/pc0_ping.png)
![пинг пк1](./scrns/pc1_ping.png)
![пинг пк2](./scrns/pc2_ping.png)

- Дать возможность межсетевого взаимодействия
```bash
# L3 Switch config:
Switch(config) ip routing
```
- Проверить результаты  
![пинг пк0](./scrns/pc0_ping2.png)
![пинг пк1](./scrns/pc1_ping2.png)
![пинг пк2](./scrns/pc2_ping2.png)

---

**Пример большой сети**

**Топология**
- L3 Switch
- К нему подключены Switch0 и Switch1 (L2)
- К свитчам подключены по 2 PC
  - PC3 - Switch0 - Fa0/1 - vlan 2 - IP 2.2.2.2 255.255.255.0 - gate 2.2.2.1
  - PC4 - Switch0 - Fa0/2 - vlan 3 - IP 3.3.3.2 255.255.255.0 - gate 3.3.3.1
  - PC5 - Switch1 - Fa0/1 - vlan 2 - IP 2.2.2.3 255.255.255.0 - gate 2.2.2.1
  - PC6 - Switch1 - Fa0/2 - vlan 3 - IP 3.3.3.3 255.255.255.0 - gate 3.3.3.1

**Конфигурация**
- Определить PC в vlan согласно топологии
```bash
# Настройка switch 2
Switch(config) vlan 2
Switch(config-vlan) name VLAN2
Switch(config) interface fastethernet 0/1
Switch(config-if) switchport mode access
Switch(config-if) switchport access vlan 2
```

- Настроить trunk порт L2 Switch с L3 Switch

```bash
# Настройка switch 2
Switch(config) interface gigabitethernet 0/1
Switch(config-if) switchport mode trunk
Switch(config-if) switchport trunk allowed vlan 2,3
```

- Проверить конфигурации
```bash
Switch show running-config
```
- Аналогично нужно настроить Switch1

![results2](./scrns/int_config1.png)
![results3](./scrns/int_config2.png)

- Настроить L3 Switch
```bash
Switch(config)#vlan 2
Switch(config-vlan)#name VLAN2
# Аналогично создать vlan 3 
Switch(config) interface gigabitethernet 0/1
Switch(config-if) switchport trunk encapsulation dot1q 
Switch(config-if) switchport mode trunk
Switch(config-if)#switchport trunk allowed vlan 2,3
# аналогично для gi 0/2 и Switch1
```

- На созданные виртуальные интерфейсы сконфигурируем IP-адреса
  - vlan 2 - 2.2.2.1 255.255.255.0
  - vlan 3 - 3.3.3.1 255.255.255.0

```bash
Switch(config) interface vlan 2
Switch(config-if) ip address 2.2.2.1 255.255.255.0
# Обязательно прописать ip route!
Switch(config) ip routing
```

- Проверить ping
```bash
ping 3.3.3.2
ping 2.2.2.3
ping 3.3.3.3
```
![ping_reslts](./srcns/ping_all.png)

---

## Вывод
- L2 коммутаторы предлагают самую низкую стоимость портов
- Между коммутаторами лучше использовать самые быстрые линки, чтобы обеспечить наибольшую производительность
- Лучше всегда использовать инкапсуляцию dot1q - она стандартная для большинства оборудования