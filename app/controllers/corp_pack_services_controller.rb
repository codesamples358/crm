class CorpPackServicesController < ApplicationController
  def index
  end

  def create
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
    cps = CorpPackService.find(params[:id])    
    cps.delete

    if request.xhr?

    end

    redirect_to edit_corp_pack_path(cps.corp_pack, anchor: 'services')
  end
end
