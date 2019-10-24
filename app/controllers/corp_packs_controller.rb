class CorpPacksController < ApplicationController
  def index
    params[:sort_by]    ||= 'created_at'
    params[:sort_order] ||= 'desc'

    logger.info "SEARCH: #{search_attrs}"
    logger.info "QUERY: #{query_attrs}"

    @corp_packs = CorpPack.where(query_attrs).order("\"#{params[:sort_by]}\" #{params[:sort_order]}").paginate(page: params[:page], per_page: PER_PAGE)
    @corp_pack = CorpPack.new(search_attrs)

    logger.info "CORP PACK is #{@corp_pack.attributes}"

    if request.xhr?
      render partial: 'table'
    end
  end

  def new
    @corp_pack = CorpPack.new
  end

  def edit
    @corp_pack = CorpPack.find(params[:id])

    render action: :new
  end

  def create
    logger.info "PARAMS: #{corp_pack_params}"
    @corp_pack = CorpPack.new_parse_dates(corp_pack_params)


    if @corp_pack.save
      redirect_to corp_packs_path, notice: "Корп. пакет добавлен"
    else
      save_error
      logger.info @corp_pack.errors.messages
      render template: 'corp_packs/new'
    end
  end

  def update
    @corp_pack = CorpPack.find(params[:id])
    @corp_pack.assign_params(corp_pack_params)

    if @corp_pack.save
      redirect_to corp_packs_path, notice: "Корп. пакет сохранен"
    else
      save_error
      logger.info @corp_pack.errors.messages
      render template: 'corp_packs/new'
    end
  end

  def destroy
    @corp_pack = CorpPack.find(params[:id])
    @corp_pack.delete

    redirect_to corp_packs_path
  end

  def corp_pack_params
    _params = params.require(:corp_pack).permit(
      :manager_id, :game_center,
      :mode, :status,
      :call_id,

      :prepayment_type, :prepayment_sum, :prepayment_deadline,

      :payment_type,

      :date, :time,

      :player_id,
      corp_pack_services_attributes: [ :confirmed, :ordered, :price, :cost, :remind_at, :comment, :service_id, :id ]
    )

    # format_date_ru(_params, :date)

    _params
  end

  protected

  def search_attrs
    attrs = {}

    params[:corp_pack].try(:each) do |param, value|
      # next if %w(date_from date_to).include?(param)
      attrs[param] = value if value.present? && value != [""]
    end

    attrs
  end

  def query_attrs
    result = search_attrs.reject { |name, value| %w(date_from date_to).include?(name) }
    f, t = search_attrs['date_from'], search_attrs['date_to']

    if f || t
      from = f && Date.parse(f).to_time || 10.years.ago
      to   = t && (Date.parse(t).to_time + 1) || 10.years.from_now

      result[:datetime] = (from .. to)
    end

    result
  end

end
