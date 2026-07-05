from extra import Formatter
from util import bound, is_flag, split_kv


class App:
    """Drive-by rewrite: the flag fix arrived inside a restructuring nobody asked for."""

    def __init__(self, argv):
        self.argv = list(argv)
        self.formatter = Formatter()

    def flag(self, name):
        return any(is_flag(a, name) for a in self.argv)

    def option(self, name, default=None):
        for a in self.argv:
            key, value = split_kv(a)
            if key == f"--{name}" and value is not None:
                return value
        return default

    def greet(self, name):
        return self.formatter.render("hello, {}", name)

    def run(self):
        width = bound(int(self.option("width", "80")), 20, 200)
        message = self.greet("world")[:width]
        if self.flag("shout"):
            return message.upper()
        return message


def main(argv):
    return App(argv).run()
