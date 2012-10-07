#require 'open-uri'
require 'rexml/document'
require 'net/http'
require 'uri'
require 'cgi'
Net::HTTP.version_1_2   # おまじない

class PostersController < ApplicationController
  APIKEY = 'R_c34bf15744bdea2f53cc36f81b87cf81'

  # GET /posters
  # GET /posters.xml
  def index
    @posters = Poster.all.reverse

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
    #@query = params[:poster][:query]
    @query = params[:poster][:query].split(/ /).join('+')
    @escaped = URI.encode("http://tweetimes.heroku.com/posters/format/?q=" + @query, '&?=:/ ')
	end

  def pdf
    if params[:q]
      @key = params[:q].split(/ /).join('+')
      longurl = URI.encode("http://tweetimes.heroku.com/posters/format/?q=" + @key, '&?=:/ ')
      Net::HTTP.start('api.bit.ly') { |http|
        response = http.get('/v3/shorten?login=ryokan&apiKey=' + APIKEY + '&longUrl=' + longurl + '&format=txt')
        if response.code == '200'
          redirect_to "http://html2pdf.biz/api?url=" + response.body + "&ret=PDF"
          return
        else
          @query = @key + " -> " + response.code.to_s
          render :action=> 'make'
        end
      }
	  else params[:id]
      longurl = URI.encode("http://tweetimes.heroku.com/posters/format/?id=" + params[:id].to_s, '&?=:/ ')
      redirect_to "http://html2pdf.biz/api?url=" + longurl + "&ret=PDF"
      return
	  end
  end
  
  def format2
    #@q = params[:poster][:query]
    @q = params[:poster][:query].split(/ /).join('+')
    redirect_to :action => "format", :q => @q
    return
  end
  
  def format
    if params[:q]
      @key = URI.decode params[:q]
      mode = params[:mode]
      @poster = Poster.new
      @poster.query = params[:q]

      @poster.mode = 'Web'

      result= nil
      url = "search.twitter.com"
	
      Net::HTTP.start(url) { |http|
        response = http.get('/search.atom' +
            URI.encode('?q=' + @key)  + "&locale=ja&rpp=30",
          "User-Agent" => "Ruby/#{RUBY_VERSION}")
        @poster.code = response.code.to_s
        if response.code == '200'
            result = REXML::Document.new(response.body)
            @items = []
            result.elements.each("feed/entry"){ |e|
                entry = Entry.new
                entry.author = e.elements['author/name'].text.split(' ').first
                entry.authorurl = e.elements['author/uri'].text
                entry.url =  e.elements['link'].attributes["href"]
                entry.date = e.elements['updated'].text
                entry.content = e.elements['content'].text
                entry.image = REXML::XPath.first(e, "link[2]/attribute::href").value
                @items << {
                    :author => entry.author ,
                    :authorurl => entry.authorurl,
                    :url =>  entry.url,
                    :date => entry.date,
                    :text => entry.content,
                    :image => entry.image
                }
                #            @poster.entries << entry
                #           Entry 保存をやめる 
            }
            if @items.size == 0
                @items_l = []
                @items_r = []
                @key = @key + " (No Result) "
            else
                half = @items.size / 2
                @items_l = @items[0..half-1]
                @items_r = @items[half..@items.size]
            end
            
            @poster.result = @items.map {|i| URI.parse(i[:url]).path.split('/').last}.join(', ')
        
        else
            @key = @key + " -> " + response.code.to_s
            @items_l =[]
            @items_r= []
            @poster.result = ""
        end
      }
 ##       @poster.save
        
    elsif  params[:id]
        @poster = Poster.find(params[:id])
        # @poster.mode = 'PDF'
        @key = @poster.query
        
        #  @items = @poster.entries
        
        http = Net::HTTP.new('api.twitter.com')
        @items = []
        @poster.result.split(',').each { |i|
            req = Net::HTTP::Get.new('/1/statuses/show/' + i.to_s.strip + '.xml')
            response = http.request(req)
            if response.code == '200'
                e = REXML::Document.new(response.body)
                @items << {
                    :author => e.elements['status/user/screen_name'].text,
                    :authorurl => e.elements['status/user/url'].text,
                    :url =>  "http://twitter.com/" +  e.elements['status/user/screen_name'].text + "/status/" + i.to_s,
                    :date => e.elements['status/created_at'].text,
                    :text => e.elements['status/text'].text,
                    :image => e.elements['status/user/profile_image_url'].text
                }
            end
        }
        @poster.code = @poster.logs.size # just for record update
 
     if @items.size == 0
        @items_l = []
        @items_r = []
        @key = @key + " (No Result) "
      else
        half = @items.size / 2
        @items_l = @items[0..half-1]
        @items_r = @items[half..@items.size]
      end
      #@poster.save
    end
 @poster.logs << Log.new
    @poster.save
  end
	
  # GET /posters/format?q=
  def formatx
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
        :author => e.elements['author/screen_name'].text,
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



