require 'json'
require 'digest'

pref = ENV['PREF']
basename = ENV['BASENAME']

# SHA256由来のハッシュ値を、53bit符号なし整数（JavaScriptで安全に扱える範囲）に縮小する
# これは、MVT以外でのFeature ID利用を想定したもので、下記2つの観点で実装している
# 1. JavaScriptで安全に扱える最大整数値(Number.MAX_SAFE_INTEGER = 2^53 - 1)を超えないようにする
# 2. OGR の int64（2^63 - 1）を超えないようにする
# 3. Tippecanoe の整数ID（int64）でオーバーフローを起こさないようにする
# - 64bitのハッシュからIDを生成するため一意性が高い
# - 53bit以下に収めることで、JavaScript でも安全に扱える
# - Tippecanoe や OGR（int64）でもオーバーフローを起こさない
# 可読性の高い ID 文字列（global_id）を元にSHA256 の先頭64bitを整数化し、
# その値を MAX_SAFE_INTEGER で剰余して、JavaScript・FGB・MVT すべてに対応可能な範囲の整数IDを返す
MAX_SAFE_INTEGER = (1 << 53) - 1  # => 9_007_199_254_740_991
def safe_id(str)
  Digest::SHA256.hexdigest(str)[0, 16].to_i(16) % MAX_SAFE_INTEGER
end

while gets
  f = JSON.parse($_)
  if f['properties'] && f['properties']['筆ID']
    uid_str = "#{pref}_#{basename}_#{f['properties']['筆ID']}"
    f['properties']['global_id'] = uid_str
    f['id'] = safe_id(uid_str)
  end
  f[:tippecanoe] = {
    :layer => 'fude',
    :minzoom => 14,
    :maxzoom => 16
  }
  print "\x1e#{JSON.dump(f)}\n"
end
