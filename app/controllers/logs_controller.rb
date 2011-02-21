class LogsController < ApplicationController

  # GET /logs
  # GET /logs.xml
  def index
    @logs = Log.all
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
