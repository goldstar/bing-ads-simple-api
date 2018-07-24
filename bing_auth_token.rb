require 'net/http'
require 'json'

csrf = Time.now.to_i.to_s
puts "Enter the Client ID (e.g. a85987f5-c4f7-1302-43e3-210ec8afd6ef) of that App you'd like auth tokens for: "
client_id = gets.chomp

redirect_uri = "https://login.live.com/oauth20_desktop.srf"
puts "Open the following URL in a browser, login and accept the terms. After which you'll be on a blank page.  Input the URL."

puts "https://login.live.com/oauth20_authorize.srf?client_id=#{client_id}&scope=bingads.manage&response_type=code&redirect_uri=#{redirect_uri}&state=#{csrf}"

puts "\nAre logging in (instructions above) what's the URL of the blank confirmation page?"
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
