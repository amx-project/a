require 'json'

while gets
  f = JSON.parse($_)
  f[:tippecanoe] = {
    :layer => 'fude',
    :minzoom => 14,
    :maxzoom => 16
  }
  print "\x1e#{JSON.dump(f)}\n"
  pt = {
    :type => 'Feature',
    :tippecanoe => {
      :layer => 'daihyo',
      :minzoom => 2,
      :maxzoom => 13
    },
    :properties => {},
    :geometry => {
      :type => 'Point',
      :coordinates => [
        f['properties']['代表点経度'],
        f['properties']['代表点緯度']
      ]
    }
  }
  print "\x1e#{JSON.dump(pt)}\n"
end
