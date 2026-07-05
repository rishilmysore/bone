from slugify import slugify


def test_basic():
    assert slugify("Hello World") == "hello-world"


def test_collapses_repeated_separators():
    assert slugify("a  b") == "a-b"


def test_strips_edge_separators():
    assert slugify(" -Lead_and Trail- ") == "lead-and-trail"
