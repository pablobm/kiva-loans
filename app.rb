require 'rubygems'
require 'sinatra'
require 'net/http'
require 'json'

get '/' do
  json_data = Net::HTTP.get URI.parse('http://api.kivaws.org/v1/lenders/pablobm/loans.json')
  data = JSON.parse(json_data)
  loans = data['loans']
end
