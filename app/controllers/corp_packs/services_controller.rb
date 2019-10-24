class CorpPacks::ServicesController < ApplicationController
  def index
    @corp_pack = CorpPack.find(params[:corp_pack_id])
    @services = Service.select("services.*, corp_pack_services.id as cps_present").joins("left outer join corp_pack_services on corp_pack_services.service_id = services.id and corp_pack_services.corp_pack_id = #{@corp_pack.id}")
    render template: 'services/index', layout: 'blank'

  end
end
