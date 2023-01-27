desc 'stream fude GeoJSON Text Sequence from src/*-*-*.zip'
task :fude do
  sh <<-EOS
TYPE=fude ruby stream.rb
  EOS
end

desc 'stream daihyo GeoJSON Text Sequence from src/*-*-*.zip'
task :daihyo do
  sh <<-EOS
TYPE=daihyo ruby stream.rb
  EOS
end

desc 'create mbtiles'
task :mbtiles do
  sh <<-EOS
rake daihyo | \
tippecanoe \
--quiet \
--drop-densest-as-needed \
-x 筆ID \
-x version \
-x 代表点緯度 \
-x 代表点経度 \
--minimum-zoom=2 \
--maximum-zoom=13 \
-f -o daihyo.mbtiles; \
rake fude | \
tippecanoe \
--quiet \
-x 筆ID \
-x version \
-x 代表点緯度 \
-x 代表点経度 \
--minimum-zoom=14 \
--maximum-zoom=16 \
-f -o fude.mbtiles; \
tile-join -f -o a.mbtiles fude.mbtiles daihyo.mbtiles
  EOS
end

desc 'create pmtiles'
task pmtiles: [:mbtiles] do
  sh <<-EOS
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

