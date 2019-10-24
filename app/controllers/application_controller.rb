class ApplicationController < ActionController::Base
  PER_PAGE = 10

  protect_from_forgery
  before_action :authenticate_user!
  # before_action :set_layout

  protected

  def format_date_ru(_params, name)
    _params[name] = Date.strptime(_params[name], Date::DATE_FORMATS[:default])
  end

  def set_layout
    if params[:no_layout]
      self.class.layout false
    end
  end

  def save_error
    flash.now[:error] = "Ошибка при сохранении"
  end
end
