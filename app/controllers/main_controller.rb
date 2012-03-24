class MainController < ApplicationController
	def index
    @url_linktext = "login"
    @poster = Poster.new
    #logs = Log.find :all, :conditions => ["created_at < ?", Time.now - 30*24*60*60 ]
	#logs = Log.order("created_on DESC").limit(1000).all
	logs = Log.find :all, :order => "created_at DESC", :limit => 500
    posters = []
    logs.each {|log| posters = posters | [log.poster]}
    @posters = posters.map {|poster|
      {:id => poster.id, :query => poster.query, :count => poster.logs.size, :created_at => poster.created_at}
    }
    @posters.sort! {|b,a| a[:count] - b[:count]}
    @posters = @posters[0..9]

    @recent = Poster.find :all, :order => 'updated_at desc', :limit => 10
	end
end