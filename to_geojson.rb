path = ARGV[0]
bn = File.basename(path, '.zip')
dir = ENV['DIR']

system <<-EOS
unzip -qq -d #{dir} #{path}; \
mojxml2geojson -e #{dir}/#{bn}.xml; \
cat #{dir}/#{bn}.geojson | tippecanoe-json-tool | \
grep -v 任意座標 | ruby split.rb
EOS

