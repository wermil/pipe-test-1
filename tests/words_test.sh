#!/usr/bin/env bash
# Тест для scripts/words.sh. Повертає код 1, якщо хоч одна перевірка не пройшла.
set -uo pipefail

script="$(cd "$(dirname "$0")/.." && pwd)/scripts/words.sh"
fail=0

# check опис очікуване stdin [аргументи…]
check() {
  local desc="$1" expected="$2" input="$3"; shift 3
  local actual
  actual="$(printf '%b' "$input" | bash "$script" "$@")" || { echo "FAIL: $desc — скрипт завершився з помилкою"; fail=1; return; }
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
  out="$(bash "$script" "$@" </dev/null 2>"$err")"; code=$?
  if [ "$code" -eq 2 ] && [ -z "$out" ] && [ -s "$err" ]; then
    echo "OK: $desc"
  else
    echo "FAIL: $desc — код $code, stdout «$out», stderr «$(cat "$err")»"
    fail=1
  fi
  rm -f "$err"
}

check "три слова" "3" "" один два три
check "слова в одному аргументі" "2" "" "один два"
check "кілька пробілів і табуляція" "3" "" "  один   два	три  "
check "кирилиця і латиниця" "4" "" "один two" "три four"
check "порожній рядок-аргумент" "0" "" ""
check "* не розгортається" "1" "" "*"
check "аргументи важливіші за stdin" "1" "а б в" один

check "stdin без аргументів" "3" "один два\nтри"
check "порожній stdin" "0" ""
check "stdin лише з пробілів" "0" "  \n\t\n"

check "--unique а б а" "2" "" --unique а б а
check "--unique з урахуванням регістру" "2" "" --unique а А
check "--unique після тексту" "1" "" а а --unique
check "--unique зі stdin" "2" "а б а\nб" --unique
check "--unique з порожнім stdin" "0" "" --unique
check "-- завершує опції" "1" "" -- --unique
check "-- з --unique" "2" "" --unique -- --foo --foo а

check_invalid "--foo" --foo
check_invalid "--foo з текстом" один --foo два
check_invalid "--foo з --unique" --unique --foo

exit "$fail"
