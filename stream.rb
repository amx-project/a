File.open("list.tmp", 'w') {|w|
  Dir.glob('src/**/*-*-*.zip').sort.each {|path|
    w.print "#{path}\n"
  }
}
system <<-EOS
parallel -P 4 --eta --line-buffer -a list.tmp \
ruby to_geojson.rb {}
EOS

