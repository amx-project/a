# amx-a
## Overview
[amx-a](https://github.com/amx-project/a)を動かすためには環境構築が必要であり、それを維持しやすいようにコンテナ化する。

### build

```bash
podman compose build
```

### run & debug

```bash
podman compose up
```

#### debug

```bash
podman compose run --rm --entrypoint /bin/bash tile-builder-mojxml
```

- Test run: `stream.rb`

```bash
# PREF=01 TYPE=daihyo ruby stream.rb
```

- Test run:`rake` task
```bash
podman compose run --rm tile-builder-mojxml rake mbtiles
podman compose run --rm tile-builder-mojxml rake pmtiles
podman compose run --rm tile-builder-mojxml rake style
```

### Tips
#### for generation the `Gemfile.lock`

```bash
podman run --rm -v ".:/usr/src/app" -w /usr/src/app ruby:3.1-slim bundle install
```

〰️〰️〰️〰️〰️〰️〰️〰️〰️〰️〰️

Implementation of https://github.com/amx-project/0/issues/4

## Demo
https://amx-project.github.io/a

### PMTiles location on IPFS
QmTZHWMAnRC5zNiNvdVuTDacThKkj4jKbwsZtKQkAC4R69

## Document
https://github.com/amx-project/a-spec

## What is behind the repository name?
[Most UNIX C compilers link executables by default to a file called "a.out".](https://stackoverflow.com/questions/1218262/why-do-some-compilers-use-a-out-as-the-default-name-for-executables) That is why. 
