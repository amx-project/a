require 'json'

while gets
  f = JSON.parse($_)
  f[:tippecanoe] = {
    :layer => 'fude',
    :minzoom => 14,
    :maxzoom => 16
  }
  print "\x1e#{JSON.dump(f)}\n"
end
