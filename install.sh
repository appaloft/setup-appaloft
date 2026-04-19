#!/usr/bin/env bash
set -euo pipefail

package_name="${INPUT_PACKAGE:-@appaloft/cli}"
version="${INPUT_VERSION:-latest}"
registry_url="${INPUT_REGISTRY_URL:-https://registry.npmjs.org}"

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is required before running appaloft/setup-appaloft." >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required before running appaloft/setup-appaloft." >&2
  exit 1
fi

case "$version" in
  "" | latest)
    package_spec="${package_name}@latest"
    ;;
  v[0-9]*)
    package_spec="${package_name}@${version#v}"
    ;;
  *)
    package_spec="${package_name}@${version}"
    ;;
esac

echo "Installing ${package_spec} from ${registry_url}"
npm install --global "$package_spec" --registry "$registry_url"

installed_version="$(
  npm list --global "$package_name" --depth=0 --json |
    node -e '
      let input = "";
      process.stdin.on("data", (chunk) => {
        input += chunk;
      });
      process.stdin.on("end", () => {
        const packageName = process.argv[1];
        const parsed = JSON.parse(input);
        const version = parsed.dependencies?.[packageName]?.version;
        if (version) {
          process.stdout.write(version);
        }
      });
    ' "$package_name"
)"

if [[ -n "$installed_version" && -z "${APPALOFT_APP_VERSION:-}" ]]; then
  export APPALOFT_APP_VERSION="$installed_version"

  if [[ -n "${GITHUB_ENV:-}" ]]; then
    echo "APPALOFT_APP_VERSION=${installed_version}" >>"$GITHUB_ENV"
  fi
fi

appaloft_path="$(command -v appaloft)"
if [[ -z "$appaloft_path" ]]; then
  echo "The Appaloft CLI was installed, but appaloft was not found on PATH." >&2
  exit 1
fi

appaloft version

echo "appaloft-path=${appaloft_path}" >>"$GITHUB_OUTPUT"
