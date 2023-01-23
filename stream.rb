require 'tmpdir'

def to_geojsons(path)
  Dir.mktmpdir do |dir|
    bn = File.basename(path, '.zip')
    system <<-EOS
unzip -d #{dir} #{path}; \
mojxml2geojson -e #{dir}/#{bn}.xml; \
ogr2ogr -f FlatGeobuf #{bn}.fgb #{dir}/#{bn}.geojson
    EOS
  end
end

Dir.glob('src/*-*-*.zip') {|path|
  to_geojsons(path)
}

