require 'sinatra/base'
require 'net/http'
require 'json'

class KivaLoansApp < Sinatra::Base
  get '/' do
    @user_id = params[:user_id]
    if @user_id
      @loans = retrieve_loans(@user_id)
      erb :map
    else
      erb :index
    end
  end
end


def retrieve_loans(user_id)
  json_data = Net::HTTP.get URI.parse("http://api.kivaws.org/v1/lenders/#{user_id}/loans.json")
  data = JSON.parse(json_data)
  return data['loans']
end

