class Formatter:
    """New abstraction layer added alongside a one-line fix."""

    def render(self, template, *args):
        return template.format(*args)
