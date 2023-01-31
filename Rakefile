desc 'create mbtiles'
task :mbtiles do
  1.upto(47) do |i|
    pref = sprintf('%02d', i) 
    next if File.exist?("#{pref}.mbtiles")
    $stderr.print "#{Time.now}: #{pref}\n"
    sh <<-EOS
TYPE=daihyo PREF=#{pref} ruby stream.rb | \
tippecanoe \
--quiet \
--drop-densest-as-needed \
-x 筆ID \
-x version \
-x 代表点緯度 \
-x 代表点経度 \
--minimum-zoom=2 \
--maximum-zoom=13 \
-f -o #{pref}-daihyo.mbtiles; \
TYPE=fude PREF=#{pref} ruby stream.rb | \
tippecanoe \
--quiet \
-x 筆ID \
-x version \
-x 代表点緯度 \
-x 代表点経度 \
--minimum-zoom=14 \
--maximum-zoom=16 \
-f -o #{pref}-fude.mbtiles; \
tile-join -f -o #{pref}.mbtiles #{pref}-fude.mbtiles #{pref}-daihyo.mbtiles; \
rm #{pref}-fude.mbtiles #{pref}-daihyo.mbtiles
    EOS
  end
end

def files
  list = Dir.glob('??.mbtiles').sort.filter {|path|
    !File.exist?("#{path}-journal")
  }
  list
end

desc 'create pmtiles'
task :pmtiles do
  sh <<-EOS
tile-join -f --no-tile-size-limit \
--minimum-zoom=14 --maximum-zoom=16 \
-o a-fude.mbtiles #{files.join(' ')}; \
(parallel -P 2 --eta --line-buffer \
"tippecanoe-decode \
-Z 13 -z 13 {} | tippecanoe-json-tool" \
::: #{files.join(' ')}) | \
tippecanoe \
-r3 \
--drop-densest-as-needed \
--minimum-zoom=2 \
--maximum-zoom=13 \
--layer=daihyo \
-f -o a-daihyo.mbtiles; \
tile-join -f --no-tile-size-limit -o a.mbtiles a-fude.mbtiles a-daihyo.mbtiles; \
pmtiles convert a.mbtiles a.pmtiles
  EOS
end

desc 'create style.json'
task :style do
  sh <<-EOS
charites build style.yml docs/style.json
  EOS
end

desc 'host the site locally'
task :host do
  sh <<-EOS
budo -d docs
  EOS
end

desc 'rebuid daihyo tiles'
task :rebuild do
  sh <<-EOS
echo #{files}
  EOS
end

