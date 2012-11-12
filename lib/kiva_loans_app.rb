require 'sinatra/base'
require 'net/http'
require 'multi_json'

require 'sinatra/flash'
require 'sinatra/content_for'
require 'sinatra/html_helper'
require 'kiva_loans/loan'

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
    include Sinatra::HtmlHelper
    include Rack::Utils
    alias_method :h, :escape_html
  end


  def retrieve_loans(user_id)
    json_data = Net::HTTP.get URI.parse("http://api.kivaws.org/v1/lenders/#{h user_id}/loans.json")
    data = MultiJson.decode(json_data)
    if data['code'] && data['code'] == 'org.kiva.InvalidIdentifier'
      nil
    else
      [data['loans'], data['paging']]
    end
  end

  def retrieve_recent(limit = 10)
    json_data = Net::HTTP.get URI.parse("http://api.kivaws.org/v1/lending_actions/recent.json")
    actions = MultiJson.decode(json_data)['lending_actions']
    ret = []
    lender_ids = []
    while ret.size < 10 && ! actions.empty?
      action = Loan.new(actions.delete_at(rand(actions.size)))
      unless lender_ids.include?(action.lender_id)
        lender_ids << action.lender_id
        ret << action
      end
    end
    ret
  end

end

