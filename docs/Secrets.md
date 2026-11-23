<!-- Registry of GitHub Actions repository secrets used by Archx CI or testing workflows. -->

# Repository Secrets Registry

Currently **zero custom secrets** are required; `.github/workflows/ci.yml` uses only GitHub's built-in `GITHUB_TOKEN` (`permissions: contents: write`) to commit `ci/logs/`, `ci/out/`, and `ci/test-history/`.

| Secret Name | Purpose | Required By | Status |
|---|---|---|---|
| *(None yet)* | Add any future external test/benchmark API keys here before referencing them in `.github/workflows/`. | — | — |
