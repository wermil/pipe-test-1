#!/usr/bin/env bash
# Тест для scripts/lib/daypart.sh. Повертає код 1, якщо хоч одна перевірка не пройшла.
set -uo pipefail

source "$(cd "$(dirname "$0")/.." && pwd)/scripts/lib/daypart.sh"
fail=0

check() {
  local hour="$1" expected="$2" actual
  actual="$(daypart "$hour")" || { echo "FAIL: година $hour — код $?"; fail=1; return; }
  if [ "$actual" = "$expected" ]; then
    echo "OK: година $hour → $expected"
  else
    echo "FAIL: година $hour — очікувалось «$expected», отримано «$actual»"
    fail=1
  fi
}

check_invalid() {
  local hour="$1" out err code
  err="$(mktemp)"
  out="$(daypart "$hour" 2>"$err")"; code=$?
  if [ "$code" -eq 2 ] && [ -z "$out" ] && [ -s "$err" ]; then
    echo "OK: невалідна година «$hour» → код 2 і stderr"
  else
    echo "FAIL: невалідна година «$hour» — код $code, stdout «$out», stderr «$(cat "$err")»"
    fail=1
  fi
  rm -f "$err"
}

check 0 night
check 4 night
check 5 morning
check 08 morning
check 11 morning
check 12 day
check 17 day
check 18 evening
check 22 evening
check 23 night

check_invalid -1
check_invalid 24
check_invalid abc
check_invalid ""
check_invalid 100

exit "$fail"
