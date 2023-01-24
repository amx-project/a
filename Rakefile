desc 'stream GeoJSON Text Sequence from src/*-*-*.zip'
task :stream do
  sh <<-EOS
ruby stream.rb
  EOS
end

desc 'create GeoJSON Text Sequence from src/*-*-*.zip'
task :geojsons do
  sh <<-EOS
ruby stream.rb > a.geojsons
  EOS
end

desc 'create FlatGeobuf from GeoJSON Text Sequence'
task fgb: [:geojsons] do
  sh <<-EOS
rm -f a.fgb; \
ogr2ogr -overwrite -f FlatGeobuf \
a.fgb a.geojsons
  EOS
end

desc 'create mbtiles'
task mbtiles: [:fgb] do
  sh <<-EOS
tippecanoe --quiet \
--drop-densest-as-needed \
-f -o a.mbtiles a.geojsons
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

