class MainController < ApplicationController
	def index
    @url_linktext = "login"
    @poster = Poster.new
#    logs = Log.find :all, :conditions => ["created_at > ?", Time.now - 7*24*60*60 ]
    logs = Log.find :all, :order => 'created_at desc', :limit => 1000
    posters = []
    
#    logs.each {|log| posters = posters | [log.poster]}
  logs.each {|log| posters << log.poster};   posters.uniq!
    @posters = posters.map {|poster|
      {:id => poster.id, 
  :query => poster.query, 
  :count => logs.select{|x| x.poster == poster }.size, 
  :created_at => poster.created_at}
    }
    @posters.sort! {|b,a| a[:count] - b[:count]}
   @posters = @posters[0..9]
    
    
#    logs.each {|log| 
#      poster = log.poster
#      if p = posters.assoc(poster.id) 
#        p[1]++
 #     else
 #       posters << [poster.id, 1]
 #     end
#      }
 #   posters.sort!{|b,a| a[1] - b[1]}
 #   @posters = posters[0..9].map {|p|
#      poster = Poster.find(p[0])
#      {:id => p[0], 
#	  :query => poster.query, 
#	  :count => p[1], 
#	  :created_at => poster.created_at}
#    }
   
    @recent = Poster.find :all, :order => 'updated_at desc', :limit => 10
	end
end