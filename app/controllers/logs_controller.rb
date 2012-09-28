class LogsController < ApplicationController

  # GET /logs
  # GET /logs.xml
  def index
    @logs = Log.find :all, :order => 'created_at desc', :limit => 40
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @logs }
    end
  end
  
  def all
    @logs = Log.find :all, :order => 'created_at desc'
    @old = Log.find :all, :conditions => ["created_at < ?", Time.now - 30*24*60*60 ]
    
    respond_to do |format|
      format.html # all.html.erb
      format.xml  { render :xml => @logs }
    end
  end


  def clear
    @old = Log.find :all, :conditions => ["created_at < ?", Time.now - 30*24*60*60 ]
    @old = Log.find :all, :order => 'created_at', :limit => 10000
    @old.each { |x| x.destroy }
    
    respond_to do |format|
      format.html { redirect_to(logs_url) }
      format.xml  { head :ok }
    end
  end

    # DELETE /logs/1
  # DELETE /logs/1.xml
  def destroy
    @poster = Log.find(params[:id])
    @poster.destroy

    respond_to do |format|
      format.html { redirect_to(logs_url) }
      format.xml  { head :ok }
    end
  end
end
