module Sinatra
  module HtmlHelper

    def link_to(title, link)
      %{<a href="#{link}">#{title}</a>}
    end

  end
end
