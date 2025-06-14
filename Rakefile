# Range of prefectures based on environment variables
def pref_range
  start_pref = ENV['START_PREF'].to_i
  end_pref = ENV['END_PREF'].to_i
  (start_pref..end_pref).map { |i| sprintf('%02d', i) }
end

desc 'create mbtiles'
task :mbtiles do
  pref_range.each do |pref|
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
-f -o output/#{pref}-daihyo.mbtiles; \
TYPE=fude PREF=#{pref} ruby stream.rb | \
tippecanoe \
--quiet \
-x version \
-x 代表点緯度 \
-x 代表点経度 \
--minimum-zoom=14 \
--maximum-zoom=16 \
-f -o output/#{pref}-fude.mbtiles; \
tile-join -f -o output/#{pref}.mbtiles output/#{pref}-fude.mbtiles output/#{pref}-daihyo.mbtiles;
    EOS
  end
end

# Get the list of filenames for the target {prefecture_code}.mbtiles
# @return [Array<String>] list of filenames
def files
  list = Dir.glob('output/??.mbtiles').sort.filter {|path|
    !File.exist?("#{path}-journal")
  }
  list
end

desc 'create pmtiles'
task :pmtiles do
  sh <<-EOS
tile-join -f --no-tile-size-limit \
--minimum-zoom=14 --maximum-zoom=16 \
-o output/a-fude.mbtiles #{files.join(' ')}; \
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
-f -o output/a-daihyo.mbtiles; \
tile-join -f --no-tile-size-limit -o output/amx-a_all.mbtiles output/a-fude.mbtiles output/a-daihyo.mbtiles; \
pmtiles convert output/amx-a_all.mbtiles output/amx-a_all.pmtiles
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

