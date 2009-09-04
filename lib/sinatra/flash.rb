# Took the code at http://blog.kabisa.nl/2009/02/16/flash-messages-for-sinatra/
# and made it into a mixin
module Sinatra
  module Flash

    def self.included(base)
      base.module_eval do
        enable :sessions
        alias_method :erb_without_flash, :erb
        alias_method :erb, :erb_with_flash
      end
    end

    def flash
      session[:flash] = {} if session[:flash] && session[:flash].class != Hash
      session[:flash] ||= {}
    end

    def erb_with_flash(*args)
      ret = erb_without_flash(*args)
      flash.clear
      ret
    end

  end
end

