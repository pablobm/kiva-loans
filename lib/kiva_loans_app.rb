require 'sinatra/base'
require 'net/http'
require 'json'
require 'lib/sinatra/flash'
require 'lib/sinatra/content_for'

class KivaLoansApp < Sinatra::Base

  set :root, APP_ROOT
  set :static, true

  get '/' do
    user_id = params[:user_id]
    if user_id
      redirect "/#{user_id}"
    else
      @recent = retrieve_recent
      erb :index
    end
  end

  get '/favicon.ico' do
    raise Sinatra::NotFound
  end

  get '/:user_id' do |user_id|
    @user_id = user_id
    @loans, @paging = retrieve_loans(@user_id)
    if @loans
      erb :map
    else
      flash[:error] = "User #{user_id} does not exist"
      redirect '/'
    end
  end

  helpers do
    include Sinatra::ContentFor
    include Sinatra::Flash
    include Rack::Utils
    alias_method :h, :escape_html
  end


  def retrieve_loans(user_id)
    json_data = Net::HTTP.get URI.parse("http://api.kivaws.org/v1/lenders/#{h user_id}/loans.json")
    data = JSON.parse(json_data)
    if data['code'] && data['code'] == 'org.kiva.InvalidIdentifier'
      nil
    else
      [data['loans'], data['paging']]
    end
  end

  def retrieve_recent(limit = 10)
    json_data = Net::HTTP.get URI.parse("http://api.kivaws.org/v1/lending_actions/recent.json")
    actions = JSON.parse(json_data)['lending_actions']
    ret = []
    lender_ids = []
    while ret.size < 10 && ! actions.empty?
      action = actions.delete_at(rand(actions.size))
      lender_id = action['lender']['lender_id']
      unless lender_ids.include?(lender_id)
        lender_ids << lender_id
        ret << action
      end
    end
    ret
  end

end

