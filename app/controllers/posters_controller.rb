require 'open-uri'
require 'rexml/document'
require 'net/http'
require 'uri'

class PostersController < ApplicationController
  # GET /posters
  # GET /posters.xml
  def index
    @posters = Poster.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posters }
    end
  end

  # GET /posters/1
  # GET /posters/1.xml
  def show
    @poster = Poster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @poster }
    end
  end

  # GET /posters/new
  # GET /posters/new.xml
  def new
    @poster = Poster.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @poster }
    end
  end

  # GET /posters/1/edit
  def edit
    @poster = Poster.find(params[:id])
  end

  # POST /posters
  # POST /posters.xml
  def create
    @poster = Poster.new(params[:poster])
redirect_to(@poster)
return

    respond_to do |format|
      if @poster.save
        flash[:notice] = 'Poster was successfully created.'
        format.html { redirect_to(@poster) }
        format.xml  { render :xml => @poster, :status => :created, :location => @poster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @poster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posters/1
  # PUT /posters/1.xml
  def update
    @poster = Poster.find(params[:id])
redirect_to(@poster)
return

    respond_to do |format|
      if @poster.update_attributes(params[:poster])
        flash[:notice] = 'Poster was successfully updated.'
        format.html { redirect_to(@poster) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @poster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posters/1
  # DELETE /posters/1.xml
  def destroy
    @poster = Poster.find(params[:id])
    # @poster.destroy

    respond_to do |format|
      format.html { redirect_to(posters_url) }
      format.xml  { head :ok }
    end
  end
  
  def make
  $KCODE = 'u'
      @poster = Poster.new(params[:poster])
	  @query = @poster.query
	  @escaped = URI.encode("http://tweetimes.heroku.com/posters/format?q=" + @query)
    end

def pdf
 @key = params[:q]
 redirect_to "http://html2pdf.biz/api?url=" +
URI.encode("http://tweetimes.heroku.com/posters/format?q=" + @key) + "&ret=PDF"
end

  
  def format
  
Net::HTTP.version_1_2   # おまじない
    @key = params[:q]
	poster = Poster.new
	poster.query = @key
	result= nil
	url = "search.twitter.com"
	
	Net::HTTP.start(url) { |http|
      response = http.get('/search.atom' + '?q=' + @key  + "&locale=ja&rpp=30",
	  "User-Agent" => "Ruby/#{RUBY_VERSION}")
		if response.code == '200'
		result = REXML::Document.new(response.body)
			@items = []
			result.elements.each("feed/entry"){ |e|
				@items << {
					:author => e.elements['author/name'].text,
					:authorurl => e.elements['author/uri'].text,
					:url =>  e.elements['link'].attributes["href"],
					:date => e.elements['updated'].text,
					:text => e.elements['content'].text,
					:image => REXML::XPath.first(e, "link/attribute::href[2]")
					}
					}
			@items_l = @items[0..14]
			@items_r = @items[15..30]
			poster.result = @items.map {|i| i[:url]}.join(', ')
		else
			@key = @key + " -> " + response.code.to_s
			@items_l =[]
			@items_r= []
			poster.query = @key
			poster.result = response.code.to_s
		end
	  }
   poster.save
  end
	
  # GET /posters/format?q=
  def format2
  @key = params[:q]
	result= nil
  
    url = URI.escape("http://search.twitter.com/search.atom?q=" +
        @key + "&locale=ja&rpp=30")
    open (url) do |f|
      result = REXML::Document.new(f.read)
      @obj = result.elements["feed"]
    end
    @items = []
	result.elements.each("feed/entry"){ |e|
      @items << {
	  :author => e.elements['author/name'].text,
	  	  :authorurl => e.elements['author/uri'].text,
        :url =>  e.elements['link'].attributes["href"],
		        :date => e.elements['updated'].text,
				        :text => e.elements['content'].text,
        :image => REXML::XPath.first(e, "link/attribute::href[2]")
      }
   }
   
   @items_l = @items[0..14]
   @items_r= @items[15..30]

  end
end
