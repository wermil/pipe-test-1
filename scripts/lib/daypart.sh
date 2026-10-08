#!/usr/bin/env bash
# Період доби за годиною. Підключення: source scripts/lib/daypart.sh
# daypart ГОДИНА — виводить morning (5–11), day (12–17), evening (18–22) або night (інакше).
# Невалідна година (не ціле 0–23) — повідомлення в stderr і код 2.

daypart() {
  local hour="${1-}"
  if ! [[ "$hour" =~ ^[0-9]{1,2}$ ]] || (( 10#$hour > 23 )); then
    printf 'Невалідна година: «%s» (очікується ціле число 0–23)\n' "$hour" >&2
    return 2
  fi
  hour=$((10#$hour))
  if (( hour >= 5 && hour <= 11 )); then
    echo morning
  elif (( hour >= 12 && hour <= 17 )); then
    echo day
  elif (( hour >= 18 && hour <= 22 )); then
    echo evening
  else
    echo night
  fi
}
