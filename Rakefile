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

desc 'create pmtiles'
task :pmtiles do
  files = Dir.glob('??.mbtiles').sort.filter {|path|
    !File.exist?("#{path}-journal")
  }
  sh <<-EOS
tile-join -f --no-tile-size-limit -o a.mbtiles #{files.join(' ')}; \
pmtiles convert a.mbtiles a.pmtiles
  EOS
end

desc 'create style.json'
task :style do
  sh <<-EOS
  EOS
end

desc 'host the site locally'
task host: [:pmtiles, :style] do
  sh <<-EOS
budo -d docs
  EOS
end

