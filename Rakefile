desc 'create GeoJSON Text Sequence from src/*-*-*.zip'
task :stream do
  sh <<-EOS
ruby stream.rb
  EOS
end

desc 'create mbtiles'
task :mbtiles do
  sh <<-EOS
  EOS
end

desc 'create pmtiles'
task pmtiles: [:mbtiles] do
  sh <<-EOS
pmtiles convert tiles.mbtiles docs/tiles.pmtiles
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

