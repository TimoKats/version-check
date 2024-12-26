# version-check
Checks if version is upgraded when updating the repository. Pass regex for version strings and a filename to test if it has been updated.

## Set version format regex

I use ruby regex (rubular) for the version strings. The default value is `/[v]\d.\d.\d/` (which means e.g. v1.0.0). You can test your own formats at: https://rubular.com/.
