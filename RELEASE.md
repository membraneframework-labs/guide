# Releasing guide

A guide on how to release guide.

## CI

The guide is published automatically by the CI.

- contents of `https://membrane.stream/guide` are taken from `landing` on branch `master`
- the guide is deployed from generated `docs` from branches in form `vX.X(-X)`, e.g. `v0.5` or `v0.5-dev` and become available under `https://membrane.stream.org/guide/vX.X(-X)`

## Publishing new version without bumping minor

Just add commits to a proper branch (e.g. `v0.5`). This might require merging from `master` to that branch

## Adding new guide version

- Add proper `versionNode` entry in `landing/docs_config.js`
- Change redirection url in `landing/index.html` if new version has to be default.
- Bump version in `mix.exs`
- Create and push branch `vX.X(-X)`
