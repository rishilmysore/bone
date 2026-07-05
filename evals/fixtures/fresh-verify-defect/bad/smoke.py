"""The executor's own check — happy path only. Exits 0 on the planted defect too."""
from slugify import slugify

assert slugify("Hello World") == "hello-world"
print("smoke ok")
