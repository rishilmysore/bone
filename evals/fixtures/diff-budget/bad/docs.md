# demo

The application is now organized around an `App` class which owns argument
parsing, option handling with `--key=value` support, width bounding, and
message formatting through the new `Formatter` abstraction in `extra.py`.

`util.py` exposes `bound` (formerly `clamp`), `is_flag`, and `split_kv`.

Run via `main(argv)`, which constructs and runs an `App`.
