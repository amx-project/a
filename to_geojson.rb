require 'tmpdir'
require 'fileutils'

path = ARGV[0]
bn = File.basename(path, '.zip')  # {標準地域コード(市区町村コード)5桁}-{法務局コード4桁}-{連番}: ex)01101-4300-1
type = ENV['TYPE']
pref = ENV['PREF']

# ファイル数が多いため階層を分ける。{標準地域コード(市区町村コード)5桁}-{法務局コード4桁}でグルーピングする
group_key = bn.split('-')[0..1].join('-')

Dir.mktmpdir do |tmpdir|
  # 地図XMLを解凍 & GeoJSON 変換
  system <<-EOS
unzip -qq -d #{tmpdir} #{path}; \
mojxml2geojson -e #{tmpdir}/#{bn}.xml
  EOS

  geojson_path = "#{tmpdir}/#{bn}.geojson"

  # fudeレイヤー（ポリゴン）の場合、パイプラインにも流しつつ、geom利用のため加工済み出力を保存（NDJSON）する 
  if type == 'fude'
    # 出力ディレクトリ
    outdir = "/app/tmp/#{pref}/#{group_key}"
    FileUtils.mkdir_p(outdir)
    out_path = "#{outdir}/#{bn}.ndjson"

    system <<-EOS
cat #{geojson_path} | tippecanoe-json-tool | \
grep -v 任意座標 | BASENAME=#{bn} ruby fude.rb | tee #{out_path}
    EOS

# daihyoレイヤー（ポイント）の場合、そのままパイプラインに流す
  else
    system <<-EOS
cat #{geojson_path} | tippecanoe-json-tool | \
grep -v 任意座標 | BASENAME=#{bn} ruby #{type}.rb
    EOS
  end

end
