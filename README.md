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

### 地図XML変換（mojxml-rs / Rust）

`rake mbtiles` は地図XML→GeoJSON 変換に Rust 実装の
[mojxml-rs](https://github.com/KotobaMedia/mojxml-rs)（MIT License）を使う。
旧 `mojxml2geojson` 方式は `rake mbtiles_legacy` で利用できる（フォールバック・比較用）。
両者で tippecanoe / tile-join のオプションは同一。

```bash
podman compose run --rm tile-builder-mojxml rake mbtiles          # mojxml-rs 方式（既定）
podman compose run --rm tile-builder-mojxml rake mbtiles_legacy   # mojxml2geojson 方式
```

mojxml-rs 方式のメモ:
- pref 単位で zip 群を一括・並列変換し、newline-delimited GeoJSON を出力する（`tippecanoe-json-tool` での分割は不要）。
- 任意座標系・地区外・別図はデフォルトで除外される（`-a` / `-A` / `-c` で変更可）。
- 筆IDの属性名が `筆id`（小文字）。`version` 属性は出力されない。`fude.rb` で `筆ID` へ正規化する。
- `global_id` は `{pref}_{市区町村コード}_{筆ID}` から決定的に生成する（`fude_legacy.rb` の `{pref}_{basename}_{筆ID}` とは ID 値が変わる）。
- mojxml-rs のバージョンは Dockerfile の `MOJXML_RS_VERSION`（既定 `v0.3.0`）で固定。

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
