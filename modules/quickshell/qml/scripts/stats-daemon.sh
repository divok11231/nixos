#!/usr/bin/env bash

PREV_TOTAL=0
PREV_IDLE=0

while true; do
  # Calculate CPU Usage
  read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
  total=$((user+nice+system+idle+iowait+irq+softirq+steal))
  idl=$((idle+iowait))
  diff_total=$((total-PREV_TOTAL))
  diff_idle=$((idl-PREV_IDLE))
  if [ $diff_total -eq 0 ]; then diff_total=1; fi
  cpu_usage=$((100*(diff_total-diff_idle)/diff_total))
  PREV_TOTAL=$total
  PREV_IDLE=$idl

  # Calculate RAM Usage
  while read -r name value unit; do
    if [ "$name" = "MemTotal:" ]; then mem_total=$value; fi
    if [ "$name" = "MemAvailable:" ]; then mem_avail=$value; fi
  done < /proc/meminfo
  mem_usage=$((100*(mem_total-mem_avail)/mem_total))

  # Calculate CPU temperature (degrees Celsius)
  temp=0
  for zone in /sys/class/hwmon/hwmon*; do
    [ -f "$zone/name" ] || continue
    case "$(cat "$zone/name")" in
      coretemp)
        for lbl in "$zone"/temp*_label; do
          [ -f "$lbl" ] || continue
          [ "$(cat "$lbl")" = "Package id 0" ] || continue
          temp=$(( $(cat "${lbl%_label}_input") / 1000 ))
          break 2
        done
        ;;
      k10temp) # AMD fallback
        [ -f "$zone/temp1_input" ] || continue
        temp=$(( $(cat "$zone/temp1_input") / 1000 ))
        break
        ;;
    esac
  done

  echo "$cpu_usage $mem_usage $temp"

  # Sleep for 2 seconds to reduce background CPU overhead
  sleep 2
done
