require 'sinatra/base'
require 'net/http'
require 'json'
require 'lib/sinatra_flash'

class KivaLoansApp < Sinatra::Base

  include SinatraFlash

  get '/' do
    user_id = params[:user_id]
    if user_id
      redirect "/#{user_id}"
    else
      erb :index
    end
  end

  get '/:user_id' do |user_id|
    @user_id = user_id
    @loans = retrieve_loans(@user_id)
    if @loans
      erb :map
    else
      flash[:error] = "User #{user_id} does not exist"
      redirect '/'
    end
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end


  def retrieve_loans(user_id)
    json_data = Net::HTTP.get URI.parse("http://api.kivaws.org/v1/lenders/#{h user_id}/loans.json")
    data = JSON.parse(json_data)
    if data['code'] && data['code'] == 'org.kiva.InvalidIdentifier'
      nil
    else
      data['loans']
    end
  end
end
