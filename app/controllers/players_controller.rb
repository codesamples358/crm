class PlayersController < ApplicationController
  layout :choose_layout

  def index
    @player  = Player.new

    params[:sort_by]    ||= 'created_at'
    params[:sort_order] ||= 'desc'

    scope    = Player.order("\"#{params[:sort_by]}\" #{params[:sort_order]}").paginate(page: params[:page], per_page: PER_PAGE)
    @players = search_scope(scope)
    @player  = Player.new(search_attrs)

    if request.xhr?
      render partial: 'table'
    end
  end

  def new
    if Rails.env.development?
      @player = Player.new(name: "Joe", phone: "+7 (916) 328-8901", city: "Сургут", email: "joe@surgut.com", male: true)
    else
      @player = Player.new(male: true)
    end
  end

  def create
    @player = Player.new(player_params)

    if request.xhr?
      if @player.save
        render json: { status: 'saved', id: @player.id, name: @player.name }
      else
        # render(partial: 'players/form', locals: {player: @player})
        render(partial: 'players/form', locals: {player: @player})
      end

      return
    end

    respond_to do |format|
      format.html do
        if @player.save
          redirect_to players_path, notice: "Игрок добавлен"
        else
          save_error
          render template: 'players/new'
        end
      end
    end
  end

  def edit
    @player = Player.find(params[:id])
    render(action: :new)
  end

  def update
    @player = Player.find(params[:id])

    if @player.update(player_params)
      redirect_to players_path, notice: "Игрок сохранен"
    else
      save_error
      render(action: :new)
    end
  end

  def player_params
    params.require(:player).permit(
      :name, :phone, :email, :phone2, :city, :blacklist,
      :receive_email, :receive_sms, :male, :child_name, :child_birth_date,
      :info_source, :comment
    )
  end

  def by_phone
    player = Player.find_by_phone(params[:phone])
    render json: {id: player.try(:id), name: player.try(:name)}
  end

  protected

  def search_attrs
    attrs = {}

    params[:player].try(:each) do |param, value|
      # next if %w(date_from date_to).include?(param)
      attrs[param] = value if value.present? && value != [""]
    end

    attrs
  end

  def search_scope(scope)
    query_attrs.each do |it|
      scope = it.is_a?(Array) ? scope.where(*it) : scope.where(it)
    end

    scope
  end

  def query_attrs
    result = [ search_attrs.reject { |name, value| %w(created_at name email phone_no_mask).include?(name) } ]

    if c_a = search_attrs['created_at']
      from = Date.parse(c_a).to_time
      to   = from + 24.hours

      result[0][:created_at] = (from .. to)
    end

    %w(name email).each do |attr|
      if value = search_attrs[attr]
        result << ["#{attr} like ? ", "%#{value}%"]
      end
    end

    if value = search_attrs['phone_no_mask']
      result << ["phone like ? ", "%#{value}%"]
    end


    result
  end


  def choose_layout
    params[:popup] == '1' ? 'blank' : 'application'
  end

end
