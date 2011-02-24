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
