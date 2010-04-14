#! /usr/bin/env lua

function get_race()
  print 'content-type: text/plain\n'

  print '<insert race here>'
end

function show_index()
  print 'content-type: text/plain\n'

  print('QUERY_STRING = "' .. os.getenv('QUERY_STRING') .. '"')
end

function submit_race()
  print '<submit race please>'
end

if os.getenv('REQUEST_METHOD') == 'GET' then
  if os.getenv('QUERY_STRING') == 'get-race' then
    get_race()
  else
    show_index()
  end
else
  submit_race()
end
