require 'tmpdir'

Dir.mktmpdir do |dir|
  File.open("#{dir}/list", 'w') {|w|
    Dir.glob('src/*-*-*.zip').each {|path|
      w.print "#{path}\n"
    }
  }
  system <<-EOS
DIR=#{dir} parallel --eta --line-buffer -a #{dir}/list \
ruby to_geojson.rb {}
  EOS
end

