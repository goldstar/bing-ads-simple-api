require 'net/http'
require 'json'

csrf = Time.now.to_i.to_s
client_id = "a85887f5-c4f6-4512-95d3-220cd8bff6ef"  # Registered Goldstar App's id

redirect_uri = "https://login.live.com/oauth20_desktop.srf"
puts "Open the following URL in a browser, login and accept the terms. After which you'll be on a blank page.  Input the URL."

puts "https://login.live.com/oauth20_authorize.srf?client_id=#{client_id}&scope=bingads.manage&response_type=code&redirect_uri=#{redirect_uri}&state=#{csrf}"

puts "\nWhat the URL of the blank page?"
url = gets.chomp

# pull the code param from the query string
code = url.match(/code=([0-9A-Za-z\-]+)/)[1]

uri = URI('https://login.live.com/oauth20_token.srf')
response = Net::HTTP.post_form(uri,
  client_id: client_id,
  code: code,
  grant_type: 'authorization_code',
  redirect_uri: redirect_uri
)

authorization = JSON.parse(response.body)
authorization.each_pair do |key,value|
  puts "#{key}:\n#{value}\n"
end
puts "==========================================================="
response = Net::HTTP.post_form(uri,
  client_id: client_id,
  grant_type: 'refresh_token',
  refresh_token: authorization['refresh_token'],
  redirect_uri: redirect_uri
)

authorization = JSON.parse(response.body)
authorization.each_pair do |key,value|
  puts "#{key}:\n#{value}\n"
end
