#!/usr/bin/env bash
set -euo pipefail

for i in $(seq 0 $(($(nproc)-1))); do
    echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done

echo off > /sys/devices/system/cpu/smt/control