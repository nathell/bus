base_url = window.location.href.replace(/[?].*/, '')
bus_stops = window.location.href.replace(/^[^?]+/, '').split(/[^0-9]+/).splice(1)
if bus_stops.length is 0 then bus_stops = [49250, 74480, 77322, 52623]
api_prefix = 'http://www.corsproxy.com/countdown.tfl.gov.uk/stopBoard/'
current = {}
current_flat = []

console.log bus_stops

time_to_arrival = (x) -> if x is 'due' then 0 else parseInt x

compare_arrivals = (a, b) -> time_to_arrival(a.estimatedWait) - time_to_arrival(b.estimatedWait)

draw_data = ->
  html = '<table>'
  _.each current_flat, (x) ->
    html += "<tr><td><b>#{x.routeName}</b> to <b>#{x.destination}</b></td><td>#{x.estimatedWait}</td><td>#{x.scheduledTime}</td></tr>"
  html += '</table>'
  $('#content').html html

update_view = ->
  current_flat = _.chain(current).values().pluck('arrivals').flatten(true).value().sort(compare_arrivals)
  draw_data current_flat

get_data = (x) ->
  $.ajax 
    url: api_prefix + x
    dataType: 'json'
    success: (data) -> current[x] = data; update_view()

update_data = ->
  _.each bus_stops, get_data
  setTimeout update_data, 15000

update_clock = ->
  $('#clock').text moment().format('HH:mm:ss')
  setTimeout update_clock, 1000
  
$ -> 
  update_data()
  update_clock()
  $('#exampleurl').attr('href', $('#exampleurl').text())