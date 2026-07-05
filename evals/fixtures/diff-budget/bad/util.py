def bound(n, lo, hi):
    """Renamed from clamp during the drive-by; callers elsewhere now broken."""
    return max(lo, min(hi, n))


def is_flag(arg, name):
    return arg == f"--{name}" or arg.startswith(f"--{name}=")


def split_kv(arg):
    if "=" in arg:
        key, _, value = arg.partition("=")
        return key, value
    return arg, None
