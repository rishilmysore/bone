import re


def slugify(text):
    """Lowercase; whitespace/underscores/hyphens collapse to one hyphen; edges stripped."""
    text = text.strip().lower()
    text = re.sub(r"[\s_-]+", "-", text)
    return text.strip("-")
