require 'json'

# mojxml-rs（Rust 実装）が出力する newline-delimited GeoJSON を
# daihyo レイヤー（代表点ポイント）NDJSON に変換する。
# 代表点経度 / 代表点緯度 から Point Feature を生成する。
# 旧 mojxml2geojson 方式の後処理は daihyo_legacy.rb を参照。

while gets
  f = JSON.parse($_)
  props = f['properties'] || {}
  pt = {
    :type => 'Feature',
    :tippecanoe => {
      :layer => 'daihyo',
      :minzoom => 2,
      :maxzoom => 13
    },
    :properties => {},
    :geometry => {
      :type => 'Point',
      :coordinates => [
        props['代表点経度'],
        props['代表点緯度']
      ]
    }
  }
  print "\x1e#{JSON.dump(pt)}\n"
end
