def parse_flag(argv, name):
    """Return True if --<name> appears in argv."""
    return f"--{name}" in argv


def greet(name):
    return f"hello, {name}"


def main(argv):
    if parse_flag(argv, "shout"):
        return greet("world").upper()
    return greet("world")
