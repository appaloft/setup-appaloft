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

appaloft_path="$(command -v appaloft)"
if [[ -z "$appaloft_path" ]]; then
  echo "The Appaloft CLI was installed, but appaloft was not found on PATH." >&2
  exit 1
fi

appaloft version

echo "appaloft-path=${appaloft_path}" >>"$GITHUB_OUTPUT"
