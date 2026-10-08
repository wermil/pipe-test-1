#!/usr/bin/env bash
# Тест для scripts/greet.sh. Повертає код 1, якщо хоч одна перевірка не пройшла.
set -uo pipefail

script="$(cd "$(dirname "$0")/.." && pwd)/scripts/greet.sh"
fail=0

check() {
  local desc="$1" expected="$2"; shift 2
  local actual
  actual="$(bash "$script" "$@")" || { echo "FAIL: $desc — скрипт завершився з помилкою"; fail=1; return; }
  if [ "$actual" = "$expected" ]; then
    echo "OK: $desc"
  else
    echo "FAIL: $desc — очікувалось «$expected», отримано «$actual»"
    fail=1
  fi
}

check_invalid() {
  local desc="$1"; shift
  local out err code
  err="$(mktemp)"
  out="$(bash "$script" "$@" 2>"$err")"; code=$?
  if [ "$code" -eq 2 ] && [ -z "$out" ] && [ -s "$err" ]; then
    echo "OK: $desc"
  else
    echo "FAIL: $desc — код $code, stdout «$out», stderr «$(cat "$err")»"
    fail=1
  fi
  rm -f "$err"
}

check "з ім'ям" "Привіт, Оля!" "Оля"
check "без аргументу" "Привіт, світ!"

check "ранок" "Доброго ранку, Оля!" --hour 7 "Оля"
check "день" "Доброго дня, Оля!" --hour 13 "Оля"
check "вечір" "Доброго вечора, Оля!" --hour 20 "Оля"
check "ніч" "Доброї ночі, Оля!" --hour 2 "Оля"
check "--hour після імені" "Доброго вечора, Оля!" "Оля" --hour 18
check "--hour без імені" "Доброго ранку, світ!" --hour 5

check_invalid "година -1" --hour -1 "Оля"
check_invalid "година 24" --hour 24 "Оля"
check_invalid "година abc" --hour abc "Оля"
check_invalid "--hour без значення" "Оля" --hour

exit "$fail"
