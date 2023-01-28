pref = ENV['PREF']
File.open("#{pref}-list.tmp", 'w') {|w|
  Dir.glob("src/**/#{pref}*-*-*.zip").sort.each {|path|
    w.print "#{path}\n"
  }
}
system <<-EOS
parallel -P 7 --eta --line-buffer -a #{pref}-list.tmp \
ruby to_geojson.rb {}; \
rm #{pref}-list.tmp
EOS

