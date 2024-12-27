# version-check
Checks if version is upgraded when updating the repository. Prevents creating a new release with an outdated version in the code somewhere. 

Pass regex for version strings (optional) and a filename that contains the version (mandetory) to test if it has been updated. The underlying logic: test if version currently in the code (for example in a PR) does not yet exist in the current git tags.
  version-update:
    name: Test if version is updated
    runs-on: ubuntu-latest
    steps:
      - name: Test
        uses: TimoKats/version-check@main
        with:
          filename: 'commands/lib/consts.go'
### Set version format regex

I use ruby regex (rubular) for the version strings. The default value is `/[v]\d.\d.\d/` (which means e.g. v1.0.0). You can test your own formats at: https://rubular.com/.

### Usage in yaml
This is an example of calling the custom action from another yaml. Note, instead of `main` you can also refer to a tagged version (like `v1`)

```yaml
  version-update:
    name: Test if version is updated
    runs-on: ubuntu-latest
    steps:
      - name: Test
        uses: TimoKats/version-check@main
        with:
          filename: 'commands/lib/consts.go'
```
