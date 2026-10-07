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

check "з ім'ям" "Привіт, Оля!" "Оля"
check "без аргументу" "Привіт, світ!"

exit "$fail"
