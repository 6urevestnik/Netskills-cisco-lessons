# Отчет по уроку 7 – EtherChannel и агрегирование каналов

**Дата:** 24.06.2025  
**Тема:** Агрегирование каналов – Протокол EtherChannel  
**Связанный урок:** [7.EtherChannel_LACP](../7.EtherChannel_LACP/README.md)

---

## Цель урока
- Повторить и закрепить ранее изученные темы
- Научиться настраивать EtherChannel (агрегацию каналов)
- Ознакомиться с работой протокола LACP
- Проверить отказоустойчивость логического канала при выходе из строя одного линка

---

## Теоретическая база

### Что такое EtherChannel:
- Объединение нескольких физических каналов в один логический для повышения пропускной способности и отказоустойчивости
- Используются одновременно все активные каналы (load balancing)
- При выходе одного линка трафик автоматически перераспределяется на оставшиеся
- Протоколы:
  - *@LACP (IEEE 802.3ad)** – открытый стандарт, предпочтителен
  - **PAgP** – проприетарный протокол Cisco

> Для успешной агрегации каналы должны иметь одинаковую скорость, дуплекс, VLAN-настройку и тип интерфейса

---

## Практическая часть

### Статическое агрегирование

**Топология:**
- Switch0 ←→ Switch1  
- PC0 ←→ Switch0 (Fa0/1–2)  
- PC1 ←→ Switch1 (Fa0/1–2)

**Конфигурация:**

1. Назначение IP-адресов:
   - PC0: `192.168.1.1 /24`
   - PC1: `192.168.1.2 /24`

2. Агрегация портов на свитчах:
```bash
Switch(config) interface range fastethernet 0/1-2
Switch(config-if-range) channel-group 1 mode on 

3. Проверка связи:
```bash 
ping 192.168.1.2
```
Успешный отклик подтверждает работоспособность EtherChannel

 4. Проверка отказоустойчивости:
- shutdown на одном из линков
-  Связь сохраняется → работает как задумано

 5. Настройка trunk на агрегированном интерфейсе:
```bash
Switch(config) interface port-channel 1
Switch(config-if) switchport mode trunk
```
---

## Динамическое агрегирование (с использованием LACP)

### Топология:
- 1x L3-коммутатор в центре
- 3x L2-коммутатора на периферии (Switch1–Switch3)

### Настройка на L3-коммутаторе:
```bash
# Первый EtherChannel
interface range fa0/1-2
 channel-protocol lacp
 channel-group 1 mode active

# Второй EtherChannel
interface range fa0/3-4
 channel-protocol lacp
 channel-group 2 mode active

# Третий EtherChannel
interface range fa0/5-6
 channel-protocol lacp
 channel-group 3 mode active
```

### Настройка на L2-коммутаторах (например, Switch1):
```bash
interface range fa0/1-2
 channel-protocol lacp
 channel-group 1 mode passive
```
Повторить с нужными group ID на Switch2 и Switch3

### Проверка состояния EtherChannel:
```bash
show etherchannel summary
show etherchannel
```

## Выводы
- EtherChannel:
  - Увеличивает пропускную способность
  - Обеспечивает отказоустойчивость
  - LACP — предпочтительный способ динамической агрегации
  - mode active + mode passive — рабочая комбинация
  - STP может заблокировать интерфейс при ошибке в конфигурации

**Важно: номер channel-group должен быть уникальным для каждого логического канала на устройстве**

---

## Отладка и ошибки

Проблема:
На Switch2 и Switch3 использован один и тот же channel-group → блокировка STP
```bash
# Повторная настройка с корректным group ID
interface fa0/3
 no channel-protocol
 no channel-group
```
