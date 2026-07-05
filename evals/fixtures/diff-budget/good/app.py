def parse_flag(argv, name):
    """Return True if --<name> appears in argv, bare or in --<name>=value form."""
    return any(a == f"--{name}" or a.startswith(f"--{name}=") for a in argv)


def greet(name):
    return f"hello, {name}"


def main(argv):
    if parse_flag(argv, "shout"):
        return greet("world").upper()
    return greet("world")
