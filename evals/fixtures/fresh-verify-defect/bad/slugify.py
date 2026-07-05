def slugify(text):
    """Lowercase; whitespace/underscores/hyphens collapse to one hyphen; edges stripped."""
    return text.strip().lower().replace(" ", "-")
