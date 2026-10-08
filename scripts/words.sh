#!/usr/bin/env bash
# Рахує слова (розділені пробільними символами). Використання: words.sh [--unique] [--] [текст…]
# Без тексту в аргументах читає stdin. --unique — кількість унікальних слів з урахуванням регістру.
# Невідома опція (--foo) — повідомлення в stderr і код 2.
set -euo pipefail

unique=0
words=()

while [ $# -gt 0 ]; do
  case "$1" in
    --unique)
      unique=1
      shift
      ;;
    --)
      shift
      words+=("$@")
      break
      ;;
    --*)
      echo "Невідома опція: «$1» (підтримується --unique)" >&2
      exit 2
      ;;
    *)
      words+=("$1")
      shift
      ;;
  esac
done

text() {
  if [ ${#words[@]} -gt 0 ]; then
    printf '%s\n' "${words[*]}"
  else
    cat
  fi
}

split() {
  tr -s '[:space:]' '\n' | { grep -v '^$' || true; }
}

if [ "$unique" -eq 1 ]; then
  text | split | LC_ALL=C sort -u | wc -l | tr -d ' '
else
  text | split | wc -l | tr -d ' '
fi
