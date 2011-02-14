class MainController < ApplicationController
	def index
	@url_linktext = "login"
    @poster = Poster.new
	end
end