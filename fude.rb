require 'json'
require 'digest'

# mojxml-rs（Rust 実装）が出力する newline-delimited GeoJSON を
# fude レイヤー（ポリゴン）NDJSON に変換する。
# 旧 mojxml2geojson 方式の後処理は fude_legacy.rb を参照。
#
# mojxml-rs の出力特性
# - 筆ID の属性名が「筆id」（小文字）になる → 「筆ID」へ正規化する
# - version 属性は出力されない
# - 任意座標系・地区外・別図はデフォルトで出力されない（grep -v 任意座標 が不要）

pref = ENV['PREF']

# SHA256由来のハッシュ値を、53bit符号なし整数（JavaScriptで安全に扱える範囲）に縮小する。
# MVT(uint64) / OGR(int64) / JavaScript(Number.MAX_SAFE_INTEGER) のいずれでも安全に扱える ID を返す。
MAX_SAFE_INTEGER = (1 << 53) - 1  # => 9_007_199_254_740_991
def safe_id(str)
  Digest::SHA256.hexdigest(str)[0, 16].to_i(16) % MAX_SAFE_INTEGER
end

while gets
  f = JSON.parse($_)
  props = f['properties']
  if props
    fude_id = props['筆ID'] || props['筆id']
    if fude_id
      props.delete('筆id')
      props['筆ID'] = fude_id

      # mojxml-rs は zip 群を一括変換するためファイル名（連番）を属性に持たない。
      # global_id は pref・市区町村コード・筆ID から決定的に生成し、pref 内で一意にする。
      uid_str = "#{pref}_#{props['市区町村コード']}_#{fude_id}"
      props['global_id'] = uid_str
      f['id'] = safe_id(uid_str)
    end
  end
  f[:tippecanoe] = {
    :layer => 'fude',
    :minzoom => 14,
    :maxzoom => 16
  }
  print "\x1e#{JSON.dump(f)}\n"
end
