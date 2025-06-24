# Урок 5 - Virtual Local Area Networ

**Дата:** 24.06.2025

**Видеоурок:** [5.Видео уроки Cisco Packet Tracer. Курс молодого бойца. VLAN](https://vkvideo.ru/video-32477510_456239182?t=21s)

**Цель урока:** Повторение ранее изученного материала

---

## Основные задачи: 
1.**Применение VLAN с одним коммутатором**
2.**Применение VLAN с двумя коммутаторами**
3.**Практика с access и trunk портами**

---

## Выполнение:
1. Создать VLAN -> Определить Access-порты
2. Создать VLAN -> Определить Access-порты -> Определить Trunk-порты
---

## Теория:
- VLAN (Virtual Local Network) - Виртуальная локальная компьютерная сеть - группа хостов с общим набором требований, которые взаимодействуют так, будто подключены к широковещательному домену независимо от их физического местонахождения.
- Позволяет:
 - Разделить сеть на логические сегменты
 - Изолировать трафик и повысить безопасность
 - Уменьшить широковещательный трафик
- Access-port - порт подключения конечного устройства. Доступен только для VLAN
- Trunk-port - порт между коммутаторами. Передаёт трафик нескольких VLAN
- Настройка VLAN возможна только на **управляемых** коммутаторах (консоль, Telnet, SSH, web-интерфейс)

---

## Работа в CPT (Cisco Packet Tracer):

### VLAN c одним коммутатором

1.Размещение:
- Switch1
- 4 PC: PC2-PC5 (соединены прямыми кабелями)

2.Создание VLAN:
'''bash
Switch(config)# vlan 2
Switch(config)# name VLAN2
Switch(config)# vlan 3
Switch(config)# name VLAN3

3.Хосты PC2 - PC3 добавить в vlan 2
Switch(config)# interface range fastethernet 0/1-2
Switch(config)# switchport mode access
Switch(config)# switchport access vlan 2

4.Хосты PC3 - PC4 добавить в vlan 3
Switch(config)# interface range fastethernet 0/3-4
Switch(config)# switchport mode access
Switch(config)# switchport access vlan 3

5.Проверить конфигурацию vlan
Switch# show vlan 

или сокращенную версию
Switch# show vlan brief


6.Дать компьютерам IP-адреса:

PC2 - 192.168.0.2 255.255.255.0
PC3 - 192.168.0.3 255.255.255.0
PC4 - 192.168.0.4 255.255.255.0
PC5 - 192.168.0.5 255.255.255.0

7.Проверить ping внутри vlan
PC2 -> PC3
Ping 192.168.0.3

>Pinging 192.168.0.3 with 32 bytes of data:

>Reply from 192.168.0.3: bytes=32 time=2ms TTL=128

>Reply from 192.168.0.3: bytes=32 time<1ms TTL=128

PC4 -> PC5
Ping 192.168.0.5

>Pinging 192.168.0.5 with 32 bytes of data:

>Reply from 192.168.0.5: bytes=32 time<1ms TTL=128

**Применение VLAN с двумя коммутаторами

1. Разместить на рабочей поверхности 2 коммутатора: Switch2 - Switch3 и 8 PC: PC6-PC13. Хосты соединить со свитчем кабелем прямого сечения.

2.В CLI двух свитчей создать vlan 2 и vlan 3. Присвоить им названия:
Switch(config)# vlan 2
Switch(config)# name VLAN2
Switch(config)# vlan 3
Switch(config)# name VLAN3

**3.Настройка VLAN2**
На Switch 2 PC6-PC7 добавить в vlan 2
Switch(config)# interface range fastethernet 0/1-2
Switch(config)# switchport mode access
Switch(config)# switchport access vlan 2

На Switch 2 PC10-PC10 добавить в vlan 3
Switch(config)# interface range fastethernet 0/3-4
Switch(config)# switchport mode access
Switch(config)# switchport access vlan 3



**4.Настройка VLAN3**
На Switch 2 PC10-PC11 добавить в vlan 3
Switch(config)# interface range fastethernet 0/3-4
Switch(config)# switchport mode access
Switch(config)# switchport access vlan 3

На Switch 3 PC12-PC13 добавить в vlan 3
Switch(config)# interface range fastethernet 0/3-4
Switch(config)# switchport mode access
Switch(config)# switchport access vlan 3

5.5.Проверить конфигурацию vlan
Switch# show vlan 

или сокращенную версию
Switch# show vlan brief

6.Дать компьютерам IP-адреса:

PC6 - 192.168.0.6 255.255.255.0
PC7 - 192.168.0.7 255.255.255.0
PC8 - 192.168.0.8 255.255.255.0
PC9 - 192.168.0.9 255.255.255.0
PC10 - 192.168.0.10 255.255.255.0
PC11 - 192.168.0.11 255.255.255.0
PC12 - 192.168.0.12 255.255.255.0
PC13 - 192.168.0.13 255.255.255.0

7.Соединить Switch1 и Switch2 с помощью перекрёстного кабеля на портах GigabitEthernet 0/1 - GE0/1

8.На switch1 сделать транк-порт и указать какие vlan's смогут передавать трафик через транк порт
Switch(config)# interface gigabitethernet 0/1
Switch(config)# switchport mode trunk
Switch(config)# switchport trunk allowed vlan 2,3

8.На switch2 сделать транк-порт и указать какие vlan's смогут передавать трафик через транк порт
Switch(config)# interface gigabitethernet 0/1
Switch(config)# switchport mode trunk
Switch(config)# switchport trunk allowed vlan 2,3

9.Проверить ping внутри vlan
PC6 -> PC9
Ping 192.168.0.9

>Pinging 192.168.0.9 with 32 bytes of data:

>Reply from 192.168.0.9: bytes=32 time<1ms TTL=128

>Reply from 192.168.0.9: bytes=32 time<1ms TTL=128

PC10 -> PC13
Ping 192.168.0.13

>Pinging 192.168.0.13 with 32 bytes of data:

>Reply from 192.168.0.13: bytes=32 time<1ms TTL=128


---

## Заключения из практики
Очень приятно работать когда вначале планируешь у какого компьютера какой будет IP-адрес, потом намного легче конфигурировать статический IP-адрес.

---

## Вывод
Acceess-port - устанавливает режим доступа. Чтобы отправить или получить файл обращаясь к access-порту, нужно чтобы на этом порту был разрешён доступ на vlan из которой отправляешь запрос.
Trunk-port - позволяет логически разбить физическое соединение на несколько сегментов.
Коммутаторы между собой соединены по одному физическому каналу
Этот физический канал можно разделить на логические каналы (сегментировать) - это даст более упорядоченное движение трафика, а следовательно ускорит работу
