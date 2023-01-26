desc 'stream GeoJSON Text Sequence from src/*-*-*.zip'
task :stream do
  sh <<-EOS
ruby stream.rb
  EOS
end

desc 'create GeoJSON Text Sequence from src/*-*-*.zip'
task :geojsons do
  sh <<-EOS
ruby stream.rb > a.json
  EOS
end

desc 'create mbtiles'
task mbtiles: [:geojsons] do
  sh <<-EOS
tippecanoe \
-rg \
--drop-densest-as-needed \
--no-line-simplification \
-x 筆ID \
-x version \
-x 代表点緯度 \
-x 代表点経度 \
--minimum-zoom=2 \
--base-zoom=14 \
--maximum-zoom=16 \
--read-parallel \
--detect-shared-boarders \
-f -o a.mbtiles a.json
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

