#!/usr/bin/env bash
# Виводить привітання. Використання: greet.sh [--hour N] [ім'я]  (без імені — «світ»)
# --hour N (0–23) — привітання за часом доби; невалідна година — stderr і код 2.
set -euo pipefail

source "$(dirname "$0")/lib/daypart.sh"

name="світ"
hour=""
has_hour=0

while [ $# -gt 0 ]; do
  case "$1" in
    --hour)
      if [ $# -lt 2 ]; then
        echo "Опція --hour потребує значення (0–23)" >&2
        exit 2
      fi
      hour="$2"
      has_hour=1
      shift 2
      ;;
    *)
      name="$1"
      shift
      ;;
  esac
done

if [ "$has_hour" -eq 0 ]; then
  printf 'Привіт, %s!\n' "$name"
  exit 0
fi

part="$(daypart "$hour")" || exit 2

case "$part" in
  morning) greeting="Доброго ранку" ;;
  day)     greeting="Доброго дня" ;;
  evening) greeting="Доброго вечора" ;;
  *)       greeting="Доброї ночі" ;;
esac
printf '%s, %s!\n' "$greeting" "$name"
