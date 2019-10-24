class OnlinePbx::EventsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    if params[:event] == "call_start" || params[:event] == "call_end"
      Call.update_from_webhook!(params)
    end

    head :ok
  end
end
