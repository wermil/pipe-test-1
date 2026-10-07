#!/usr/bin/env bash
# Виводить привітання. Використання: greet.sh [ім'я]  (без аргументу — «світ»)
set -euo pipefail

name="${1:-світ}"
printf 'Привіт, %s!\n' "$name"
