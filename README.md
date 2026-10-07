# pipe-test-1

## Привітання

Скрипт `scripts/greet.sh` виводить привітання для переданого імені; без аргументу вітає «світ».

```sh
$ bash scripts/greet.sh Оля
Привіт, Оля!
$ bash scripts/greet.sh
Привіт, світ!
```

Тест: `bash tests/greet_test.sh` (код 0 — успіх, 1 — помилка).