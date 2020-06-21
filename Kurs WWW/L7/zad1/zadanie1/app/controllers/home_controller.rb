class HomeController < ApplicationController
    def index
    end

    def html
        render html: "html"
    end

    def json
        render json: "json"
    end

    def text
        render plain: "text"
    end

    def xml
        render :xml => {:key => "Hello"}.to_xml
    end


end
