# setup-appaloft

Install the Appaloft CLI in GitHub Actions.

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: appaloft/setup-appaloft@v1
        with:
          version: latest
      - run: appaloft version
```

## Version Selection

`version: latest` installs `@appaloft/cli@latest` from npm. Pin a CLI release when a workflow must
be reproducible:

```yaml
- uses: appaloft/setup-appaloft@v1
  with:
    version: v0.1.0
```

The leading `v` is accepted for convenience and is stripped before npm installation.

## Inputs

| Input | Default | Description |
| --- | --- | --- |
| `version` | `latest` | Appaloft CLI version or npm dist-tag. |
| `package` | `@appaloft/cli` | npm package that provides the CLI. |
| `registry-url` | `https://registry.npmjs.org` | npm registry URL. |

## Outputs

| Output | Description |
| --- | --- |
| `appaloft-path` | Absolute path to the installed `appaloft` executable. |

## Release Model

This action is a stable installer wrapper. Normal Appaloft CLI releases update npm packages in the
main Appaloft release flow; this action only needs a new action release when installer behavior
changes.
