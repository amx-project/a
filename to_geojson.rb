require 'tmpdir'

path = ARGV[0]
bn = File.basename(path, '.zip')

type = ENV['TYPE']

Dir.mktmpdir do |tmpdir|
  system <<-EOS
unzip -qq -d #{tmpdir} #{path}; \
mojxml2geojson -e #{tmpdir}/#{bn}.xml; \
cat #{tmpdir}/#{bn}.geojson | tippecanoe-json-tool | \
grep -v 任意座標 | ruby #{type}.rb
  EOS
end

