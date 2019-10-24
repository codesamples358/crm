class CallsController < ApplicationController
  def index
    params[:sort_by]    ||= 'time'
    params[:sort_order] ||= 'desc'

    @calls = Call.order("\"#{params[:sort_by]}\" #{params[:sort_order]}").paginate(page: params[:page], per_page: PER_PAGE)

    if params[:call_type] && params[:call_type].present?
      @calls = @calls.where(call_type: params[:call_type])
    end

    if request.xhr?
      render partial: 'table'
    end
  end

  def show
  end

  def download
    if false && Rails.env.development?
      sleep 2
    else
      render json: { url: call.download_link }
    end
  end

  protected

  def call
    Call.find(params[:id])
  end
end
